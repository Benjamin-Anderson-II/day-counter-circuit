module comparator
	#(parameter N,
	parameter   M)
	(input logic[N-1:0] a,
	output logic q_gt_M);
	
	assign q_gt_M = (a >= M);
endmodule
