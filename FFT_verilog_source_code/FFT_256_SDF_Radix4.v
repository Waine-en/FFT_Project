module FFT_256_SDF_Radix4(
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

// ============================================================================
// Parameter declaration
// ============================================================================
/*
parameter WL_x = 13;
parameter FL_x = WL_x - 3;

parameter WL_Y_stage1 = 15;
parameter FL_Y_stage1 = WL_Y_stage1 - 5;

parameter WL_Y_stage2 = 15;
parameter FL_Y_stage2 = WL_Y_stage2 - 6;

parameter WL_Y_stage3 = 14;
parameter FL_Y_stage3 = WL_Y_stage3 - 6;

parameter WL_Y_stage4 = 14;
parameter FL_Y_stage4 = WL_Y_stage4 - 6;

parameter WL_tw = 10;
parameter FL_tw = 8;
*/
parameter WL_x = 17;
parameter FL_x = WL_x - 3;

parameter WL_Y_stage1 = 19;
parameter FL_Y_stage1 = WL_Y_stage1 - 5;

parameter WL_Y_stage2 = 19;
parameter FL_Y_stage2 = WL_Y_stage2 - 6;

parameter WL_Y_stage3 = 18;
parameter FL_Y_stage3 = WL_Y_stage3 - 6;

parameter WL_Y_stage4 = 17;
parameter FL_Y_stage4 = WL_Y_stage4 - 6;

parameter WL_tw = 11;
parameter FL_tw = 8;






parameter STAGE1_DELAY = 64;
parameter STAGE2_DELAY = 16;
parameter STAGE3_DELAY = 4;
parameter STAGE4_DELAY = 1;


// ============================================================================
// Input / Output
// ============================================================================

input signed [WL_x-1:0] In_real;
input signed [WL_x-1:0] In_imag;
input in_valid;

input clk;
input rst_n;

output wire signed [WL_Y_stage4-1:0] Out_real;
output wire signed [WL_Y_stage4-1:0] Out_imag;

output wire [7:0] addr_reg_256_reorder;

output wire compare;


// ============================================================================
// Input / Output register
// ============================================================================

wire signed [WL_x-1:0] In_real_reg;
wire signed [WL_x-1:0] In_imag_reg;

wire signed [WL_Y_stage4-1:0] Out_real_reg;
wire signed [WL_Y_stage4-1:0] Out_imag_reg;


// ============================================================================
// Stage 1
// ============================================================================

wire signed [WL_Y_stage1-1:0] X0_stage1_real;
wire signed [WL_Y_stage1-1:0] X0_stage1_imag;

wire signed [WL_Y_stage1-1:0] X1_stage1_real;
wire signed [WL_Y_stage1-1:0] X1_stage1_imag;

wire signed [WL_Y_stage1-1:0] X2_stage1_real;
wire signed [WL_Y_stage1-1:0] X2_stage1_imag;


wire signed [WL_Y_stage1-1:0] Y0_stage1_real;
wire signed [WL_Y_stage1-1:0] Y0_stage1_imag;

wire signed [WL_Y_stage1-1:0] Y1_stage1_real;
wire signed [WL_Y_stage1-1:0] Y1_stage1_imag;

wire signed [WL_Y_stage1-1:0] Y2_stage1_real;
wire signed [WL_Y_stage1-1:0] Y2_stage1_imag;

wire signed [WL_Y_stage1-1:0] Y3_stage1_real;
wire signed [WL_Y_stage1-1:0] Y3_stage1_imag;


// Stage1 butterfly -> multiplier pipeline
wire signed [WL_Y_stage1-1:0] Y3_stage1_real_reg1;
wire signed [WL_Y_stage1-1:0] Y3_stage1_imag_reg1;


// ============================================================================
// Stage 2
// ============================================================================

wire signed [WL_Y_stage2-1:0] X3_stage2_real;
wire signed [WL_Y_stage2-1:0] X3_stage2_imag;

wire signed [WL_Y_stage2-1:0] X0_stage2_real;
wire signed [WL_Y_stage2-1:0] X0_stage2_imag;

wire signed [WL_Y_stage2-1:0] X1_stage2_real;
wire signed [WL_Y_stage2-1:0] X1_stage2_imag;

wire signed [WL_Y_stage2-1:0] X2_stage2_real;
wire signed [WL_Y_stage2-1:0] X2_stage2_imag;


wire signed [WL_Y_stage2-1:0] Y0_stage2_real;
wire signed [WL_Y_stage2-1:0] Y0_stage2_imag;

wire signed [WL_Y_stage2-1:0] Y1_stage2_real;
wire signed [WL_Y_stage2-1:0] Y1_stage2_imag;

wire signed [WL_Y_stage2-1:0] Y2_stage2_real;
wire signed [WL_Y_stage2-1:0] Y2_stage2_imag;

wire signed [WL_Y_stage2-1:0] Y3_stage2_real;
wire signed [WL_Y_stage2-1:0] Y3_stage2_imag;


// Stage2 butterfly -> multiplier pipeline
wire signed [WL_Y_stage2-1:0] Y3_stage2_real_reg1;
wire signed [WL_Y_stage2-1:0] Y3_stage2_imag_reg1;


// ============================================================================
// Stage 3
// ============================================================================

wire signed [WL_Y_stage3-1:0] X3_stage3_real;
wire signed [WL_Y_stage3-1:0] X3_stage3_imag;

wire signed [WL_Y_stage3-1:0] X0_stage3_real;
wire signed [WL_Y_stage3-1:0] X0_stage3_imag;

wire signed [WL_Y_stage3-1:0] X1_stage3_real;
wire signed [WL_Y_stage3-1:0] X1_stage3_imag;

wire signed [WL_Y_stage3-1:0] X2_stage3_real;
wire signed [WL_Y_stage3-1:0] X2_stage3_imag;


wire signed [WL_Y_stage3-1:0] Y0_stage3_real;
wire signed [WL_Y_stage3-1:0] Y0_stage3_imag;

wire signed [WL_Y_stage3-1:0] Y1_stage3_real;
wire signed [WL_Y_stage3-1:0] Y1_stage3_imag;

wire signed [WL_Y_stage3-1:0] Y2_stage3_real;
wire signed [WL_Y_stage3-1:0] Y2_stage3_imag;

wire signed [WL_Y_stage3-1:0] Y3_stage3_real;
wire signed [WL_Y_stage3-1:0] Y3_stage3_imag;


// Stage3 butterfly -> multiplier pipeline
wire signed [WL_Y_stage3-1:0] Y3_stage3_real_reg1;
wire signed [WL_Y_stage3-1:0] Y3_stage3_imag_reg1;


// ============================================================================
// Stage 4
// ============================================================================

wire signed [WL_Y_stage4-1:0] X3_stage4_real;
wire signed [WL_Y_stage4-1:0] X3_stage4_imag;

wire signed [WL_Y_stage4-1:0] X0_stage4_real;
wire signed [WL_Y_stage4-1:0] X0_stage4_imag;

wire signed [WL_Y_stage4-1:0] X1_stage4_real;
wire signed [WL_Y_stage4-1:0] X1_stage4_imag;

wire signed [WL_Y_stage4-1:0] X2_stage4_real;
wire signed [WL_Y_stage4-1:0] X2_stage4_imag;


wire signed [WL_Y_stage4-1:0] Y0_stage4_real;
wire signed [WL_Y_stage4-1:0] Y0_stage4_imag;

wire signed [WL_Y_stage4-1:0] Y1_stage4_real;
wire signed [WL_Y_stage4-1:0] Y1_stage4_imag;

wire signed [WL_Y_stage4-1:0] Y2_stage4_real;
wire signed [WL_Y_stage4-1:0] Y2_stage4_imag;


// ============================================================================
// Address
// ============================================================================

wire [7:0] addr_reg_256;
wire [5:0] addr_reg_64;
wire [3:0] addr_reg_16;
wire [1:0] addr_reg_4;
wire       addr_reg_1;


// ============================================================================
// Control
// ============================================================================

wire [1:0] R_stage1;
wire [1:0] R_stage2;
wire [1:0] R_stage3;
wire [1:0] R_stage4;


// ============================================================================
// Datapath control alignment
//
// Stage2 butterfly = +1
// Stage3 butterfly = +2
// Stage4 butterfly = +3
// ============================================================================

wire [1:0] R_stage2_reg1;
wire [1:0] R_stage3_reg2;
wire [1:0] R_stage4_reg3;


// ============================================================================
// tw_ROM_retime control alignment
//
// tw64 effective datapath = +1
// tw16 effective datapath = +2
// tw4  effective datapath = +3
//
// NOTE:
// ROM output mux itself directly uses R_stageX,
// therefore these controls must represent the final aligned epoch.
// ============================================================================

wire [1:0] R_stage1_tw_reg1;
wire [1:0] R_stage2_tw_reg2;
wire [1:0] R_stage3_tw_reg3;


// ============================================================================
// Twiddle ROM address pre-alignment
//
// Stage1:
//     raw addr64
//     + ROM internal 1 cycle
//     = total 1
//
// Stage2:
//     addr16 +1
//     + ROM internal 1 cycle
//     = total 2
//
// Stage3:
//     addr4 +1
//     + ROM internal 2 cycles
//     = total 3
// ============================================================================

wire [3:0] addr_reg_16_tw_reg1;
wire [1:0] addr_reg_4_tw_reg1;


// ============================================================================
// Twiddle outputs
// ============================================================================

wire signed [WL_tw-1:0] tw_r_64;
wire signed [WL_tw-1:0] tw_i_64;

wire signed [WL_tw-1:0] tw_r_16;
wire signed [WL_tw-1:0] tw_i_16;

wire signed [WL_tw-1:0] tw_r_4;
wire signed [WL_tw-1:0] tw_i_4;


// ============================================================================
// Compare / reorder
// ============================================================================

reg compare_origin;

wire [7:0] addr_reg_256_reorder_origin;


// ============================================================================
// Stage 0
// ============================================================================

reg_p #(WL_x) R_IN_REAL(
    clk,
    rst_n,
    in_valid,
    In_real,
    In_real_reg
);

