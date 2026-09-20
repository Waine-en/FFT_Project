module complex_mult_ab #(
    parameter integer WA = 16,
    parameter integer FA = 15,
    parameter integer WB = 16,
    parameter integer FB = 15,
    parameter integer ROUND = 0,   // 1: round-to-nearest(symmetric), 0: truncate
    parameter integer SATURATE = 1
)(
    input  wire signed [WA-1:0] a_r,
    input  wire signed [WA-1:0] a_i,
    input  wire signed [WB-1:0] b_r,
    input  wire signed [WB-1:0] b_i,
    output wire signed [WA-1:0] y_r,
    output wire signed [WA-1:0] y_i
);

    localparam integer MUL_W = WA + WB;
    localparam integer ACC_W = MUL_W + 1;
    localparam integer SHIFT = FB;

    // ----- partial products -----
    wire signed [MUL_W-1:0] ac = a_r * b_r;
    wire signed [MUL_W-1:0] bd = a_i * b_i;
    wire signed [MUL_W-1:0] ad = a_r * b_i;
    wire signed [MUL_W-1:0] bc = a_i * b_r;

    // ----- full precision with guard -----
    wire signed [ACC_W-1:0] real_full = $signed({ac[MUL_W-1], ac}) - $signed({bd[MUL_W-1], bd});
    wire signed [ACC_W-1:0] imag_full = $signed({ad[MUL_W-1], ad}) + $signed({bc[MUL_W-1], bc});

    // ----- half_lsb (avoid SHIFT-1 when SHIFT==0) -----
    wire signed [ACC_W-1:0] half_lsb;

    generate
        if (SHIFT == 0) begin : GEN_H0
            assign half_lsb = {ACC_W{1'b0}};
        end else begin : GEN_H1
            // left shift: << is enough for positive constant; keep width = ACC_W
            assign half_lsb = $signed( ({{(ACC_W-1){1'b0}}, 1'b1}) << (SHIFT-1) );
        end
    endgenerate

    // ----- rounding bias -----
    wire signed [ACC_W-1:0] real_bias =
        (ROUND != 0) ? (real_full[ACC_W-1] ? -half_lsb : half_lsb) : {ACC_W{1'b0}};
    wire signed [ACC_W-1:0] imag_bias =
        (ROUND != 0) ? (imag_full[ACC_W-1] ? -half_lsb : half_lsb) : {ACC_W{1'b0}};

    wire signed [ACC_W-1:0] real_round_in = real_full + real_bias;
    wire signed [ACC_W-1:0] imag_round_in = imag_full + imag_bias;

    // ----- shift back to keep FA bits -----
    wire signed [ACC_W-1:0] real_shift = (SHIFT == 0) ? real_round_in : (real_round_in >>> SHIFT);
    wire signed [ACC_W-1:0] imag_shift = (SHIFT == 0) ? imag_round_in : (imag_round_in >>> SHIFT);

    // ----- saturation constants -----
    localparam signed [WA-1:0] MAXV = {1'b0, {WA-1{1'b1}}};
    localparam signed [WA-1:0] MINV = {1'b1, {WA-1{1'b0}}};

    // sign-extended compare limits in ACC_W domain
    localparam signed [ACC_W-1:0] MAX_ACC = {{(ACC_W-WA){1'b0}}, MAXV};
    localparam signed [ACC_W-1:0] MIN_ACC = {{(ACC_W-WA){1'b1}}, MINV};

    function signed [WA-1:0] sat_wa;
        input signed [ACC_W-1:0] x;
        begin
            if (x > MAX_ACC)      sat_wa = MAXV;
            else if (x < MIN_ACC) sat_wa = MINV;
            else                  sat_wa = x[WA-1:0];
        end
    endfunction

    assign y_r = (SATURATE != 0) ? sat_wa(real_shift) : real_shift[WA-1:0];
    assign y_i = (SATURATE != 0) ? sat_wa(imag_shift) : imag_shift[WA-1:0];

endmodule