module Clock
	(input logic Clock_50MHz,
	input  logic reset_n,
	
	output logic seg0_a,
	output logic seg0_b,
	output logic seg0_c,
	output logic seg0_d,
	output logic seg0_e,
	output logic seg0_f,
	output logic seg0_g,
	
	output logic seg1_a,
	output logic seg1_b,
	output logic seg1_c,
	output logic seg1_d,
	output logic seg1_e,
	output logic seg1_f,
	output logic seg1_g,
	
	output logic seg2_a,
	output logic seg2_b,
	output logic seg2_c,
	output logic seg2_d,
	output logic seg2_e,
	output logic seg2_f,
	output logic seg2_g,
	
	output logic seg3_a,
	output logic seg3_b,
	output logic seg3_c,
	output logic seg3_d,
	output logic seg3_e,
	output logic seg3_f,
	output logic seg3_g,
	
	output logic seg4_a,
	output logic seg4_b,
	output logic seg4_c,
	output logic seg4_d,
	output logic seg4_e,
	output logic seg4_f,
	output logic seg4_g,
	
	output logic seg5_a,
	output logic seg5_b,
	output logic seg5_c,
	output logic seg5_d,
	output logic seg5_e,
	output logic seg5_f,
	output logic seg5_g);
	
	//resets (named after what they reset on)
	logic secs_reset;
	logic mins_reset;
	logic hour_reset;
	logic days_reset;
	
	//counter to comparator
	logic[25:0] FifM_to_1_comp;
	logic[5:0] sec_comp;
	logic[5:0] min_comp;
	logic[4:0] hrs_comp;
	
	//comparator to synchronizer
	logic a_gt_B;
	logic a_gt_D;
	logic a_gt_F;
	logic a_gt_H;
	
	//post parser
	logic[3:0] sec_ones;
	logic[3:0] min_ones;
	logic[3:0] hrs_ones;
	logic[3:0] sec_tens;
	logic[3:0] min_tens;
	logic[3:0] hrs_tens;
	
	//clock signals
	logic secs_clock;
	logic mins_clock;
	logic hour_clock;
	logic days_clock;
	
	//sev_seg_bus
	logic[6:0] seg0;
	logic[6:0] seg1;
	logic[6:0] seg2;
	logic[6:0] seg3;
	logic[6:0] seg4;
	logic[6:0] seg5;
	
	//assign reseters
	assign secs_reset = secs_clock | ~reset_n;
	assign mins_reset = mins_clock | ~reset_n;
	assign hour_reset = hour_clock | ~reset_n;
	assign days_reset = days_clock | ~reset_n;
	
	//assign outputs
	assign seg0_a = seg0[6];
	assign seg0_b = seg0[5];
	assign seg0_c = seg0[4];
	assign seg0_d = seg0[3];
	assign seg0_e = seg0[2];
	assign seg0_f = seg0[1];
	assign seg0_g = seg0[0];
	
	assign seg1_a = seg1[6];
	assign seg1_b = seg1[5];
	assign seg1_c = seg1[4];
	assign seg1_d = seg1[3];
	assign seg1_e = seg1[2];
	assign seg1_f = seg1[1];
	assign seg1_g = seg1[0];
	
	assign seg2_a = seg2[6];
	assign seg2_b = seg2[5];
	assign seg2_c = seg2[4];
	assign seg2_d = seg2[3];
	assign seg2_e = seg2[2];
	assign seg2_f = seg2[1];
	assign seg2_g = seg2[0];
	
	assign seg3_a = seg3[6];
	assign seg3_b = seg3[5];
	assign seg3_c = seg3[4];
	assign seg3_d = seg3[3];
	assign seg3_e = seg3[2];
	assign seg3_f = seg3[1];
	assign seg3_g = seg3[0];

	assign seg4_a = seg4[6];
	assign seg4_b = seg4[5];
	assign seg4_c = seg4[4];
	assign seg4_d = seg4[3];
	assign seg4_e = seg4[2];
	assign seg4_f = seg4[1];
	assign seg4_g = seg4[0];
	
	assign seg5_a = seg5[6];
	assign seg5_b = seg5[5];
	assign seg5_c = seg5[4];
	assign seg5_d = seg5[3];
	assign seg5_e = seg5[2];
	assign seg5_f = seg5[1];
	assign seg5_g = seg5[0];

	//counters (clk, reset,  out)
	counter #(26) fast_counter(Clock_50MHz, secs_reset, FifM_to_1_comp[25:0]);
	counter #(6)  secs_counter(secs_clock, mins_reset, sec_comp[5:0]);
	counter #(6)  mins_counter(mins_clock, hour_reset, min_comp[5:0]);
	counter #(5)  hour_counter(hour_clock, days_reset, hrs_comp[4:0]);
	
	//comparators (params: N, M .. logic: a[N-1], a_gt_M)
	comparator #(26, 50000000) fast_comp(FifM_to_1_comp[25:0], a_gt_B);
	comparator #(6, 60)        secs_comp(sec_comp[5:0], a_gt_D);
	comparator #(6, 60)        mins_comp(min_comp[5:0], a_gt_F);
	comparator #(5, 24)        hour_comp(hrs_comp[4:0], a_gt_H);
	
	//synchronizers (clk, d, q)
	synchronizer fast_sync(Clock_50MHz, a_gt_B, secs_clock);
	synchronizer secs_sync(Clock_50MHz, a_gt_D, mins_clock);
	synchronizer mins_sync(Clock_50MHz, a_gt_F, hour_clock);
	synchronizer hour_sync(Clock_50MHz, a_gt_H, days_clock);
	
	//parsers (params: N .. logic: num, ones, tens)
	parser #(6) secs_parse(sec_comp[5:0], sec_ones[3:0], sec_tens[3:0]);
	parser #(6) mins_parse(min_comp[5:0], min_ones[3:0], min_tens[3:0]);
	parser #(5) hour_parse(hrs_comp[4:0], hrs_ones[3:0], hrs_tens[3:0]);
	
	//seven segment decoders (in, out)
	sev_seg_decoder d0(sec_ones[3:0], seg0[6:0]);
	sev_seg_decoder d1(sec_tens[3:0], seg1[6:0]);
	sev_seg_decoder d2(min_ones[3:0], seg2[6:0]);
	sev_seg_decoder d3(min_tens[3:0], seg3[6:0]);
	sev_seg_decoder d4(hrs_ones[3:0], seg4[6:0]);
	sev_seg_decoder d5(hrs_tens[3:0], seg5[6:0]);

endmodule
