module Divider(
	input reset,     //异步清零信号
	input in_clk,
	output reg out_clk  //分频后的输出信号
);
	parameter IN_Freq = 50000000;
	parameter OUT_Freq = 50000000/8;

	reg[3:0] count;
	initial begin
		count = 0;
		out_clk = 0;
	end
	
	always@(posedge in_clk or negedge reset) begin
		if(reset == 0) begin
			out_clk <= 0;
			count <= 0;
		end
		else begin
			if(count < (IN_Freq / 2 * OUT_Freq)) 
				count <= count + 4'b1;
			else begin
				count <= 0;
				out_clk <= ~out_clk;
			end
		end
	end

endmodule