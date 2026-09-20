module tw_ROM_retime_v2 #(
    parameter integer WB = 11,   // b word length
    parameter integer FB = 8,   // b fractional bits
    parameter integer DEPTH_64 = 64,
	parameter integer DEPTH_16 = 16,
	parameter integer DEPTH_4 = 4
)(
	input wire clk,
	input wire rst_n,
	input wire in_valid,
	
    input  wire [$clog2(DEPTH_64)-1:0]    addr_6bits,
    input  wire [$clog2(DEPTH_16)-1:0]    addr_4bits,
    input  wire [$clog2(DEPTH_4)-1:0]    addr_2bits,
	
	input [1:0] R_stage1,
	input [1:0] R_stage2,
	input [1:0] R_stage3,	
    
	output reg  signed [WB-1:0]        tw_r_64,
    output reg  signed [WB-1:0]        tw_i_64,
    output reg  signed [WB-1:0]        tw_r_16,
    output reg  signed [WB-1:0]        tw_i_16,
	output reg  signed [WB-1:0]        tw_r_4,
    output reg  signed [WB-1:0]        tw_i_4
);

//reg [WB-1:0] mem_r_64 [0:DEPTH_64-1];
//reg [WB-1:0] mem_i_64 [0:DEPTH_64-1];
//reg [WB-1:0] mem_r_16 [0:DEPTH_16-1];
//reg [WB-1:0] mem_i_16 [0:DEPTH_16-1];
//reg [WB-1:0] mem_r_4 [0:DEPTH_4-1];
//reg [WB-1:0] mem_i_4 [0:DEPTH_4-1];

reg signed  [WB-1:0]        tw_r_64_1;
reg signed  [WB-1:0]        tw_i_64_1;
wire signed [WB-1:0]        tw_r_64_2;
wire signed [WB-1:0]        tw_i_64_2;
wire signed [WB-1:0]        tw_r_64_3;
wire signed [WB-1:0]        tw_i_64_3;
			  
reg signed  [WB-1:0]        tw_r_16_1;
reg signed  [WB-1:0]        tw_i_16_1;
wire signed [WB-1:0]        tw_r_16_2;
wire signed [WB-1:0]        tw_i_16_2;
wire signed [WB-1:0]        tw_r_16_3;
wire signed [WB-1:0]        tw_i_16_3;
			  
reg signed  [WB-1:0]        tw_r_4_1;
reg signed  [WB-1:0]        tw_i_4_1;
wire signed [WB-1:0]        tw_r_4_2;
wire signed [WB-1:0]        tw_i_4_2;
wire signed [WB-1:0]        tw_r_4_3;
wire signed [WB-1:0]        tw_i_4_3;


//initial begin
//    $readmemh("tw64_r.mem", mem_r_64);
//    $readmemh("tw64_i.mem", mem_i_64);
//    $readmemh("tw16_r.mem", mem_r_16);
//    $readmemh("tw16_i.mem", mem_i_16);
//    $readmemh("tw4_r.mem", mem_r_4);
//    $readmemh("tw4_i.mem", mem_i_4);
//end