reg_p #(WL_x) R_IN_IMAG(
    clk,
    rst_n,
    in_valid,
    In_imag,
    In_imag_reg
);


reg_p #(WL_Y_stage4) R_OUT_REAL(
    clk,
    rst_n,
    in_valid,
    Out_real_reg,
    Out_real
);

reg_p #(WL_Y_stage4) R_OUT_IMAG(
    clk,
    rst_n,
    in_valid,
    Out_imag_reg,
    Out_imag
);


// ============================================================================
// Address generator
// ============================================================================

address_generator A1(
    clk,
    rst_n,
    in_valid,

    addr_reg_256,
    addr_reg_64,
    addr_reg_16,
    addr_reg_4,
    addr_reg_1
);


// ============================================================================
// Control unit
// ============================================================================

control_unit CU1(
    clk,
    rst_n,
    in_valid,

    addr_reg_64,
    addr_reg_16,
    addr_reg_4,
    addr_reg_1,

    R_stage1,
    R_stage2,
    R_stage3,
    R_stage4
);


// ============================================================================
// Datapath control alignment
// ============================================================================

// Stage2 butterfly:
// previous Stage1 pipeline = +1
reg_p #(2) REG_STAGE2(
    clk,
    rst_n,
    in_valid,
    R_stage2,
    R_stage2_reg1
);


