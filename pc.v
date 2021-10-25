module pc (clk, reset, pc_next, pc);
	input[11:0] pc_next;
	input clk, reset;
	output[11:0] pc;
	reg[11:0] pc;
	
	initial
		begin
			pc = 12'd0;
			
		end
	
	always@(posedge clk or posedge reset) begin
		if(reset) begin
			pc <= 12'd0;
		end
		
		else begin
			pc <= pc_next;
		end
	end
	
endmodule
	