module CSA_32b(out,overflow,A,B,cin);
	input[31:0] A, B;
	input cin;
	
	output[31:0] out;
	output overflow;
	
	//use 16bits CSA to implement 32bits CSA
	wire[15:0] out_0, out_1;
	wire cout_low, cout_high, cout_0, cout_1;
	wire CI_0, CI_1, CI_low, CI;
	supply0 GND;
	supply1 VCC;
	
	CSA_16b high_0(.out(out_0), .cout(cout_0), .CI(CI_0), .A(A[31:16]), .B(B[31:16]), .cin(GND));  
	CSA_16b high_1(.out(out_1), .cout(cout_1), .CI(CI_1), .A(A[31:16]), .B(B[31:16]), .cin(VCC));
	CSA_16b low(.out(out[15:0]), .cout(cout_low), .CI(CI_low), .A(A[15:0]), .B(B[15:0]), .cin(cin));
	
	//MUX choose the right answer
	assign cout_high = cout_low ? cout_1 : cout_0;
	assign out[31:16] = cout_low ? out_1 : out_0;

	assign CI = cout_low ? CI_1 : CI_0;

	
	xor xor_gate(overflow, cout_high, CI);
	
endmodule



module CSA_16b(out,cout,CI,A,B,cin);
	input[15:0] A, B;
	input cin;
	
	output[15:0]out;
	output cout, CI;
	
	//use 8bits RCA to implement 16bits CSA
	wire[7:0] out_0, out_1;
	wire cout_low, cout_0, cout_1;
	wire CI_0, CI_1, CI_low;
	supply0 GND;
	supply1 VCC;
	CSA_8b high0(.out(out_0), .cout(cout_0), .CI(CI_0), .A(A[15:8]), .B(B[15:8]), .cin(GND));
	CSA_8b high1(.out(out_1), .cout(cout_1), .CI(CI_1), .A(A[15:8]), .B(B[15:8]), .cin(VCC));
	CSA_8b low(.out(out[7:0]), .cout(cout_low), .CI(CI_low), .A(A[7:0]), .B(B[7:0]), .cin(cin));
	
	//MUX choose the right answer
	assign cout = cout_low ? cout_1 : cout_0; 
	assign out[15:8] = cout_low ? out_1 : out_0;
	assign CI = cout_low ? CI_1 : CI_0;

endmodule



module CSA_8b(out,cout,CI,A,B,cin);
	input[7:0] A, B;
	input cin;
	
	output[7:0]out;
	output cout, CI;
	
	//use 4bits RCA to implement 8bits CSA
	wire[3:0] out_0, out_1;
	wire cout_low, cout_0, cout_1;
	wire CI_0, CI_1, CI_low;
	supply0 GND;
	supply1 VCC;
	RCA_4b high0(.out(out_0), .cout(cout_0), .CI(CI_0), .A(A[7:4]), .B(B[7:4]), .cin(GND));
	RCA_4b high1(.out(out_1), .cout(cout_1), .CI(CI_1), .A(A[7:4]), .B(B[7:4]), .cin(VCC));
	RCA_4b low(.out(out[3:0]), .cout(cout_low), .CI(CI_low), .A(A[3:0]), .B(B[3:0]), .cin(cin));
	
	//MUX choose the right answer
	assign cout = cout_low ? cout_1 : cout_0; 
	assign out[7:4] = cout_low ? out_1 : out_0;
	assign CI = cout_low ? CI_1 : CI_0;

endmodule



module RCA_4b(out, cout, CI, A, B, cin);
    input[3:0] A, B;
    input cin;

    output[3:0] out;
    output cout, CI;

	 //use FA to implement 4bits RCA
    wire[2:0] couts;
    FA fa0(.out(out[0]), .cout(couts[0]), .A(A[0]), .B(B[0]), .cin(cin));
    FA fa1(.out(out[1]), .cout(couts[1]), .A(A[1]), .B(B[1]), .cin(couts[0]));
    FA fa2(.out(out[2]), .cout(couts[2]), .A(A[2]), .B(B[2]), .cin(couts[1]));
    FA fa3(.out(out[3]), .cout(cout), .A(A[3]), .B(B[3]), .cin(couts[2]));

    assign CI = couts[2];

endmodule




module FA(out, cout, A, B, cin);
    input A, B, cin;

    output out, cout;

	 //use logic gate to implement full adder
    wire s1, s2, s3;						
    xor xor1(s1, A, B);
    xor xor2(out, s1, cin);
    and and1(s2, s1, cin);
    and and2(s3, A, B);
    or or1(cout, s2, s3);

endmodule



