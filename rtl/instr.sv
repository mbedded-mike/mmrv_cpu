`ifndef INSTR_SV
`define INSTR_SV

typedef enum logic[6:0]
{
    LUI = 7'b0110111,
    AUIPC = 7'b0010111,
    JAL = 7'b1101111,
    JALR = 7'b1100111
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

typedef union packed
{
    logic [31:0]        word;
    any_type_instr_t    any;
    u_type_instr_t      utype;
    i_type_instr_t      itype;
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



`endif
