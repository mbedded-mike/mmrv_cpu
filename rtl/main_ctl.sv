`include "rtl/instr.sv"

/* main controller for the multicycle cpu */
typedef struct packed
{
    logic alu_ce;
    logic gp_regfile_we;
    logic fetch_en;
    logic memory_ce;
    logic gp_regfile_ce;
    logic instrdec_ce;
    logic pc_inc;
} main_ctl_signals /*verilator public */;

module main_ctl 
(
    input clk,
    input ce,
    input reset,
    input instr_t instr,
    output main_ctl_signals ctl_signals
);
    
    // synthesis translate_off
    integer cycle_count = 0;
    // synthesis translate_on

    typedef enum reg[2:0] {RESET, FETCH, DECODE, EXECUTE, WRITEBACK} state_t;
    state_t state, next_state;

    always @ (posedge clk)
    begin
        if (reset)
        begin
            $display("\t[RESET]");
            state <= RESET;
        end 
     
        else if (ce)
        begin
            // synthesis translate_off
            $display("[N_cycles=%0d]\t[%s]", cycle_count, next_state.name());
            cycle_count = cycle_count + 1;
            // synthesis translate_on

            state <= next_state;
        end 
    end

    always @ (state, ce, instr)
    begin
        if (ce)
        begin
            case (state)
                RESET: next_state <= FETCH;
                FETCH: next_state <= DECODE; 
                DECODE: next_state <= EXECUTE;
                EXECUTE: next_state <= (instr.any.opcode == LUI) ? FETCH : WRITEBACK;
                WRITEBACK: next_state <= FETCH;
                default: next_state <= RESET;
            endcase
        end 
    end

    assign ctl_signals.memory_ce     = (state == WRITEBACK || state == FETCH) ? 1 : 0;
    assign ctl_signals.gp_regfile_ce = (state == EXECUTE   || state == WRITEBACK) ? 1 : 0;
    assign ctl_signals.instrdec_ce   = (state == DECODE) ? 1 : 0;
    assign ctl_signals.pc_inc        = (state == EXECUTE) ? 1 : 0;
    assign ctl_signals.fetch_en      = (state == FETCH) ? 1 : 0;
    assign ctl_signals.gp_regfile_we = (state == WRITEBACK && instr.any.opcode == AUIPC) ? 1 : 0;
    assign ctl_signals.alu_ce        = (state == EXECUTE && instr.any.opcode != LUI) ? 1 : 0;

endmodule
