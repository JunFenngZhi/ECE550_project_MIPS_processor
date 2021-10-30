module decoder_2to4(in, out);

	input[1:0] in;
	output[3:0] out;
	
	wire n0, n1;
	
	
	not(n0, in[0]);
	not(n1, in[1]);
	
	and(out[0], n1, n0);
	and(out[1], n1, in[0]);
	and(out[2], in[1], n0);
	and(out[3], in[1], in[0]);

endmodule


module decoder_3to8(in, en, out);
	input[2:0] in;
	input en;
	output[7:0] out;
	wire n2, n1, n0;
	wire m1, m2, m3, m4;
	wire p0, p1, p2, p3, p4, p5, p6, p7;
	
	not(n0, in[0]);
	not(n1, in[1]);
	not(n2, in[2]);
   
	and(m1, n2, n1);
	and(m2, n2, in[1]);
	and(m3, in[2], n1);
	and(m4, in[2], in[1]);
	
	and(p0, m1, n0);
	and(p1, m1, in[0]);
	and(p2, m2, n0);
	and(p3, m2, in[0]);
	and(p4, m3, n0);
	and(p5, m3, in[0]);
	and(p6, m4, n0);
	and(p7, m4, in[0]);
	
	
	and(out[0], p0, en);
	and(out[1], p1, en);
	and(out[2], p2, en);
	and(out[3], p3, en);
	and(out[4], p4, en);
	and(out[5], p5, en);
	and(out[6], p6, en);
	and(out[7], p7, en);
	
endmodule


module decoder_5to32(in, out);

	input[4:0] in;
	output[31:0] out;
	
	wire[3:0] n;
	
	decoder_2to4 decoder0(.in(in[4:3]), .out(n[3:0]));
	decoder_3to8 decoder1(.in(in[2:0]), .en(n[0]), .out(out[7:0]));
	decoder_3to8 decoder2(.in(in[2:0]), .en(n[1]), .out(out[15:8]));
	decoder_3to8 decoder3(.in(in[2:0]), .en(n[2]), .out(out[23:16]));
	decoder_3to8 decoder4(.in(in[2:0]), .en(n[3]), .out(out[31:24]));
	

endmodule