module complex_mul_v2 #(
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
    // MATLAB對應:
    // p1 = trunc_fixed_v2(ar .* br, WL-1, FL, mode);
    // p2 = trunc_fixed_v2(ai .* bi, WL-1, FL, mode);
    // p3 = trunc_fixed_v2(ar .* bi, WL-1, FL, mode);
    // p4 = trunc_fixed_v2(ai .* br, WL-1, FL, mode);
    //
    // yr = trunc_fixed_v2(p1 - p2, WL, FL, mode);
    // yi = trunc_fixed_v2(p3 + p4, WL, FL, mode);
    // ============================================================

    // Stage 1: 4 multiplications, each truncated to (WY-1, FY)
    wire signed [WY-2:0] p1, p2, p3, p4;

    real_mul #(
        .WA(WA),   .FA(FA),
        .WB(WB),   .FB(FB),
        .WY(WY-1), .FY(FY)
    ) u_mul_p1 (
        .a(a_r),
        .b(b_r),
        .y(p1)
    );

    real_mul #(
        .WA(WA),   .FA(FA),
        .WB(WB),   .FB(FB),
        .WY(WY-1), .FY(FY)
    ) u_mul_p2 (
        .a(a_i),
        .b(b_i),
        .y(p2)
    );

    real_mul #(
        .WA(WA),   .FA(FA),
        .WB(WB),   .FB(FB),
        .WY(WY-1), .FY(FY)
    ) u_mul_p3 (
        .a(a_r),
        .b(b_i),
        .y(p3)
    );

    real_mul #(
        .WA(WA),   .FA(FA),
        .WB(WB),   .FB(FB),
        .WY(WY-1), .FY(FY)
    ) u_mul_p4 (
        .a(a_i),
        .b(b_r),
        .y(p4)
    );

    // Stage 2: add/sub, truncated to (WY, FY)
    real_sub #(
        .WA(WY-1), .FA(FY),
        .WB(WY-1), .FB(FY),
        .WY(WY),   .FY(FY)
    ) u_sub_real (
        .a(p1),
        .b(p2),
        .y(y_r)
    );

    real_add #(
        .WA(WY-1), .FA(FY),
        .WB(WY-1), .FB(FY),
        .WY(WY),   .FY(FY)
    ) u_add_imag (
        .a(p3),
        .b(p4),
        .y(y_i)
    );

endmodule