// Stage3 butterfly:
// Stage1 + Stage2 pipeline = +2
delay_line #(2, 2) REG_STAGE3(
    clk,
    rst_n,
    in_valid,
    R_stage3,
    R_stage3_reg2
);


// Stage4 butterfly:
// Stage1 + Stage2 + Stage3 pipeline = +3
delay_line #(2, 3) REG_STAGE4(
    clk,
    rst_n,
    in_valid,
    R_stage4,
    R_stage4_reg3
);


// ============================================================================
// tw_ROM_retime control alignment
// ============================================================================

// Stage1 twiddle final epoch = +1
reg_p #(2) REG_TW_CONTROL_STAGE1(
    clk,
    rst_n,
    in_valid,
    R_stage1,
    R_stage1_tw_reg1
);


// Stage2 twiddle final epoch = +2
delay_line #(2, 2) REG_TW_CONTROL_STAGE2(
    clk,
    rst_n,
    in_valid,
    R_stage2,
    R_stage2_tw_reg2
);


// Stage3 twiddle final epoch = +3
delay_line #(2, 3) REG_TW_CONTROL_STAGE3(
    clk,
    rst_n,
    in_valid,
    R_stage3,
    R_stage3_tw_reg3
);


// ============================================================================
// tw_ROM_retime address alignment
// ============================================================================

// Stage1:
// addr_reg_64 is used directly.
// ROM itself supplies the required +1 pipeline.

// Stage2:
// pre-delay address by one.
// ROM itself contains another +1.
reg_p #(4) REG_TW_ADDR16(
    clk,
    rst_n,
    in_valid,
    addr_reg_16,
    addr_reg_16_tw_reg1
);


// Stage3:
// pre-delay address by one.
// ROM itself contains another +2.
reg_p #(2) REG_TW_ADDR4(
    clk,
    rst_n,
    in_valid,
    addr_reg_4,
    addr_reg_4_tw_reg1
);


