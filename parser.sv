module parser
	#(parameter N)
	(input logic[N-1:0] num,
	output logic[3:0] ones,
	output logic[3:0] tens);
	
	assign ones = num % 10;
	assign tens = (num / 10) % 10;
endmodule
	