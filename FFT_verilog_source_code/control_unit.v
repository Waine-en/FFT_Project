module control_unit(
  //input:
  clk,
  rst_n,
  in_valid,
  addr_reg_64,
  addr_reg_16,
  addr_reg_4,
  addr_reg_1,
  
  //output:
  R_stage1,
  R_stage2,
  R_stage3,
  R_stage4  
);
input clk, rst_n;
input in_valid;
input [5:0] addr_reg_64; 
input [3:0] addr_reg_16; 
input [1:0] addr_reg_4;
input addr_reg_1; 

output reg [1:0] R_stage1;
output reg [1:0] R_stage2;
output reg [1:0] R_stage3;
output reg [1:0] R_stage4;


always @ (posedge clk or negedge rst_n) begin
  if (!rst_n) begin
	R_stage1 <= 2'b00;
	R_stage2 <= 2'b00;
	R_stage3 <= 2'b00;
	R_stage4 <= 2'b00;	
  end else if (in_valid) begin
	if (addr_reg_64 == 6'b1111_11)begin
		R_stage1 <= R_stage1 + 1'b1;
	end
	else begin
		R_stage1 <= R_stage1;
	end
	
	if (addr_reg_16 == 4'b1111)begin
		R_stage2 <= R_stage2 + 1'b1;
	end
	else begin
		R_stage2 <= R_stage2;
	end	

	if (addr_reg_4 == 2'b11)begin
		R_stage3 <= R_stage3 + 1'b1;
	end
	else begin
		R_stage3 <= R_stage3;
	end	
	
	if (addr_reg_1 == 1'b1)begin
		R_stage4 <= R_stage4 + 1'b1;
	end
	else begin
		R_stage4 <= R_stage4;
	end		
		//R_stage4 <= R_stage4 + 1'b1;

  end
end


endmodule