// ============================================================================
// tw_ROM_retime
//
// IMPORTANT:
// No additional twiddle output register is required here.
// tw_ROM_retime now contains the multiplication pipeline internally.
// ============================================================================

tw_ROM_retime_v2 #(
    WL_tw,
    FL_tw,
    STAGE1_DELAY,
    STAGE2_DELAY,
    STAGE3_DELAY
) tw_ROM1(
    clk,
    rst_n,
    in_valid,

    addr_reg_64,
    addr_reg_16_tw_reg1,
    addr_reg_4_tw_reg1,

    R_stage1_tw_reg1,
    R_stage2_tw_reg2,
    R_stage3_tw_reg3,

    tw_r_64,
    tw_i_64,

    tw_r_16,
    tw_i_16,

    tw_r_4,
    tw_i_4
);


// ============================================================================
// Compare
//
// Datapath receives total +3 cycles.
// ============================================================================

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        compare_origin <= 1'b0;
    end
    else if (in_valid) begin
        if (
            (R_stage1 == 2'b11) &&
            (R_stage2 == 2'b11) &&
            (R_stage3 == 2'b11) &&
            (R_stage4 == 2'b11)
        ) begin
            compare_origin <= 1'b1;
        end
    end
end


delay_line #(1, 3) REG_COMPARE(
    clk,
    rst_n,
    in_valid,
    compare_origin,
    compare
);


// ============================================================================
// Stage 1
// ============================================================================

radix4_butterfly_inc_control #(
    WL_x,
    WL_Y_stage1
) RADIX_STAGE1(
    X0_stage1_real,
    X0_stage1_imag,

    X1_stage1_real,
    X1_stage1_imag,

    X2_stage1_real,
    X2_stage1_imag,

    In_real_reg,
    In_imag_reg,

    R_stage1,

    Y0_stage1_real,
    Y0_stage1_imag,

    Y1_stage1_real,
    Y1_stage1_imag,

    Y2_stage1_real,
    Y2_stage1_imag,

    Y3_stage1_real,
    Y3_stage1_imag
);


// ============================================================================
// Stage1 SDF delay
// ============================================================================

delay_line #(WL_Y_stage1, STAGE1_DELAY)
DFF_STAGE1_Y0_REAL(
    clk,
    rst_n,
    in_valid,
    Y0_stage1_real,
    X0_stage1_real
);

delay_line #(WL_Y_stage1, STAGE1_DELAY)
DFF_STAGE1_Y0_IMAG(
    clk,
    rst_n,
    in_valid,
    Y0_stage1_imag,
    X0_stage1_imag
);


delay_line #(WL_Y_stage1, STAGE1_DELAY)
DFF_STAGE1_Y1_REAL(
    clk,
    rst_n,
    in_valid,
    Y1_stage1_real,
    X1_stage1_real
);

delay_line #(WL_Y_stage1, STAGE1_DELAY)
DFF_STAGE1_Y1_IMAG(
    clk,
    rst_n,
    in_valid,
    Y1_stage1_imag,
    X1_stage1_imag
);


delay_line #(WL_Y_stage1, STAGE1_DELAY)
DFF_STAGE1_Y2_REAL(
    clk,
    rst_n,
    in_valid,
    Y2_stage1_real,
    X2_stage1_real
);

delay_line #(WL_Y_stage1, STAGE1_DELAY)
DFF_STAGE1_Y2_IMAG(
    clk,
    rst_n,
    in_valid,
    Y2_stage1_imag,
    X2_stage1_imag
);


// ============================================================================
// Stage1 butterfly -> multiplier pipeline
// ============================================================================

reg_p #(WL_Y_stage1) R_Y3_STAGE1_REAL(
    clk,
    rst_n,
    in_valid,
    Y3_stage1_real,
    Y3_stage1_real_reg1
);

reg_p #(WL_Y_stage1) R_Y3_STAGE1_IMAG(
    clk,
    rst_n,
    in_valid,
    Y3_stage1_imag,
    Y3_stage1_imag_reg1
);


// ============================================================================
// Stage1 multiplier
// ============================================================================

complex_mul_v2 #(
    WL_Y_stage1,
    FL_Y_stage1,

    WL_tw,
    FL_tw,

    WL_Y_stage2,
    FL_Y_stage2
) C_STAGE1(
    Y3_stage1_real_reg1,
    Y3_stage1_imag_reg1,

    tw_r_64,
    tw_i_64,

    X3_stage2_real,
    X3_stage2_imag
);