always @(*) begin
  case (addr_2bits)
	2'b00:   begin tw_r_4_1 = 11'sh100; tw_i_4_1 = 11'sh000; end
	2'b01:   begin tw_r_4_1 = 11'sh0EC; tw_i_4_1 = 11'sh79F; end
	2'b10:   begin tw_r_4_1 = 11'sh0B5; tw_i_4_1 = 11'sh74B; end
	2'b11:   begin tw_r_4_1 = 11'sh061; tw_i_4_1 = 11'sh714; end
    default: begin tw_r_4_1 = 11'sh000; tw_i_4_1 = 11'sh000; end
  endcase
  
  
   case (addr_4bits)
	4'b0000:   begin tw_r_16_1 = 11'sh100; tw_i_16_1 = 11'sh000;  end
	4'b0001:   begin tw_r_16_1 = 11'sh0FE; tw_i_16_1 = 11'sh7E7;  end
	4'b0010:   begin tw_r_16_1 = 11'sh0FB; tw_i_16_1 = 11'sh7CF;  end
	4'b0011:   begin tw_r_16_1 = 11'sh0F4; tw_i_16_1 = 11'sh7B6;  end
	4'b0100:   begin tw_r_16_1 = 11'sh0EC; tw_i_16_1 = 11'sh79F;  end
	4'b0101:   begin tw_r_16_1 = 11'sh0E1; tw_i_16_1 = 11'sh788;  end
	4'b0110:   begin tw_r_16_1 = 11'sh0D4; tw_i_16_1 = 11'sh772;  end
	4'b0111:   begin tw_r_16_1 = 11'sh0C5; tw_i_16_1 = 11'sh75E;  end
	4'b1000:   begin tw_r_16_1 = 11'sh0B5; tw_i_16_1 = 11'sh74B;  end
	4'b1001:   begin tw_r_16_1 = 11'sh0A2; tw_i_16_1 = 11'sh73B;  end
	4'b1010:   begin tw_r_16_1 = 11'sh08E; tw_i_16_1 = 11'sh72C;  end
	4'b1011:   begin tw_r_16_1 = 11'sh078; tw_i_16_1 = 11'sh71F;  end
	4'b1100:   begin tw_r_16_1 = 11'sh061; tw_i_16_1 = 11'sh714;  end
	4'b1101:   begin tw_r_16_1 = 11'sh04A; tw_i_16_1 = 11'sh70C;  end
	4'b1110:   begin tw_r_16_1 = 11'sh031; tw_i_16_1 = 11'sh705;  end
	4'b1111:   begin tw_r_16_1 = 11'sh019; tw_i_16_1 = 11'sh702;  end
	default:   begin tw_r_16_1 = 11'sh000; tw_i_16_1 = 11'sh000;  end
  endcase 
  

   case (addr_6bits)
	6'b000000:   begin tw_r_64_1 = 11'sh100; tw_i_64_1 = 11'sh000;  end
	6'b000001:   begin tw_r_64_1 = 11'sh0FF; tw_i_64_1 = 11'sh7FA;  end
	6'b000010:   begin tw_r_64_1 = 11'sh0FF; tw_i_64_1 = 11'sh7F4;  end
	6'b000011:   begin tw_r_64_1 = 11'sh0FF; tw_i_64_1 = 11'sh7EE;  end
	6'b000100:   begin tw_r_64_1 = 11'sh0FE; tw_i_64_1 = 11'sh7E7;  end
	6'b000101:   begin tw_r_64_1 = 11'sh0FE; tw_i_64_1 = 11'sh7E1;  end
	6'b000110:   begin tw_r_64_1 = 11'sh0FD; tw_i_64_1 = 11'sh7DB;  end
	6'b000111:   begin tw_r_64_1 = 11'sh0FC; tw_i_64_1 = 11'sh7D5;  end
	6'b001000:   begin tw_r_64_1 = 11'sh0FB; tw_i_64_1 = 11'sh7CF;  end
	6'b001001:   begin tw_r_64_1 = 11'sh0F9; tw_i_64_1 = 11'sh7C8;  end
	6'b001010:   begin tw_r_64_1 = 11'sh0F8; tw_i_64_1 = 11'sh7C2;  end
	6'b001011:   begin tw_r_64_1 = 11'sh0F6; tw_i_64_1 = 11'sh7BC;  end
	6'b001100:   begin tw_r_64_1 = 11'sh0F4; tw_i_64_1 = 11'sh7B6;  end
	6'b001101:   begin tw_r_64_1 = 11'sh0F3; tw_i_64_1 = 11'sh7B0;  end
	6'b001110:   begin tw_r_64_1 = 11'sh0F1; tw_i_64_1 = 11'sh7AA;  end
	6'b001111:   begin tw_r_64_1 = 11'sh0EE; tw_i_64_1 = 11'sh7A4;  end
	6'b010000:   begin tw_r_64_1 = 11'sh0EC; tw_i_64_1 = 11'sh79F;  end
	6'b010001:   begin tw_r_64_1 = 11'sh0EA; tw_i_64_1 = 11'sh799;  end
	6'b010010:   begin tw_r_64_1 = 11'sh0E7; tw_i_64_1 = 11'sh793;  end
	6'b010011:   begin tw_r_64_1 = 11'sh0E4; tw_i_64_1 = 11'sh78D;  end
	6'b010100:   begin tw_r_64_1 = 11'sh0E1; tw_i_64_1 = 11'sh788;  end
	6'b010101:   begin tw_r_64_1 = 11'sh0DE; tw_i_64_1 = 11'sh782;  end
	6'b010110:   begin tw_r_64_1 = 11'sh0DB; tw_i_64_1 = 11'sh77D;  end
	6'b010111:   begin tw_r_64_1 = 11'sh0D8; tw_i_64_1 = 11'sh778;  end
	6'b011000:   begin tw_r_64_1 = 11'sh0D4; tw_i_64_1 = 11'sh772;  end
	6'b011001:   begin tw_r_64_1 = 11'sh0D1; tw_i_64_1 = 11'sh76D;  end
	6'b011010:   begin tw_r_64_1 = 11'sh0CD; tw_i_64_1 = 11'sh768;  end
	6'b011011:   begin tw_r_64_1 = 11'sh0C9; tw_i_64_1 = 11'sh763;  end
	6'b011100:   begin tw_r_64_1 = 11'sh0C5; tw_i_64_1 = 11'sh75E;  end
	6'b011101:   begin tw_r_64_1 = 11'sh0C1; tw_i_64_1 = 11'sh759;  end
	6'b011110:   begin tw_r_64_1 = 11'sh0BD; tw_i_64_1 = 11'sh755;  end
	6'b011111:   begin tw_r_64_1 = 11'sh0B9; tw_i_64_1 = 11'sh750;  end	
	6'b100000:   begin tw_r_64_1 = 11'sh0B5; tw_i_64_1 = 11'sh74B;  end
	6'b100001:   begin tw_r_64_1 = 11'sh0B0; tw_i_64_1 = 11'sh747;  end
	6'b100010:   begin tw_r_64_1 = 11'sh0AB; tw_i_64_1 = 11'sh743;  end
	6'b100011:   begin tw_r_64_1 = 11'sh0A7; tw_i_64_1 = 11'sh73F;  end
	6'b100100:   begin tw_r_64_1 = 11'sh0A2; tw_i_64_1 = 11'sh73B;  end
	6'b100101:   begin tw_r_64_1 = 11'sh09D; tw_i_64_1 = 11'sh737;  end
	6'b100110:   begin tw_r_64_1 = 11'sh098; tw_i_64_1 = 11'sh733;  end
	6'b100111:   begin tw_r_64_1 = 11'sh093; tw_i_64_1 = 11'sh72F;  end
	6'b101000:   begin tw_r_64_1 = 11'sh08E; tw_i_64_1 = 11'sh72C;  end
	6'b101001:   begin tw_r_64_1 = 11'sh088; tw_i_64_1 = 11'sh728;  end
	6'b101010:   begin tw_r_64_1 = 11'sh083; tw_i_64_1 = 11'sh725;  end
	6'b101011:   begin tw_r_64_1 = 11'sh07E; tw_i_64_1 = 11'sh722;  end
	6'b101100:   begin tw_r_64_1 = 11'sh078; tw_i_64_1 = 11'sh71F;  end
	6'b101101:   begin tw_r_64_1 = 11'sh073; tw_i_64_1 = 11'sh71C;  end
	6'b101110:   begin tw_r_64_1 = 11'sh06D; tw_i_64_1 = 11'sh719;  end
	6'b101111:   begin tw_r_64_1 = 11'sh067; tw_i_64_1 = 11'sh716;  end	
	6'b110000:   begin tw_r_64_1 = 11'sh061; tw_i_64_1 = 11'sh714;  end
	6'b110001:   begin tw_r_64_1 = 11'sh05C; tw_i_64_1 = 11'sh712;  end
	6'b110010:   begin tw_r_64_1 = 11'sh056; tw_i_64_1 = 11'sh70F;  end
	6'b110011:   begin tw_r_64_1 = 11'sh050; tw_i_64_1 = 11'sh70D;  end
	6'b110100:   begin tw_r_64_1 = 11'sh04A; tw_i_64_1 = 11'sh70C;  end
	6'b110101:   begin tw_r_64_1 = 11'sh044; tw_i_64_1 = 11'sh70A;  end
	6'b110110:   begin tw_r_64_1 = 11'sh03E; tw_i_64_1 = 11'sh708;  end
	6'b110111:   begin tw_r_64_1 = 11'sh038; tw_i_64_1 = 11'sh707;  end
	6'b111000:   begin tw_r_64_1 = 11'sh031; tw_i_64_1 = 11'sh705;  end
	6'b111001:   begin tw_r_64_1 = 11'sh02B; tw_i_64_1 = 11'sh704;  end
	6'b111010:   begin tw_r_64_1 = 11'sh025; tw_i_64_1 = 11'sh703;  end
	6'b111011:   begin tw_r_64_1 = 11'sh01F; tw_i_64_1 = 11'sh702;  end
	6'b111100:   begin tw_r_64_1 = 11'sh019; tw_i_64_1 = 11'sh702;  end
	6'b111101:   begin tw_r_64_1 = 11'sh012; tw_i_64_1 = 11'sh701;  end
	6'b111110:   begin tw_r_64_1 = 11'sh00C; tw_i_64_1 = 11'sh701;  end
	6'b111111:   begin tw_r_64_1 = 11'sh006; tw_i_64_1 = 11'sh701;  end	
	default:     begin tw_r_64_1 = 11'sh000; tw_i_64_1 = 11'sh000;  end
  endcase 


  
