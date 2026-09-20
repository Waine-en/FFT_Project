module address_reorder(
  //input
  t,
  //output
  t_reorder
);
input [7:0] t;
output reg [7:0] t_reorder;

always @(*)begin
	case(t[1:0])
	    2'd0: t_reorder[7:6] = 2'd3;
		2'd1: t_reorder[7:6] = 2'd0;
		2'd2: t_reorder[7:6] = 2'd1;
		2'd3: t_reorder[7:6] = 2'd2;
	endcase
	case(t[3:2])
	    2'd0: t_reorder[5:4] = 2'd3;
		2'd1: t_reorder[5:4] = 2'd0;
		2'd2: t_reorder[5:4] = 2'd1;
		2'd3: t_reorder[5:4] = 2'd2;
	endcase
	case(t[5:4])
	    2'd0: t_reorder[3:2] = 2'd3;
		2'd1: t_reorder[3:2] = 2'd0;
		2'd2: t_reorder[3:2] = 2'd1;
		2'd3: t_reorder[3:2] = 2'd2;
	endcase
	case(t[7:6])
	    2'd0: t_reorder[1:0] = 2'd3;
		2'd1: t_reorder[1:0] = 2'd0;
		2'd2: t_reorder[1:0] = 2'd1;
		2'd3: t_reorder[1:0] = 2'd2;
	endcase	
end

endmodule