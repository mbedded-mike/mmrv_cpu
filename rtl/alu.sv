`include "rtl/instr.sv"

module alu
(
    input clk,
    input ce,
    input alu_op_t op_sel,
    
    input [31:0] operand1,
    input [31:0] operand2,
    
    output reg [31:0] result,
    output alu_flags_t flags
);

    reg overflow;

    always @ (posedge clk)
    begin
            if (ce)
            begin
                overflow <= 0;
                /*
                    Note:
                    To clarify, why the default operators are used to perform arithmetic operations:
                    For now, the goal of this project is to configure an FPGA to run this core at best, 
                    so the synthesis and implementation performed by the FPGA vendor software
                    might do better than implementing adders and/or shifters structurally
                */
                case (op_sel)
                    ADD: {overflow, result} <= operand1 + operand2;
                    SUB: {overflow, result} <= operand1 - operand2;
                    XOR: result <= operand1 ^ operand2;
                    OR: result <= operand1 | operand2;
                    AND: result <= operand1 & operand2;
                    LSR: result <= operand1 >> operand2;
                    LSL: result <= operand1 << operand2;
                    default: result <= 32'b0;
                endcase
                // synthesis translate_off

                $display("ALU: %d %s %d", $signed(operand1), op_sel.name(), $signed(operand2));
                // synthesis translate_on
            end 
    end

    assign flags.zero = result == 32'b0;
    assign flags.sign = result[31];
    assign flags.overflow = overflow;
endmodule 
