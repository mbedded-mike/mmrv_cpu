lui t2, 1       # t2 = 4096 (2^12)
auipc t1, 1     # t1 = 4096 + pc
jalr ra, t2, 4  # jump to t2 + 4 (4100 / L1) and link 
auipc t3, 0xc0c # this should never execute because of the previous jump

.org 4100 
auipc t4, 0xc0c 
jal ra, -4   # infinite loop

.fill 64, 1, 0x00
