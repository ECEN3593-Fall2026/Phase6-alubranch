    .section .text
    .globl _start

_start:  

addi x1, x0, 1 # addr 0
jal x10, LAB   # addr 4   ( x10 should be 8 ) 
addi x2, x0, 2 # addr 8
addi x3, x0, 3 # addr 12
addi x4, x0, 4 # addr 16 (0x10)
addi x5, x0, 5 # addr 20 (0x14)

LAB: 
addi x6, x0, 6  # addr 24 (0x18)  <= only x6 should update
nop
nop
nop
