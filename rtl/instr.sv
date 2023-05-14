typedef enum logic[6:0]
{
    LUI = 7'b0110111
} opcode_t;

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

typedef union packed
{
    logic [31:0]        word;
    any_type_instr_t    any;
    u_type_instr_t      utype;
} instr_t;

typedef struct packed
{
    logic regfile_we;
} decoder_ctl_signals_t;

