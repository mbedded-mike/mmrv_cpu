lui t2, 1
auipc t1, 1
jal ra, 8       # jump back to itself and link (ifinite loop)
auipc t3, 0xc0c # this should never execute because of the previous jump
