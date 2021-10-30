/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile
);
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;

    /* YOUR CODE STARTS HERE */
	 //wire declaration
	 wire[31:0] pc, pc_next;
	 wire[31:0] data_operandA, data_operandB, data_result, sx_N, ovf_label;
	 wire[4:0] Opcode, ALU_op, rd, rs, rt, shamt;
	 wire clock_pc, is_alu, is_addi, is_add, is_sub, is_lw, is_ovf, is_add_ovf, is_sub_ovf, is_addi_ovf, isNotEqual, isLessThan,overflow, is_sw;
	 /*new*/
	 wire is_j, is_jal, is_jr, is_bne, is_blt, is_bex, is_setx;
	 wire[31:0] T;
	 
	 
	 
	 /**********Step1: Instruction Fetch************/
	 Divider clk_div_8(.reset(reset), .in_clk(clock), .out_clk(clock_pc));
	 pc instance_pc(.clk(clock_pc), .reset(reset), .pc_next(pc_next), .pc(pc)); // pc_next->pc
	 
	 assign address_imem = pc[11:0];  //Tell I-Mem the address to fetch the instruction
	 
	 
	 /**********Step2: Decode**********/
	 
	 //Assign the Opcode, rd, rs, rt
	 assign Opcode = q_imem[31:27];
	 assign rd = q_imem[26:22];
	 assign rs = q_imem[21:17];
	 assign rt = q_imem[16:12];
	 assign T = {5'b0000_0, q_imem[26:0]};
	 
	 
	 //Assign the flag
	 assign is_alu = Opcode == 5'b0000_0 ? 1'b1 : 1'b0;   //Opcode:00000
	 assign is_addi = Opcode == 5'b0010_1 ? 1'b1 : 1'b0;  //Opcode:00101
	 assign is_sw = Opcode == 5'b0011_1 ? 1'b1 : 1'b0; 	//Opcode:00111
	 assign is_lw = Opcode == 5'b0100_0 ? 1'b1 : 1'b0; 	//Opcode:01000
	 
	 assign is_j = Opcode == 5'b0000_1 ? 1'b1 : 1'b0; 	//Opcode: 00001
	 assign is_bne = Opcode == 5'b0001_0 ? 1'b1 : 1'b0;	//Opcode: 00010
	 assign is_jal = Opcode == 5'b0001_1 ? 1'b1 : 1'b0; //Opcode: 00011
	 assign is_jr = Opcode == 5'b0010_0 ? 1'b1 : 1'b0; 	// Opcode； 00100
	 assign is_blt = Opcode == 5'b0011_0 ? 1'b1 : 1'b0; // Opcode； 00110
	 assign is_bex = Opcode == 5'b1011_0 ? 1'b1 : 1'b0; //Opcode: 10110
	 assign is_setx = Opcode == 5'b1010_1 ? 1'b1 : 1'b0; //Opcode: 10101
	 
	 
	 //Assign the ALU_op
	 assign ALU_op = is_alu ? q_imem[6:2] : 5'd0;
	 
	 //Assign shift amount
	 assign shamt = is_alu ? q_imem[11:7] : 5'd0;
	 
	 //Assign add, sub flag
	 assign is_add = (is_alu & ALU_op == 5'b0000_0) ? 1'b1:1'b0;  //ALU_op:00000
	 assign is_sub = (is_alu & ALU_op == 5'b0000_1) ? 1'b1:1'b0;  //ALU_op:00001
	 
	 //Assign sign extension immediate
	 assign sx_N[31:16] = q_imem[16] ? 16'hFFFF : 16'h0000;
	 assign sx_N[15:0] = q_imem[15:0];
	 
	 
	 /**********Step3: Operand Fetch************/
	 assign data_operandB = (is_addi | is_lw | is_sw) ? sx_N : data_readRegB;
	 assign data_operandA = data_readRegA;
	 
	 
	 /**********Step4: Execute *************/
	 alu instance_alu(data_operandA, data_operandB, ALU_op, shamt, data_result, isNotEqual, isLessThan, overflow);
	 
	 assign is_add_ovf = overflow & is_add;
	 assign is_sub_ovf = overflow & is_sub;
	 assign is_addi_ovf = overflow & is_addi;
	 assign is_ovf = is_add_ovf | is_sub_ovf | is_addi_ovf;
	 assign ovf_label = is_ovf ? (is_add ? 32'd1 : (is_addi ? 32'd2 : 32'd3)) : 32'd0;
	 
	 
	 
	 /**********Step5 : Result Stores**********/
	 //Data Memory
	 assign address_dmem = data_result[11:0];
	 assign data = data_readRegB;
	 
	 wire counter_out;
	 counter my_counter(.clock(~clock), .insn_num(address_imem), .out(counter_out));
	 assign wren = is_sw & counter_out;
	 
	 //Register File
	 assign ctrl_readRegA = rs;
	 assign ctrl_readRegB = is_bex ? 5'd30 : ((is_sw | is_jr| is_bne | is_blt) ? rd : rt); // is_bex指令时读取$rstatus
	 assign ctrl_writeReg = (q_imem == 32'd0 || is_setx) ? 5'd30 : (is_jal ? 5'd31 : (is_ovf ? 5'd30 : rd));    // nop指令强制ctrl_writeReg为$30,跳出闭环。is_jal指令时，写入$r31。
	 assign data_writeReg = is_setx ? T : (is_jal? pc + 32'b1 : (is_ovf ? ovf_label :(is_lw ? q_dmem : data_result))); // is_jal指令时，写入内容为pc+1
	 assign ctrl_writeEnable = is_sw ? 1'b0 : 1'b1;
	 
	 
	 /**********Step6 : Next Instruction***********/
	 
	 get_pc_next my_pc_getter(pc, is_j, is_bne, is_jal, is_jr, is_blt, is_bex, T, sx_N, data_readRegA, data_readRegB, pc_next);
	 
	 

endmodule


module get_pc_next(pc, is_j, is_bne, is_jal, is_jr, is_blt, is_bex, T, sx_N, data_readRegA, data_readRegB, pc_next);
	input is_j, is_bne, is_jal, is_jr, is_blt, is_bex;
	input[31:0] pc, T, sx_N, data_readRegA, data_readRegB;
	output reg[31:0] pc_next;
	
	always @(*) begin 
		if (is_j == 1'b1) begin
			pc_next = T; 
		end
		
		else if (is_bne == 1'b1) begin
			if (data_readRegA != data_readRegB) begin // Reg_A(rs) != Reg_B(rd)
				pc_next  = pc + 32'b1 + sx_N;
			end
		end
		
		else if (is_jal == 1'b1) begin
			pc_next = T;
		end
		
		else if (is_jr == 1'b1) begin
			pc_next = data_readRegB; //Reg_B = Rd
		end
		
		else if (is_blt == 1'b1) begin
			if (data_readRegB < data_readRegA) begin // Reg_B(rd) < Reg_A(rs)
				pc_next = pc + 32'b1 + sx_N;
			end
		end
		
		else if (is_bex == 1'b1) begin
			if (data_readRegB != 32'b0) begin
				pc_next= T;
			end
		end
		
		else begin
			pc_next = pc + 32'b1;
		end
	
	end

endmodule



// use to count posedge edge to generate wren to dmem
module counter (clock,insn_num,out);
 input clock;
 input[11:0] insn_num;
 output reg out;
 
 reg[3:0] count_0, count_1;
 
 initial  begin
	  out = 0;
	  count_0 = 4'b0;
	  count_1 = 4'b0;
 end

 always@(posedge clock) begin
	if(insn_num != 12'd0) begin
 
	  if(out == 1'b0) begin
		if (count_0 < 7) begin
			 out <= 0;
			 count_0 <= count_0 + 4'b1;
		end
		else begin
			 out <= 1;
			 count_0 <= 0;
			 count_1 <= count_1 + 4'b1;
		end
	  end
	  else begin
		if(count_1 < 1) begin
			 out <= 1;
			 count_1 <= count_1 + 4'b1;
		end
		else begin
			 out <= 0;
			 count_1 <= 0;
			 count_0 <= count_0 + 4'b1;
		end
	  end
	  
	end
 end

endmodule








