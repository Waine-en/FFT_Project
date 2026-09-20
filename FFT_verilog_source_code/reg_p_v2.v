module reg_p_v2 (
  clk,
  rset_n,
  r_in,
  r_out
  );

input	clk;
input	rset_n;
input 	 r_in;
output 	 r_out;
reg 	 r_out;

//register description
always@(posedge clk or negedge rset_n)
  if (!rset_n)
    r_out <= 1'b0;
  else 
    r_out <= r_in;
endmodule