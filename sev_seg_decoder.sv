module sev_seg_decoder(input  logic[3:0] data,
                output logic[6:0] segments);
	always_comb
		case(data)
			0:       segments<=7'b0000_001;
			1:       segments<=7'b1001_111;
			2:       segments<=7'b0010_010;
			3:       segments<=7'b0000_110;
			4:       segments<=7'b1001_100;
			5:       segments<=7'b0100_100;
			6:       segments<=7'b0100_000;
			7:       segments<=7'b0001_111;
			8:       segments<=7'b0000_000;
			9:       segments<=7'b0000_100;
			default: segments<=7'b1111_111;
	endcase
endmodule
