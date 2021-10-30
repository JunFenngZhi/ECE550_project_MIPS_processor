module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;   //address
   input [31:0] data_writeReg;

   output [31:0] data_readRegA, data_readRegB;

   /* YOUR CODE HERE */
	wire[31:0] writeEn, W_select;  
	wire[31:0] ReadA_select, ReadB_select; //选取寄存器输出  
	wire[32*32-1:0] reg_output;  //用于连接各个寄存器的输出
	
	genvar i;
	supply0[31:0] GND;
	
	//create register
	generate
		for(i = 0;i < 32;i = i + 1) begin : build_registers
			and(writeEn[i],W_select[i],ctrl_writeEnable);
			if(i == 0)
				reg_32bit r(.Q(reg_output[31+i*32:i*32]), .D(GND), .clk(clock), .en(writeEn[i]), .clr(ctrl_reset));  //reg $0永远写入0
			else
				reg_32bit r(.Q(reg_output[31+i*32:i*32]), .D(data_writeReg), .clk(clock), .en(writeEn[i]), .clr(ctrl_reset));
		end
	endgenerate
	
	//reading portA
	generate
		for(i = 0;i < 32;i = i + 1) begin : build_portA
			bufif1 b[31:0](data_readRegA, reg_output[31+i*32:i*32], ReadA_select[i]);
		end
	endgenerate
	decoder_5to32 RportA_decode(.in(ctrl_readRegA), .out(ReadA_select));
	
	//reading portB
	generate
		for(i = 0;i < 32;i = i + 1) begin : build_portB
			bufif1 b[31:0](data_readRegB, reg_output[31+i*32:i*32], ReadB_select[i]);
		end
	endgenerate
	decoder_5to32 RportB_decode(.in(ctrl_readRegB), .out(ReadB_select));
	
	//writing port
	decoder_5to32 W_decode(.in(ctrl_writeReg), .out(W_select));
		

endmodule



