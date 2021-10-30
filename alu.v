module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
  //module output & input
  input [31:0] data_operandA, data_operandB;  //输入的操作数A、B
  input [4:0] ctrl_ALUopcode, ctrl_shiftamt;  //ctrl_ALUopcode指定当前操作、ctrl_shiftamt指定移动位数

  output [31:0] data_result;
  output isNotEqual, isLessThan, overflow;  //标志位
	
  /*加减法以及对应标志位运算(CSA)*/
  wire [31:0] add_result, sub_result;  
	wire [31:0] sub_operandB;
  wire add_overflow, sub_overflow;
  supply0 GND;
  supply1 VCC;
	
	not n1[31:0] (sub_operandB, data_operandB);  //以后替换为下列代码:assign sub_operandB = ~data_operandB;
	assign overflow = ctrl_ALUopcode[0] ? sub_overflow: add_overflow; 
	
	//only need to correct under subtraction
	or x1(isNotEqual, sub_result);  //以后替换为下列代码:assign isNotEqual = data_result==32'b0 ? 1'b0 : 1'b1; 
	xor x2(isLessThan, sub_result[31], overflow);  //以后替换为下列代码：assign isLessThan = data_result[31] ^ overflow;
	
	CSA_32b adder(.out(add_result), .overflow(add_overflow), .A(data_operandA), .B(data_operandB), .cin(GND));
	CSA_32b subtracter(.out(sub_result), .overflow(sub_overflow), .A(data_operandA), .B(sub_operandB), .cin(VCC));
	
	
	/*32bit移位操作运算(barrel shifter)*/
	wire [31:0] SLL_result, SRA_result;
	Logical_LShift SLL(.operandA(data_operandA), .shiftamt(ctrl_shiftamt), .result(SLL_result));
	Arithmetic_RShift SRA(.operandA(data_operandA), .shiftamt(ctrl_shiftamt), .result(SRA_result));
	
	
	/*AND、OR逻辑操作*/
	wire [31:0] and_result, or_result;
	And_operation AND(.data_result(and_result), .data_operandA(data_operandA), .data_operandB(data_operandB));
	Or_operation OR(.data_result(or_result), .data_operandA(data_operandA), .data_operandB(data_operandB));
	
	
	/*data_result输出选择器*/
	wire[7:0] ctrl_wire;
	Decoder_3to8 decoder(.in(ctrl_ALUopcode[2:0]), .out(ctrl_wire));
	bufif1 b1[31:0] (data_result, add_result, ctrl_wire[0]);
	bufif1 b2[31:0] (data_result, sub_result, ctrl_wire[1]);
	bufif1 b3[31:0] (data_result, and_result, ctrl_wire[2]);
	bufif1 b4[31:0] (data_result, or_result, ctrl_wire[3]);
	bufif1 b5[31:0] (data_result, SLL_result, ctrl_wire[4]);
	bufif1 b6[31:0] (data_result, SRA_result, ctrl_wire[5]);


endmodule




module Decoder_3to8(input[2:0] in, output[7:0] out);

	wire n2, n1, n0;
	wire m1, m2, m3, m4;
	
  not(n0, in[0]);
	not(n1, in[1]);
	not(n2, in[2]);
   
	and(m1, n2, n1);
  and(m2, n2, in[1]);
  and(m3, in[2], n1);
	and(m4, in[2], in[1]);
	
	and(out[0], m1, n0);
	and(out[1], m1, in[0]);
	and(out[2], m2, n0);
	and(out[3], m2, in[0]);
	and(out[4], m3, n0);
	and(out[5], m3, in[0]);
	and(out[6], m4, n0);
	and(out[7], m4, in[0]);
	
endmodule
