module Logical_LShift(operandA, shiftamt, result);  //逻辑左移，低位补0
	input[31:0] operandA; //移位操作数
	input[4:0] shiftamt;  //移动位数
	output[31:0] result;  

	wire[31:0] L1_out;
	wire[31:0] L2_out;
	wire[31:0] L3_out;
	wire[31:0] L4_out;
	
	supply0 GND;
	genvar i;
	
	//MUX_Layer_1
	generate
		for(i = 31;i >= 0;i = i - 1) begin : generate_layer1
			if(i-1 >= 0)
				Mux_2to1 L1(operandA[i],operandA[i-1],shiftamt[0],L1_out[i]);
			else
				Mux_2to1 L1(operandA[i],GND,shiftamt[0],L1_out[i]);
		end
	endgenerate
	
	//MUX_Layer_2
	generate
		for(i = 31;i >= 0;i = i - 1) begin : generate_layer2
			if(i-2 >= 0)
				Mux_2to1 L2(L1_out[i],L1_out[i-2],shiftamt[1],L2_out[i]);
			else
				Mux_2to1 L2(L1_out[i],GND,shiftamt[1],L2_out[i]);
		end
	endgenerate
	
	//MUX_Layer_3
	generate
		for(i = 31;i >= 0;i = i - 1) begin : generate_layer3
			if(i-4 >= 0)
				Mux_2to1 L3(L2_out[i],L2_out[i-4],shiftamt[2],L3_out[i]);
			else
				Mux_2to1 L3(L2_out[i],GND,shiftamt[2],L3_out[i]);
		end
	endgenerate
	
	//MUX_Layer_4
	generate
		for(i = 31;i >= 0;i = i - 1) begin : generate_layer4
			if(i-8 >= 0)
				Mux_2to1 L4(L3_out[i],L3_out[i-8],shiftamt[3],L4_out[i]);
			else
				Mux_2to1 L4(L3_out[i],GND,shiftamt[3],L4_out[i]);
		end
	endgenerate
	
	//MUX_Layer_5
	generate
		for(i = 31;i >= 0;i = i - 1) begin : generate_layer5
			if(i-16 >= 0)
				Mux_2to1 L5(L4_out[i],L4_out[i-16],shiftamt[4],result[i]);
			else
				Mux_2to1 L5(L4_out[i],GND,shiftamt[4],result[i]);
		end
	endgenerate

	
endmodule

//SRA和SLL设计思路类似  但是循环是从下(0)往上(31)更新 引入wire sign = 最高位。
module Arithmetic_RShift(operandA, shiftamt, result); //算术右移，高位补符号位
	input[31:0] operandA; //移位操作数
	input[4:0] shiftamt;  //移动位数
	output[31:0] result;  

	wire[31:0] L1_out;
	wire[31:0] L2_out;
	wire[31:0] L3_out;
	wire[31:0] L4_out;
	
	wire sign;
	assign sign = operandA[31];
	
	genvar i;
	
	
	//MUX_Layer_1
	generate
		for(i = 0;i <= 31;i = i + 1) begin : generate_layer1
			if(30 - i >= 0)
				Mux_2to1 L1(operandA[i],operandA[i+1],shiftamt[0],L1_out[i]);
			else
				Mux_2to1 L1(operandA[i],sign,shiftamt[0],L1_out[i]);
		end
	endgenerate
	
	//MUX_Layer_2
	generate
		for(i = 0;i <= 31;i = i + 1) begin : generate_layer2
			if(29 - i >= 0)
				Mux_2to1 L2(L1_out[i],L1_out[i+2],shiftamt[1],L2_out[i]);
			else
				Mux_2to1 L2(L1_out[i],sign,shiftamt[1],L2_out[i]);
		end
	endgenerate
	
	//MUX_Layer_3
	generate
		for(i = 0;i <= 31;i = i + 1) begin : generate_layer3
			if(27 - i >= 0)
				Mux_2to1 L3(L2_out[i],L2_out[i+4],shiftamt[2],L3_out[i]);
			else
				Mux_2to1 L3(L2_out[i],sign,shiftamt[2],L3_out[i]);
		end
	endgenerate
	
	//MUX_Layer_4
	generate
		for(i = 0;i <= 31;i = i + 1) begin : generate_layer4
			if(23 - i >= 0)
				Mux_2to1 L4(L3_out[i],L3_out[i+8],shiftamt[3],L4_out[i]);
			else
				Mux_2to1 L4(L3_out[i],sign,shiftamt[3],L4_out[i]);
		end
	endgenerate
	
	//MUX_Layer_5
	generate
		for(i = 0 ;i <= 31;i = i + 1) begin : generate_layer5
			if(15 - i >= 0)
				Mux_2to1 L5(L4_out[i],L4_out[i+16],shiftamt[4],result[i]);
			else
				Mux_2to1 L5(L4_out[i],sign,shiftamt[4],result[i]);
		end
	endgenerate

	
endmodule






module Mux_2to1(input a,b,S,output out);  //S==0,选择a; S==1,选择b。
	
	assign out = S ? b : a;
	
endmodule
