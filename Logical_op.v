module And_operation(data_result, data_operandA, data_operandB);
	output[31:0] data_result;
	input[31:0] data_operandA, data_operandB;
	
	genvar i;
	
	generate
		for(i=0; i<32; i=i+1) begin: generate_Andgate
			and x1(data_result[i], data_operandA[i], data_operandB[i]);
		end
	endgenerate
	
endmodule

module Or_operation(data_result, data_operandA, data_operandB);
	output[31:0] data_result;
	input[31:0] data_operandA, data_operandB;
	
	genvar i;
	
	generate
		for(i=0; i<32; i=i+1) begin: generate_Andgate
			or x1(data_result[i], data_operandA[i], data_operandB[i]);
		end
	endgenerate
	
endmodule