// ============================================================================
// Stage 2
// ============================================================================

radix4_butterfly_inc_control #(
    WL_Y_stage2,
    WL_Y_stage2
) RADIX_STAGE2(
    X0_stage2_real,
    X0_stage2_imag,

    X1_stage2_real,
    X1_stage2_imag,

    X2_stage2_real,
    X2_stage2_imag,

    X3_stage2_real,
    X3_stage2_imag,

    R_stage2_reg1,

    Y0_stage2_real,
    Y0_stage2_imag,

    Y1_stage2_real,
    Y1_stage2_imag,

    Y2_stage2_real,
    Y2_stage2_imag,

    Y3_stage2_real,
    Y3_stage2_imag
);


// ============================================================================
// Stage2 SDF delay
// ============================================================================

delay_line #(WL_Y_stage2, STAGE2_DELAY)
DFF_STAGE2_Y0_REAL(
    clk,
    rst_n,
    in_valid,
    Y0_stage2_real,
    X0_stage2_real
);

delay_line #(WL_Y_stage2, STAGE2_DELAY)
DFF_STAGE2_Y0_IMAG(
    clk,
    rst_n,
    in_valid,
    Y0_stage2_imag,
    X0_stage2_imag
);


delay_line #(WL_Y_stage2, STAGE2_DELAY)
DFF_STAGE2_Y1_REAL(
    clk,
    rst_n,
    in_valid,
    Y1_stage2_real,
    X1_stage2_real
);

delay_line #(WL_Y_stage2, STAGE2_DELAY)
DFF_STAGE2_Y1_IMAG(
    clk,
    rst_n,
    in_valid,
    Y1_stage2_imag,
    X1_stage2_imag
);


delay_line #(WL_Y_stage2, STAGE2_DELAY)
DFF_STAGE2_Y2_REAL(
    clk,
    rst_n,
    in_valid,
    Y2_stage2_real,
    X2_stage2_real
);

delay_line #(WL_Y_stage2, STAGE2_DELAY)
DFF_STAGE2_Y2_IMAG(
    clk,
    rst_n,
    in_valid,
    Y2_stage2_imag,
    X2_stage2_imag
);


// ============================================================================
// Stage2 butterfly -> multiplier pipeline
// ============================================================================

reg_p #(WL_Y_stage2) R_Y3_STAGE2_REAL(
    clk,
    rst_n,
    in_valid,
    Y3_stage2_real,
    Y3_stage2_real_reg1
);

reg_p #(WL_Y_stage2) R_Y3_STAGE2_IMAG(
    clk,
    rst_n,
    in_valid,
    Y3_stage2_imag,
    Y3_stage2_imag_reg1
);


// ============================================================================
// Stage2 multiplier
// ============================================================================

complex_mul_v2 #(
    WL_Y_stage2,
    FL_Y_stage2,

    WL_tw,
    FL_tw,

    WL_Y_stage3,
    FL_Y_stage3
) C_STAGE2(
    Y3_stage2_real_reg1,
    Y3_stage2_imag_reg1,

    tw_r_16,
    tw_i_16,

    X3_stage3_real,
    X3_stage3_imag
);


// ============================================================================
// Stage 3
// ============================================================================

radix4_butterfly_inc_control #(
    WL_Y_stage3,
    WL_Y_stage3
) RADIX_STAGE3(
    X0_stage3_real,
    X0_stage3_imag,

    X1_stage3_real,
    X1_stage3_imag,

    X2_stage3_real,
    X2_stage3_imag,

    X3_stage3_real,
    X3_stage3_imag,

    R_stage3_reg2,

    Y0_stage3_real,
    Y0_stage3_imag,

    Y1_stage3_real,
    Y1_stage3_imag,

    Y2_stage3_real,
    Y2_stage3_imag,

    Y3_stage3_real,
    Y3_stage3_imag
);


// ============================================================================
// Stage3 SDF delay
// ============================================================================

delay_line #(WL_Y_stage3, STAGE3_DELAY)
DFF_STAGE3_Y0_REAL(
    clk,
    rst_n,
    in_valid,
    Y0_stage3_real,
    X0_stage3_real
);

delay_line #(WL_Y_stage3, STAGE3_DELAY)
DFF_STAGE3_Y0_IMAG(
    clk,
    rst_n,
    in_valid,
    Y0_stage3_imag,
    X0_stage3_imag
);


