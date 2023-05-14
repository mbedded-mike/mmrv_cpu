`include "rtl/instr.sv"

module instr_decoder
(
    input clk,
    input ce,
    input instr_t instr,
    output decoder_ctl_signals_t ctl_signals
);
    instr_t instr_reg;

    always @ (posedge clk)
    begin
        if (ce)
        begin
            // synthesis translate_off
            $display("\t [DECODE]");
            $display("Decoding instruction: \t0x%8h", instr.word);
            $display("Opcode: \t\t0b%7b", instr.any.opcode);

            if (instr.any.opcode != LUI)
            begin
                $display("instruction not supported!");
            end 
            // synthesis translate_on
            
            instr_reg <= instr;
        end 
    end

    assign ctl_signals.regfile_we = (instr_reg.any.opcode == LUI) ? 1 : 0;

endmodule
