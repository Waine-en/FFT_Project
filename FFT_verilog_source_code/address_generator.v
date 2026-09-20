module address_generator(
  //input: 
  clk,
  rst_n,
  in_valid,
  
  //output:
  addr_reg_256,
  addr_reg_64,
  addr_reg_16,
  addr_reg_4,
  addr_reg_1
);
input clk, rst_n;
input in_valid;
output reg [7:0] addr_reg_256; 
output reg [5:0] addr_reg_64; 
output reg [3:0] addr_reg_16; 
output reg [1:0] addr_reg_4;
output reg addr_reg_1; 
 
reg [7:0] addr_256;
reg [5:0] addr_64; 
reg [3:0] addr_16; 
reg [1:0] addr_4;
reg addr_1;  

always @ (posedge clk or negedge rst_n) begin
  if (!rst_n) begin
	addr_256 <= 8'b0000_0000;
	addr_64 <= 6'b0000_00;
	addr_16 <= 4'b0000;
	addr_4 <= 2'b00;
	addr_1 <= 1'b0;
	addr_reg_256 <= 8'b0000_0000;
	addr_reg_64 <= 6'b0000_00;
	addr_reg_16 <= 4'b0000;
	addr_reg_4 <= 2'b00;
	addr_reg_1 <= 1'b0;
  end else if (in_valid) begin
	addr_256 <= addr_256 + 1'b1;
	addr_64 <= addr_64 + 1'b1;
	addr_16 <= addr_16 + 1'b1;
	addr_4  <= addr_4  + 1'b1;
	addr_reg_1  <= 1'b1;	
	addr_reg_256 <= addr_256;
	addr_reg_64 <= addr_64;
	addr_reg_16 <= addr_16;
	addr_reg_4  <= addr_4 ;
//addr_reg_1  <= addr_1 ;
  end
end


endmodule
