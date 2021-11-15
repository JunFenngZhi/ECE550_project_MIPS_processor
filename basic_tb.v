// set the timescale <time_unit>/<time_precision>
`timescale 1 ns / 100 ps

module basic_tb(); // testbenches take no arguments

reg reset, test, t_ctrl_writeEnable;
reg [4:0] t_ctrl_writeReg, t_ctrl_readRegA, t_ctrl_readRegB;
reg [31:0]t_data_writeReg;
wire [31:0] t_data_readRegA, t_data_readRegB;
wire o_ctrl_writeEnable;
wire [4:0] o_ctrl_writeReg;
wire [31:0] o_data_writeReg;

reg clock;
reg proc_done;

integer num_correct;		// Number of tests that pass
integer curr_test_num;		// Current test
integer clock_count;		// How many times the clock has flipped
integer clock_count_max;	// How many clock cycles to run

// The test skeleton
skeleton_test spooky(clock, reset, test, t_ctrl_writeEnable, t_ctrl_writeReg, t_ctrl_readRegA, t_ctrl_readRegB,
							t_data_writeReg, t_data_readRegA, t_data_readRegB,
							o_ctrl_writeEnable, o_ctrl_writeReg, o_data_writeReg);

// Begin Simulation
initial begin
	num_correct = 0;
	curr_test_num = 1;
	clock_count = 0;
	clock_count_max = 1000;
	proc_done = 0;
	reset = 0;
	test = 0;
	
	$display("@ece550:test:start");
	clock = 1'b0;
end


// When proc_done is set high, run this code
always @(posedge proc_done) begin
		
	// Set write enable to 0 so that the testbench never writes to the regfile
	t_ctrl_writeEnable = 0;

	// Set test to 1 so that the skeleton file feeds testbench inputs into the regfile
	test = 1;

	/* 
		After all the insns finished, you will want to check the register file's content.
		You can add more checks according to your test cases
	*/
	 check_register("check r5",5,3);
	 check_register("check r4",4,2);
	 check_register("check r6",6,1);
	 check_register("check r12",12,1);
	 check_register("check r13",13,23);
	 check_register("check r14",14,1);
	 check_register("check r8",8,-1);
	 check_register("check r10",10,1);
	 check_register("check r18",18,2);
	 check_register("check r19",19,1);
	 check_register("check r20",20,2);
	 check_register("check r21",21,2);
	 check_register("check r22",22,3);

	$display("@ece550:test:end");
	$stop;
		
end


// Always increment the clock, and set proc_done when we reach clock_count_max
always begin
	#20 clock = ~clock; 
	clock_count = clock_count + 1;
	if (clock_count == clock_count_max * 2)
		proc_done = 1;
end
	
	
// Task to check that register 'read_reg' has the value 'value'
// If it was correct, increment the number of correct values
task check_register;
	input [8*15:1] test_name;	// The name of the test
	input [4:0] read_reg;		// The register to check
	input [31:0] value;			// The value that should be in the register
	
	begin
	
		t_ctrl_readRegA = read_reg;
		
		@(negedge clock);
		if (t_data_readRegA == value) begin
			$display("@ece550:test:start");
			$display(
				"@ece550:test:data { \"name\": \"Test %d\", \"status\": \"PASS\", \"data\": { \"time\": \"%t\", \"testname\": \"%s\", \"expected\": \"%3d\", \"actual\": \"%3d\" } }",
				curr_test_num,
				$time,
				test_name,
				value,
				t_data_readRegA
			);
			$display("@ece550:test:end");
			num_correct = num_correct + 1;
		end else begin
			$display("@ece550:test:start");
			$display(
				"@ece550:test:data { \"name\": \"Test %d\", \"status\": \"FAIL\", \"data\": { \"time\": \"%t\", \"testname\": \"%s\", \"expected\": \"%3d\", \"actual\": \"%3d\" } }",
				curr_test_num,
				$time,
				test_name,
				value,
				t_data_readRegA
			);
			$display("@ece550:test:end");
		end
		
		curr_test_num = curr_test_num + 1;
	end
endtask
	
endmodule
