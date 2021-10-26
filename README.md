# Simple Processor

### Clock Design
As shown in the table below. Given the skeleton clock as clk, IMem and DMem will use ~clk as clock; PC and Register will divide the clk by 8 as their own clock.
| Component | Clock   |
| -------------  |:-------------:|
| PC           | clk/8 |
| IMem         | ~clk       |
| Register            | clk/8     |
| DMem            | ~clk  |

### Instruction Decode
With q_imem as input, decoding can be expressed as steps below:

1. Decode operation type: decide which instruction will be excuted.
2. `rt = q_imem[16:12]`, `rs = q_imem[21:17]`, `rd = q_imem[26:22]` and `Immed = q_imem[16:0]` are decoded for register and alu operations. 
3. `ALU_op = q_imem[6:2]` and `shamt  = q_imem[11:7]` are decoded if the operation type is decided as alu in step 1, otherwise they will be decoded as 0.

### Overflow Control
Here, we treat overflow as an exception. Overflow Label which indicate what operation causes overflow will be writtend into `$30`. Exceptions writing takes precedent in our design.


