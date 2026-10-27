    .section .text
    .globl _start

_start:  

addi x20, x0, 48  # addr 0
nop               # addr 4
nop               # addr 8
nop               # addr 12 (0xC)
nop               # addr 16 (0x10)
addi x1, x0, 1     # addr=20 (0x14)
jalr x10, x20, 8   # addr=24 (0x18)   (x10 should be 28/0x1c)
addi x2, x0, 2     # addr=28 (0x1C)
addi x3, x0, 3     # addr=32 (0x20)
addi x4, x0, 4     # addr=36 (0x24)
addi x5, x0, 5     # addr=40 (0x28)
addi x6, x0, 6 # addr 44 (0x2C)
addi x7, x0, 7 # addr 48 (0x30)
addi x8, x0, 8 # addr 52 (0x34)

LAB: 
addi x9, x0, 9  # addr=56 (0x38)    only x9 should update
nop
nop
nop