delay_line #(WL_Y_stage3, STAGE3_DELAY)
DFF_STAGE3_Y1_REAL(
    clk,
    rst_n,
    in_valid,
    Y1_stage3_real,
    X1_stage3_real
);

delay_line #(WL_Y_stage3, STAGE3_DELAY)
DFF_STAGE3_Y1_IMAG(
    clk,
    rst_n,
    in_valid,
    Y1_stage3_imag,
    X1_stage3_imag
);


delay_line #(WL_Y_stage3, STAGE3_DELAY)
DFF_STAGE3_Y2_REAL(
    clk,
    rst_n,
    in_valid,
    Y2_stage3_real,
    X2_stage3_real
);

delay_line #(WL_Y_stage3, STAGE3_DELAY)
DFF_STAGE3_Y2_IMAG(
    clk,
    rst_n,
    in_valid,
    Y2_stage3_imag,
    X2_stage3_imag
);


// ============================================================================
// Stage3 butterfly -> multiplier pipeline
// ============================================================================

reg_p #(WL_Y_stage3) R_Y3_STAGE3_REAL(
    clk,
    rst_n,
    in_valid,
    Y3_stage3_real,
    Y3_stage3_real_reg1
);

reg_p #(WL_Y_stage3) R_Y3_STAGE3_IMAG(
    clk,
    rst_n,
    in_valid,
    Y3_stage3_imag,
    Y3_stage3_imag_reg1
);


// ============================================================================
// Stage3 multiplier
// ============================================================================

complex_mul_v2 #(
    WL_Y_stage3,
    FL_Y_stage3,

    WL_tw,
    FL_tw,

    WL_Y_stage4,
    FL_Y_stage4
) C_STAGE3(
    Y3_stage3_real_reg1,
    Y3_stage3_imag_reg1,

    tw_r_4,
    tw_i_4,

    X3_stage4_real,
    X3_stage4_imag
);


// ============================================================================
// Stage 4
// ============================================================================

radix4_butterfly_inc_control #(
    WL_Y_stage4,
    WL_Y_stage4
) RADIX_STAGE4(
    X0_stage4_real,
    X0_stage4_imag,

    X1_stage4_real,
    X1_stage4_imag,

    X2_stage4_real,
    X2_stage4_imag,

    X3_stage4_real,
    X3_stage4_imag,

    R_stage4_reg3,

    Y0_stage4_real,
    Y0_stage4_imag,

    Y1_stage4_real,
    Y1_stage4_imag,

    Y2_stage4_real,
    Y2_stage4_imag,

    Out_real_reg,
    Out_imag_reg
);


// ============================================================================
// Stage4 SDF delay
// ============================================================================

delay_line #(WL_Y_stage4, STAGE4_DELAY)
DFF_STAGE4_Y0_REAL(
    clk,
    rst_n,
    in_valid,
    Y0_stage4_real,
    X0_stage4_real
);

delay_line #(WL_Y_stage4, STAGE4_DELAY)
DFF_STAGE4_Y0_IMAG(
    clk,
    rst_n,
    in_valid,
    Y0_stage4_imag,
    X0_stage4_imag
);


delay_line #(WL_Y_stage4, STAGE4_DELAY)
DFF_STAGE4_Y1_REAL(
    clk,
    rst_n,
    in_valid,
    Y1_stage4_real,
    X1_stage4_real
);

delay_line #(WL_Y_stage4, STAGE4_DELAY)
DFF_STAGE4_Y1_IMAG(
    clk,
    rst_n,
    in_valid,
    Y1_stage4_imag,
    X1_stage4_imag
);


delay_line #(WL_Y_stage4, STAGE4_DELAY)
DFF_STAGE4_Y2_REAL(
    clk,
    rst_n,
    in_valid,
    Y2_stage4_real,
    X2_stage4_real
);

delay_line #(WL_Y_stage4, STAGE4_DELAY)
DFF_STAGE4_Y2_IMAG(
    clk,
    rst_n,
    in_valid,
    Y2_stage4_imag,
    X2_stage4_imag
);


// ============================================================================
// Address reorder
//
// Datapath total additional pipeline latency = 3 cycles.
// ============================================================================

address_reorder AR1(
    addr_reg_256,
    addr_reg_256_reorder_origin
);


delay_line #(8, 3) DFF_ADDR_REORDER(
    clk,
    rst_n,
    in_valid,
    addr_reg_256_reorder_origin,
    addr_reg_256_reorder
);


endmodule