module complex_mult_ab_v2 #(
    parameter integer WA = 16,
    parameter integer FA = 15,
    parameter integer WB = 16,
    parameter integer FB = 15,
    parameter integer WY = 16,
    parameter integer FY = 15
)(
    input  wire signed [WA-1:0] a_r,
    input  wire signed [WA-1:0] a_i,
    input  wire signed [WB-1:0] b_r,
    input  wire signed [WB-1:0] b_i,
    output wire signed [WY-1:0] y_r,
    output wire signed [WY-1:0] y_i
);

    // ============================================================
    // 1) Internal format selection
    //    複數乘法後:
    //      real = a_r*b_r - a_i*b_i
    //      imag = a_r*b_i + a_i*b_r
    //
    //    每個乘積的小數位數為 FA+FB
    // ============================================================
    localparam integer FINT = FA + FB;

    // 單一乘積位寬
    localparam integer WMUL = WA + WB;

    // 加減法結果多 1 bit guard bit
    localparam integer WSUM = WMUL + 1;

    // 為了後續轉成 FY，若 FY > FINT，左移可能需要更多位元
    localparam integer FSHIFT_UP = (FY > FINT) ? (FY - FINT) : 0;
    localparam integer WCVT = WSUM + FSHIFT_UP;

    // ============================================================
    // 2) Partial products
    // ============================================================
    wire signed [WMUL-1:0] mul_ar_br, mul_ai_bi;
    wire signed [WMUL-1:0] mul_ar_bi, mul_ai_br;

    assign mul_ar_br = a_r * b_r;
    assign mul_ai_bi = a_i * b_i;
    assign mul_ar_bi = a_r * b_i;
    assign mul_ai_br = a_i * b_r;

    // ============================================================
    // 3) Complex multiplication
    // ============================================================
    wire signed [WSUM-1:0] sum_r, sum_i;

    assign sum_r =
        $signed({mul_ar_br[WMUL-1], mul_ar_br}) -
        $signed({mul_ai_bi[WMUL-1], mul_ai_bi});

    assign sum_i =
        $signed({mul_ar_bi[WMUL-1], mul_ar_bi}) +
        $signed({mul_ai_br[WMUL-1], mul_ai_br});

    // ============================================================
    // 4) Convert from internal format (WSUM, FINT) to output (WY, FY)
    //    - FY < FINT : arithmetic right shift => truncation
    //    - FY > FINT : left shift
    // ============================================================
    wire signed [WCVT-1:0] sum_r_ext, sum_i_ext;
    assign sum_r_ext = {{(WCVT-WSUM){sum_r[WSUM-1]}}, sum_r};
    assign sum_i_ext = {{(WCVT-WSUM){sum_i[WSUM-1]}}, sum_i};

    wire signed [WCVT-1:0] y_r_full, y_i_full;

    generate
        if (FY >= FINT) begin : GEN_LEFT_SHIFT
            assign y_r_full = $signed(sum_r_ext) <<< (FY - FINT);
            assign y_i_full = $signed(sum_i_ext) <<< (FY - FINT);
        end else begin : GEN_RIGHT_SHIFT
            assign y_r_full = $signed(sum_r_ext) >>> (FINT - FY);
            assign y_i_full = $signed(sum_i_ext) >>> (FINT - FY);
        end
    endgenerate

    // ============================================================
    // 5) Output truncation to WY bits
    //    保留原始 sign bit，其餘保留低位 bits
    // ============================================================
 //   assign y_r = {y_r_full[WCVT-1], y_r_full[WY-2:0]};
 //   assign y_i = {y_i_full[WCVT-1], y_i_full[WY-2:0]};
	generate
		if (WY >= WCVT) begin : GEN_OUT_EXT
			assign y_r = {{(WY-WCVT){y_r_full[WCVT-1]}}, y_r_full};
			assign y_i = {{(WY-WCVT){y_i_full[WCVT-1]}}, y_i_full};
		end else begin : GEN_OUT_TRUNC
			assign y_r = y_r_full[WY-1:0];
			assign y_i = y_i_full[WY-1:0];
		end
	endgenerate
endmodule