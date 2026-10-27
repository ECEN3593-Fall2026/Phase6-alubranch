    .section .text
    .globl _start

_start:  

addi x1, x0, 13 # 0b 1101 (0xD)
addi x2, x0, 3 
addi x3, x0, -3 # (0xFFFF FFFD)
addi x4, x0, -1  # 0xFFFF FFFF

# Don't test forwarding here
nop
nop
nop
nop


sub x5, x1, x2  # x5 = 10 (0xA)
sub x6, x1, x3  # x6 = 16 (0x10)

xor x7, x1, x4  # 0xFFFF FFF2

or x8, x2, x0  # 3
or x9, x1, x4  # -1 (0xFFFF FFFF)

and x10, x1, x0 # 0
and x11, x1, x4 # 13 (0xD)

sll x11, x1, x2 # 52 (0x68)
srl x12, x4, x2 # 0x1FFF FFFF
sra x13, x4, x2 # 0xFFFF FFFF

slt x14, x4, x1 # 1
slt x15, x1, x4 # 0

sltu x16, x4, x1 # 0
sltu x16, x1, x4 # 1

xori x18, x4, 13  # 0xFFFF FFF2
ori x19, x1, 6    # 0b 1111 (0xF)
andi x20, x1, 6   # 0b0100 (0x4)    
slli x21, x3, 2   # 0xFFFF FFF4  (ffff fffD) D is 0b1101
srli x22, x4, 4  # 0x0FFF FFFF 
srai x23, x4, 4  # 0xFFFF FFFF
slti x24, x4, 1  # 1
sltiu x25, x4, 1 # 0


nop
nop
nop
nop
nop

