`include "rtl/instr.sv"

module instr_decoder
(
    input clk,
    input ce,
    input instr_t instr,
    output decoder_ctl_signals_t ctl_signals,
    output [4:0] rd_idx,
    output [4:0] rs1_idx,
    output [4:0] rs2_idx,
    output [31:0] rd_in
);
    // synthesis translate_off
    always @ (posedge clk)
    begin
        if (ce)
        begin
            $display("\tDecoding instruction: \t0x%8h", instr.word);
            $display("\tOpcode: \t\t0b%7b [%s]", instr.any.opcode, instr.any.opcode.name());

            if (instr.any.opcode.name == "")
            begin
                $display("\tWARNING: Instruction not supported!");
            end 
        end 
    end
    // synthesis translate_on 

    assign ctl_signals.regfile_we = (instr.any.opcode == LUI) ? 1 : 0;

    assign rs1_idx = 5'b0;
    assign rs2_idx = 5'b0;

    assign rd_idx = (
            instr.any.opcode == LUI
        ||  instr.any.opcode == AUIPC
    ) ? instr.utype.rd : 5'b0; 

    assign rd_in = (instr.any.opcode == LUI || instr.any.opcode == AUIPC) 
                    ? { instr.utype.imm, 12'b0 } : 32'b0;    
    
    assign ctl_signals.rs1_sel = (instr.any.opcode == AUIPC) ? 0 : 1;
    assign ctl_signals.rs2_sel = (instr.any.opcode == AUIPC) ? 0 : 1;
    assign ctl_signals.rd_in_sel  = (instr.any.opcode == AUIPC) ? 0 : 1;
    assign ctl_signals.alu_sel = (instr.any.opcode == AUIPC) ? ADD : 0;

endmodule
