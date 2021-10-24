`timescale 1 ns / 100 ps

module skeleton_tb(ctrl_writeReg, data_writeReg, ctrl_readRegA, data_readRegA, ctrl_readRegB, data_readRegB, 
						 imem_clock, dmem_clock, processor_clock, regfile_clock, PC_clk,
						 address_imem,overflow);
	
	output[31:0] data_writeReg, data_readRegA, data_readRegB;
	output imem_clock, dmem_clock, processor_clock, regfile_clock,PC_clk;
	output[4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output[11:0] address_imem;
	output overflow;
	
	reg clock;
	reg reset;
	
	integer i = 0;
	
	initial begin
		clock = 1'b0;
		reset = 1'b0;
	end
	
	skeleton s1 (clock, reset, imem_clock, dmem_clock, processor_clock, regfile_clock,
					 data_writeReg, data_readRegA, data_readRegB, PC_clk,
					 ctrl_writeReg, ctrl_readRegA, ctrl_readRegB, address_imem,overflow);  //test
					 
	always #20 begin
		if(i <= 0)
			reset = 1'b0;
		else
			reset = 1'b0;
			
		clock = ~clock;
		i = i + 1;
	end
		
	

endmodule
