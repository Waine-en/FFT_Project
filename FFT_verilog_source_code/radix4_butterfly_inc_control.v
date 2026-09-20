module radix4_butterfly_inc_control #(parameter INPUT_BIT=14,
parameter OUTPUT_BIT=16)(
	X0_real,
	X0_imag,
	X1_real,
	X1_imag,
	X2_real,
	X2_imag,
	X3_real,
	X3_imag,
	control,
	
	Y0_real,
	Y0_imag,
	Y1_real,
	Y1_imag,
	Y2_real,
	Y2_imag,
	Y3_real,
	Y3_imag
);
input signed [OUTPUT_BIT-1:0] X0_real;
input signed [OUTPUT_BIT-1:0] X0_imag;
input signed [OUTPUT_BIT-1:0] X1_real;
input signed [OUTPUT_BIT-1:0] X1_imag;
input signed [OUTPUT_BIT-1:0] X2_real;
input signed [OUTPUT_BIT-1:0] X2_imag;
input signed [INPUT_BIT-1:0] X3_real;
input signed [INPUT_BIT-1:0] X3_imag;
input signed [1:0] control;

output reg signed [OUTPUT_BIT-1:0] Y0_real;
output reg signed [OUTPUT_BIT-1:0] Y0_imag;
output reg signed [OUTPUT_BIT-1:0] Y1_real;
output reg signed [OUTPUT_BIT-1:0] Y1_imag;
output reg signed [OUTPUT_BIT-1:0] Y2_real;
output reg signed [OUTPUT_BIT-1:0] Y2_imag;
output reg signed [OUTPUT_BIT-1:0] Y3_real;
output reg signed [OUTPUT_BIT-1:0] Y3_imag;
  // --- sign-extend X3 to OUTPUT_BIT ---
  
  // real trunc?
  wire signed [OUTPUT_BIT-1:0] X3r = {{(OUTPUT_BIT-INPUT_BIT){X3_real[INPUT_BIT-1]}}, X3_real};
  wire signed [OUTPUT_BIT-1:0] X3i = {{(OUTPUT_BIT-INPUT_BIT){X3_imag[INPUT_BIT-1]}}, X3_imag};
always @(*) begin
    case (control)
        2'b00: begin
			Y0_real = X3r;
			Y0_imag = X3i;
			Y1_real = X1_real;
			Y1_imag = X1_imag;
			Y2_real = X2_real;
			Y2_imag = X2_imag;
			Y3_real = X0_real;
			Y3_imag = X0_imag;
		end
        2'b01: begin
			Y0_real = X0_real;
			Y0_imag = X0_imag;
			Y1_real = X3r;
			Y1_imag = X3i;
			Y2_real = X2_real;
			Y2_imag = X2_imag;
			Y3_real = X1_real;
			Y3_imag = X1_imag;
		end
        2'b10: begin
			Y0_real = X0_real;
			Y0_imag = X0_imag;
			Y1_real = X1_real;
			Y1_imag = X1_imag;
			Y2_real = X3r;
			Y2_imag = X3i;
			Y3_real = X2_real;
			Y3_imag = X2_imag;
		end
        2'b11: begin
			Y0_real = X0_real + X1_real + X2_real + X3r;
			Y0_imag = X0_imag + X1_imag + X2_imag + X3i;
			Y1_real = X0_real + X1_imag - X2_real - X3i;
			Y1_imag = X0_imag - X1_real - X2_imag + X3r;
			Y2_real = X0_real - X1_real + X2_real - X3r;
			Y2_imag = X0_imag - X1_imag + X2_imag - X3i;
			Y3_real = X0_real - X1_imag - X2_real + X3i;
			Y3_imag = X0_imag + X1_real - X2_imag - X3r;
		end
        default: begin
			Y0_real = {OUTPUT_BIT{1'b0}};
			Y0_imag = {OUTPUT_BIT{1'b0}};
			Y1_real = {OUTPUT_BIT{1'b0}};
			Y1_imag = {OUTPUT_BIT{1'b0}};
			Y2_real = {OUTPUT_BIT{1'b0}};
			Y2_imag = {OUTPUT_BIT{1'b0}};
			Y3_real = {OUTPUT_BIT{1'b0}};
			Y3_imag = {OUTPUT_BIT{1'b0}};
		end
    endcase

end

endmodule