module reg_32bit(Q, D, clk, en, clr);  //32bit寄存器，可实现读写、清零功能。

   input clk, en, clr;
	input wire[31:0] D;
   output reg[31:0] Q;
	
   
   initial begin
       Q = 32'b0;
   end

   //Set value of q on positive edge of the clock or clear
   always @(posedge clk or posedge clr) begin
     
       if (clr) begin
           Q <= 32'b0;
       end 
		 else if (en) begin
           Q <= D;
       end
   end
endmodule