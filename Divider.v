module Divider(
	input reset,     //异步清零信号
	input in_clk,
	output reg out_clk  //分频后的输出信号
);

	reg[3:0] count;
	
	initial begin
		count = 0;
		out_clk = 0;
	end
	
	always@(posedge in_clk or posedge reset) begin
		if(reset == 1) begin
			out_clk <= 0;
			count <= 0;
		end
		else begin
			if(count < 3)   // 8分频
				count <= count + 4'b1;
			else begin
				count <= 0;
				out_clk <= ~out_clk;
			end
		end
	end

endmodule


