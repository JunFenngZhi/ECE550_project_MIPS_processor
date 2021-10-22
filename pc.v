module pc (clk, reset, pc_next, pc);
	input[31:0] pc_next;
	input clk, reset;
	output[31:0] pc;
	reg[31:0] pc;
	
	initial
		begin
			pc = 32'd0;
			
		end
	
	always@(posedge clk or posedge reset) begin
		if(reset) begin
			pc <= 32d'0;
		end
		
		else begin
			pc <= pc_next;
		end
	end
	
endmodule
	