# Simple Processor
Name： **Changhao Li & Junfeng Zhi**  
NetID： **cl580 & jz399**

### Clock Design
As shown in the table below. Given the skeleton clock as clk, IMem and DMem will use ~clk as clock; PC and Register will divide the clk by 8 as their own clock.
| Component | Clock   |
| -------------  |:-------------:|
| PC           | clk/8 |
| IMem         | ~clk       |
| Register            | clk/8     |
| DMem            | ~clk  |

### Instruction Fectch
We assgin `address_imem = pc[11:0]` details in processor.v

### Instruction Decode
With q_imem as input, decoding can be expressed as steps below, details in processor.v:

1. Decode operation type: decide which instruction will be excuted.
2. `rt = q_imem[16:12]`, `rs = q_imem[21:17]`, `rd = q_imem[26:22]` and `Immed = q_imem[16:0]` are decoded for register and alu operations. 
3. `ALU_op = q_imem[6:2]` and `shamt  = q_imem[11:7]` are decoded if the operation type is decided as alu in step 1, otherwise they will be decoded as 0.

### Operand Fetch
We assign `OperandB = data_readRegB | Immed` according to instruction type, details in processor.v

### Execute
We use ALU to execute on OperandA and OperandB, details in processor.v

### Result Stores
We store results in Data Memmory and Register Files according to instruction type, details in processor.v

### Next Instruction
We update pc according to instruction type(j, bne, jal, jr, blt, bex, setx), details in processor.v

### Overflow Control
Here, we treat overflow as an exception. Overflow Label which indicate what operation causes overflow will be writtend into `$30`. Exceptions writing takes precedent in our design.


