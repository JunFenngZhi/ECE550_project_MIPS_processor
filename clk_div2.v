module clk_div2(clk_div2, clk, reset);	

	input clk, clr;
	output reg clk_div2;


	always@(posedge clk or posedge reset) begin
		if (reset) begin
			clk_div2 <= 1'b0;
		end
		else begin
			clk_div2 <= ~clk_div2;
		end
	end
	
endmodule


	
