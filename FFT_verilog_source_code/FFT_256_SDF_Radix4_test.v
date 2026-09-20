`timescale 1 ns/10 ps
`define CYCLE 3.75
module FFT_256_SDF_Radix4_test();

//parameter INPUT_BIT = 13;
//parameter OUTPUT_BIT = 14;
parameter INPUT_BIT = 17;
parameter OUTPUT_BIT = 17;
parameter SYMBOL_NUMBER = 1000;
parameter DATA_NUMBER = 256 * SYMBOL_NUMBER;
parameter DATA_NUMBER1 = 256 * 10;
parameter DATA_NUMBER2 = 256 * (SYMBOL_NUMBER + 2);

integer err_cnt;
integer cmp_cnt;
integer addr;
// input/output declaration:
reg clk, rst_n, in_valid;
reg signed [INPUT_BIT-1:0] In_real;
reg signed [INPUT_BIT-1:0] In_imag;
reg signed [INPUT_BIT-1:0] mem_real [0:DATA_NUMBER2 - 1];  // 你的 memory
reg signed [INPUT_BIT-1:0] mem_imag [0:DATA_NUMBER2 - 1]; 
reg signed [OUTPUT_BIT-1:0] gold_men_real [0:DATA_NUMBER - 1]; 
reg signed [OUTPUT_BIT-1:0] gold_men_imag [0:DATA_NUMBER - 1]; 


wire signed [OUTPUT_BIT-1:0] Out_real;
wire signed [OUTPUT_BIT-1:0] Out_imag;
wire [7:0]	addr_reg_256_reorder;
wire compare;
FFT_256_SDF_Radix4 F1(
	In_real,
	In_imag,
	in_valid,
	rst_n,
	clk,
	
	Out_real,
	Out_imag,
	addr_reg_256_reorder,
	compare
);

// ======================================================
// Compare logic: when compare==1, compare DATA_NUMBER samples
// ======================================================
reg done;
parameter integer SAMPLE_NUM = 256;

integer SYMBOL_NUM;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        err_cnt <= 0;
        cmp_cnt <= 0;
        SYMBOL_NUM <= 0;		
        done    <= 1'b0;
    end else begin
        if (!done && compare) begin
            // mismatch includes X/Z detection via !==
            if ( (Out_real != gold_men_real[cmp_cnt]) ||
                 (Out_imag != gold_men_imag[cmp_cnt]) ) begin
                err_cnt <= err_cnt + 1;

                $display("[%0t] MISMATCH idx=%0d (gold_addr=%0d) addr_reorder=%0d",
                         $time, cmp_cnt, cmp_cnt, addr_reg_256_reorder);
                $display("    OUT : real=%0d (0x%0h), imag=%0d (0x%0h)",
                         Out_real, Out_real, Out_imag, Out_imag);
                $display("    GOLD: real=%0d (0x%0h), imag=%0d (0x%0h)\n",
                         gold_men_real[cmp_cnt], gold_men_real[cmp_cnt],
                         gold_men_imag[cmp_cnt], gold_men_imag[cmp_cnt]);
           end else begin
			    // 每成功比對 SAMPLE_NUM 筆資料，完成一個 SYMBOL
                if (((cmp_cnt + 1) % SAMPLE_NUM) == 0) begin
                    SYMBOL_NUM <= SYMBOL_NUM + 1;

                    $display("[%0t] SYMBOL_NUM = %0d",
                             $time, SYMBOL_NUM + 1);
                end
				// advance gold address / compare count
	
				if (cmp_cnt == DATA_NUMBER1-1) begin
					done <= 1'b1;
					// 用 strobe 讓 err_cnt 的 NBA 更新後再印
					$strobe("================================================\n");
					$strobe("================================================\n");
					$strobe("==== COMPARE DONE: total=%0d, errors=%0d ====\n", DATA_NUMBER1, err_cnt);
					$strobe("================================================\n");
					$strobe("================================================\n");
					// 給一點點時間讓 $strobe 印完
					#10 $finish;
				end else begin
					cmp_cnt <= cmp_cnt + 1;
				end
							
			
			end
        end
    end
end
// ======================================================
// Compare logic end
// ======================================================

always begin
	#(`CYCLE*0.5) clk=~clk;
end

initial begin
	rst_n = 0; 
	clk = 0;
	addr = 0;
	in_valid = 1'b0;
	In_real = {INPUT_BIT{1'b0}};
	In_imag = {INPUT_BIT{1'b0}};
	
	// 讀input檔案
	$readmemh("./00_TESTBED_v5/in_real.mem", mem_real);
	$readmemh("./00_TESTBED_v5/in_imag.mem", mem_imag);
	$readmemh("./00_TESTBED_v5/out_real.mem", gold_men_real);
	$readmemh("./00_TESTBED_v5/out_imag.mem", gold_men_imag);	
	
	#(`CYCLE*1.75);
	rst_n = 1; 	
	
  // 對齊到下一個 posedge 再開始送（避免半拍對不齊）
  @(negedge clk);
	
  // === 給 input：每 cycle addr+1 並送出 mem ===
  repeat (DATA_NUMBER2) begin
    in_valid = 1'b1;
    In_real = mem_real[addr];   // 或 blocking "=" 也行，看你想同步/組合
    In_imag = mem_imag[addr];
	if (addr <= DATA_NUMBER2) begin
		addr = addr + 1;
	end
	else begin
		addr = addr;
	end

    @(negedge clk);
  end
  // Keep the enabled pipeline moving so the tail samples can drain.
  forever begin
    in_valid = 1'b1;
    In_real = {INPUT_BIT{1'b0}};
    In_imag = {INPUT_BIT{1'b0}};
    @(negedge clk);
  end

  // 跑一段時間或直接結束
 // #(`CYCLE*100);
 // $finish;
end

initial
begin
//$fsdbDumpfile("FFT_256_SDF_Radix4_test.fsdb");
//$fsdbDumpvars;
$dumpfile("FFT_256_SDF_Radix4_test.fsdb");
$dumpvars;
//$dumpfile("TESTVG.vcd");
//$dumpvars;
//$sdf_annotate("XXX.sdf", testtop);
end 
endmodule
