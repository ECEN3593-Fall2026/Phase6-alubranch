    .section .text
    .globl _start

_start:  

nop
nop
nop

lui x5, 0xfffff   # FFFF F000
lui x6, 0xA  # 0000 A000

#PC = 20 (0x14)
auipc x7, 2  # 0000 2014 

# Don't test forwarding here
nop
nop
nop
nop

