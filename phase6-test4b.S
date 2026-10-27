    .section .text
    .globl _start

_start:  

addi x1, x0, 1    # addr 0
addi x2, x0, -1   # addr 4
addi x3, x0, 1   # addr 8
nop              # addr 0xC
nop              # addr 0x10
nop              # addr 0x14

# Expect all register, x4-x9, to get written to witwhatever the reg number is (i.e., 4-9) -- so no branches are taken
# if you want to remove the nop instructions, it should still work
#   but, that's really testing the flushing and we won't look at that in these tests

# When you 'grep "Register" out.log' (which is the output of running system_tb.out, the compiled verilog, redirected to out.log),
# you should see lines like this:
#    (55) Register File: Writing value 00000001 to register  1 
# you should NOT see one of the x4-x9 registers being written to.  If you do, you know that's where an error is
# First test phase6-test4a.S 

# test branching (all of these should be true)


LAB0: 
bne x1, x2, LAB1  # branch if (1 != -1)   addr 0x18
nop
nop
nop
addi x4, x0, 4

LAB1:
beq x1, x3, LAB2 # branch if (1 == 1)  addr 0x2c
nop
nop
nop
addi x5, x0, 5

LAB2:
bge x1, x2, LAB3  # branch if (1 >= -1)  addr 0x40  
nop
nop
nop
addi x6, x0, 6

LAB3:
bgeu x2, x1, LAB4 # branch if (big number >= 1)
nop
nop
nop
addi x7, x0, 7

LAB4:
blt x2, x1, LAB5  # branch if (-1 < 1)
nop
nop
nop
addi x8, x0, 8

LAB5:
bltu x1, x2, LAB6 # branch if if (1 < big number) 
nop
nop
nop
addi x9, x0, 9

LAB6:
nop