end

wire signed [WB-1:0]        tw_r_64_1_reg;
wire signed [WB-1:0]        tw_i_64_1_reg;
wire signed [WB-1:0]        tw_r_64_2_reg;
wire signed [WB-1:0]        tw_i_64_2_reg;

wire signed [WB-1:0]       tw_r_16_1_reg;
wire signed [WB-1:0]       tw_i_16_1_reg;
wire signed [WB-1:0]       tw_r_16_2_reg;
wire signed [WB-1:0]       tw_i_16_2_reg;

wire signed [WB-1:0]       tw_r_4_1_reg;
wire signed [WB-1:0]       tw_i_4_1_reg;
wire signed [WB-1:0]       tw_r_4_2_reg;
wire signed [WB-1:0]       tw_i_4_2_reg;
wire signed [WB-1:0]       tw_r_4_1_reg2;
wire signed [WB-1:0]       tw_i_4_1_reg2;
wire signed [WB-1:0]       tw_r_4_2_reg2;
wire signed [WB-1:0]       tw_i_4_2_reg2;
wire signed [WB-1:0]        tw_r_4_3_reg;
wire signed [WB-1:0]        tw_i_4_3_reg;

always @(*) begin
    //tw_r_64_1 = $signed(mem_r_64[addr_6bits]);
    //tw_i_64_1 = $signed(mem_i_64[addr_6bits]);
    //tw_r_16_1 = $signed(mem_r_16[addr_4bits]);
    //tw_i_16_1 = $signed(mem_i_16[addr_4bits]);
    //tw_r_4_1  = $signed(mem_r_4[addr_2bits]);
    //tw_i_4_1  = $signed(mem_i_4[addr_2bits]);
	
	// for Stage1:
	if (R_stage1 == 2'b00)begin
		//tw_r_64 = {{(WB-1){1'b0}}, 1'b1};
		tw_r_64 = $signed(1) <<< FB;   // 1.0 in Q(WB,FB)
		tw_i_64 = {WB{1'b0}};		
	end
	else if (R_stage1 == 2'b01)begin
		tw_r_64 = tw_r_64_1_reg;
		tw_i_64 = tw_i_64_1_reg;		
	end
	else if (R_stage1 == 2'b10)begin
		tw_r_64 = tw_r_64_2_reg;
		tw_i_64 = tw_i_64_2_reg;
	end
	else if (R_stage1 == 2'b11)begin
		tw_r_64 = tw_r_64_3;
		tw_i_64 = tw_i_64_3;
	end
	
	// for Stage2:
	if (R_stage2 == 2'b00)begin
		tw_r_16 = $signed(1) <<< FB;
		tw_i_16 = {WB{1'b0}};		
	end
	else if (R_stage2 == 2'b01)begin
		tw_r_16 = tw_r_16_1_reg;
		tw_i_16 = tw_i_16_1_reg;		
	end
	else if (R_stage2 == 2'b10)begin
		tw_r_16 = tw_r_16_2_reg;
		tw_i_16 = tw_i_16_2_reg;
	end
	else if (R_stage2 == 2'b11)begin
		tw_r_16 = tw_r_16_3;
		tw_i_16 = tw_i_16_3;
	end	

	// for Stage3:
	if (R_stage3 == 2'b00)begin
		tw_r_4 = $signed(1) <<< FB;
		tw_i_4 = {WB{1'b0}};		
	end
	else if (R_stage3 == 2'b01)begin
		tw_r_4 = tw_r_4_1_reg2;
		tw_i_4 = tw_i_4_1_reg2;		
	end
	else if (R_stage3 == 2'b10)begin
		tw_r_4 = tw_r_4_2_reg2;
		tw_i_4 = tw_i_4_2_reg2;
	end
	else if (R_stage3 == 2'b11)begin
		tw_r_4 = tw_r_4_3_reg;
		tw_i_4 = tw_i_4_3_reg;
	end		
end
reg_p #(WB) R_TW_r_64_1(clk, rst_n, in_valid, tw_r_64_1, tw_r_64_1_reg);
reg_p #(WB) R_TW_i_64_1(clk, rst_n, in_valid, tw_i_64_1, tw_i_64_1_reg);
reg_p #(WB) R_TW_r_64_2(clk, rst_n, in_valid, tw_r_64_2, tw_r_64_2_reg);
reg_p #(WB) R_TW_i_64_2(clk, rst_n, in_valid, tw_i_64_2, tw_i_64_2_reg);

reg_p #(WB) R_TW_r_16_1(clk, rst_n, in_valid, tw_r_16_1, tw_r_16_1_reg);
reg_p #(WB) R_TW_i_16_1(clk, rst_n, in_valid, tw_i_16_1, tw_i_16_1_reg);
reg_p #(WB) R_TW_r_16_2(clk, rst_n, in_valid, tw_r_16_2, tw_r_16_2_reg);
reg_p #(WB) R_TW_i_16_2(clk, rst_n, in_valid, tw_i_16_2, tw_i_16_2_reg);

reg_p #(WB) R_TW_r_4_1(clk, rst_n, in_valid, tw_r_4_1, tw_r_4_1_reg);
reg_p #(WB) R_TW_i_4_1(clk, rst_n, in_valid, tw_i_4_1, tw_i_4_1_reg);
reg_p #(WB) R_TW_r_4_2(clk, rst_n, in_valid, tw_r_4_2, tw_r_4_2_reg);
reg_p #(WB) R_TW_i_4_2(clk, rst_n, in_valid, tw_i_4_2, tw_i_4_2_reg);
reg_p #(WB) R2_TW_r_4_1(clk, rst_n, in_valid, tw_r_4_1_reg, tw_r_4_1_reg2);
reg_p #(WB) R2_TW_i_4_1(clk, rst_n, in_valid, tw_i_4_1_reg, tw_i_4_1_reg2);
reg_p #(WB) R2_TW_r_4_2(clk, rst_n, in_valid, tw_r_4_2_reg, tw_r_4_2_reg2);
reg_p #(WB) R2_TW_i_4_2(clk, rst_n, in_valid, tw_i_4_2_reg, tw_i_4_2_reg2);
reg_p #(WB) R_TW_r_4_3(clk, rst_n, in_valid, tw_r_4_3, tw_r_4_3_reg);
reg_p #(WB) R_TW_i_4_3(clk, rst_n, in_valid, tw_i_4_3, tw_i_4_3_reg);

complex_mul_v2 #(WB, FB, WB, FB, WB, FB) C64_2(tw_r_64_1, tw_i_64_1, tw_r_64_1, tw_i_64_1, tw_r_64_2, tw_i_64_2);
complex_mul_v2 #(WB, FB, WB, FB, WB, FB) C64_3(tw_r_64_1_reg, tw_i_64_1_reg, tw_r_64_2_reg, tw_i_64_2_reg, tw_r_64_3, tw_i_64_3);
complex_mul_v2 #(WB, FB, WB, FB, WB, FB) C16_2(tw_r_16_1, tw_i_16_1, tw_r_16_1, tw_i_16_1, tw_r_16_2, tw_i_16_2);
complex_mul_v2 #(WB, FB, WB, FB, WB, FB) C16_3(tw_r_16_1_reg, tw_i_16_1_reg, tw_r_16_2_reg, tw_i_16_2_reg, tw_r_16_3, tw_i_16_3);
complex_mul_v2 #(WB, FB, WB, FB, WB, FB) C04_2(tw_r_4_1,  tw_i_4_1,  tw_r_4_1,  tw_i_4_1,  tw_r_4_2,  tw_i_4_2);
complex_mul_v2 #(WB, FB, WB, FB, WB, FB) C04_3(tw_r_4_1_reg,  tw_i_4_1_reg,  tw_r_4_2_reg,  tw_i_4_2_reg,  tw_r_4_3,  tw_i_4_3);

endmodule