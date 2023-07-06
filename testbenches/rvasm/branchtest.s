lui t1, 1
lui t2, 1
lui t3, 0xFFFFF
lui t4, 2 
BRANCH_TEST_START:
# assert branches not taken
    beq t1, t3, BRANCH_TEST_FAIL
    bne t1, t2, BRANCH_TEST_FAIL 
    blt t1, t2, BRANCH_TEST_FAIL
    bge t3, t2, BRANCH_TEST_FAIL
##

# assert branches taken
    beq t1, t1, BEQ_taken
    jal ra, BRANCH_TEST_FAIL
BEQ_taken:
    bne t1, t4, BNE_taken
    jal ra, BRANCH_TEST_FAIL
BNE_taken:
    blt t3, t1, BLT_taken 
    jal ra, BRANCH_TEST_FAIL
BLT_taken:
    bge t1, t3, BGE_taken
    jal ra, BRANCH_TEST_FAIL
BGE_taken:
    jal ra, BRANCH_TEST_SUCCEED
## 

BRANCH_TEST_SUCCEED:
    lui t5, 0
    jal ra, BRANCH_TEST_SUCCEED # loop forever

BRANCH_TEST_FAIL:
    lui t5, 1
    jal ra, BRANCH_TEST_FAIL # loop forever
