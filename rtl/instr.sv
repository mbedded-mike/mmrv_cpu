`ifndef INSTR_SV
`define INSTR_SV

typedef enum logic[6:0]
{
    LUI = 7'b0110111,
    AUIPC = 7'b0010111,
    JAL = 7'b1101111,
    JALR = 7'b1100111,
    BRANCH = 7'b1100011 
} opcode_t /*verilator public*/;

typedef struct packed 
{
    logic [24:0]    body;
    opcode_t        opcode;
} any_type_instr_t;

typedef struct packed 
{
    logic [19:0]    imm;
    logic [4:0]     rd;
    opcode_t        opcode;
} u_type_instr_t;

typedef struct packed 
{
    logic [11:0]    imm;
    logic [4:0]     rs1;
    logic [2:0]     funct3;
    logic [4:0]     rd;
    opcode_t        opcode;
} i_type_instr_t;

typedef struct packed
{   
    logic [6:0]     imm_pt2;
    logic [4:0]     rs2;
    logic [4:0]     rs1;
    logic [2:0]     funct3;
    logic [4:0]     imm_pt1;
    opcode_t        opcode;
} b_type_instr_t;

typedef union packed
{
    logic [31:0]        word;
    any_type_instr_t    any;
    u_type_instr_t      utype;
    i_type_instr_t      itype;
    b_type_instr_t      btype;
} instr_t;

typedef struct packed
{
    logic       pc_in_sel;
    logic [1:0] rd_in_sel;
    logic [2:0] alu_sel;
    logic       rs1_sel;
    logic       rs2_sel;
    logic       regfile_we;
} decoder_ctl_signals_t;

typedef enum logic [2:0]
{
    ADD = 0,
    SUB = 1,
    XOR = 2,
    OR  = 3,
    AND = 4,
    LSR = 5,
    LSL = 6
} alu_op_t /*verilator public*/;

typedef struct packed 
{
    logic zero;
    logic sign;
    logic overflow;
} alu_flags_t /*verilator public*/;

typedef enum logic [2:0]
{
    BEQ = 3'b000,
    BNE = 3'b001,
    BLT = 3'b100,
    BGE = 3'b101,
    BLTU = 3'b110,
    BGEU = 3'b111
} branch_t;

`endif
