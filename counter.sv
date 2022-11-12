module counter 
	#(parameter N)
	(input logic clk,
	input  logic reset,
	output logic[N-1:0] out);
	
	always_ff @(posedge clk, posedge reset)
		if(reset) out <= 0;
		else out <= out + 1;
endmodule
	