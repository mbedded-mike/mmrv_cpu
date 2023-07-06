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
            
            if (instr.any.opcode == JAL)
            begin
                $display("JTYPE IMM, decoded: \t%d (0x%8h)", jimm, jimm);
            end

            if(instr.any.opcode == BRANCH)
            begin
                $display("BTYPE IMM, decoded: \t%d (0x%8h)", bimm, bimm);
            end
        end 
    end
    // synthesis translate_on 

    assign ctl_signals.regfile_we = (instr.any.opcode == LUI) ? 1 : 0;

    assign rs1_idx = (instr.any.opcode == JALR ||
                      instr.any.opcode == BRANCH) ? instr.itype.rs1 : 5'b0;
    assign rs2_idx = (instr.any.opcode == BRANCH) ? instr.btype.rs2 : 5'b0;

    assign rd_idx = (
            instr.any.opcode == LUI
        ||  instr.any.opcode == AUIPC
        ||  instr.any.opcode == JAL
        ||  instr.any.opcode == JALR
    ) ? instr.utype.rd : 5'b0; 

    wire signed [31:0] jimm;

    assign jimm[20] = instr.utype.imm[19];
    assign jimm[10:1] = instr.utype.imm[18:9];
    assign jimm[0] = 0;
    assign jimm[11] = instr.utype.imm[8];
    assign jimm[19:12] = instr.utype.imm[7:0];
    /* sign extend the immediate value */
    assign jimm[31:21] = (instr.utype.imm[19]) ? 11'h7FF : 11'b0;


    wire signed [31:0] iimm;
    
    assign iimm[11:0] = instr.itype.imm;
    /* sign extend */
    assign iimm[31:12] = (instr.itype.imm[11]) ? 20'hFFFFF : 20'b0;

    wire signed [31:0] bimm;

    assign bimm[31:12] = (instr.btype.imm_pt2[6]) ? 20'hFFFFF : 20'b0;
    assign bimm[10:5] = instr.btype.imm_pt2[5:0];
    assign bimm[4:1] = instr.btype.imm_pt1[4:1];
    assign bimm[0] = 0;
    assign bimm[11] = instr.btype.imm_pt1[0];


    assign rd_in = 
        (instr.any.opcode == LUI || instr.any.opcode == AUIPC) ? { instr.utype.imm, 12'b0 } :
        (instr.any.opcode == JAL) ? jimm :
        (instr.any.opcode == JALR) ? iimm : 
        (instr.any.opcode == BRANCH) ? bimm :
        32'b0;    
    
    assign ctl_signals.rs1_sel = (instr.any.opcode == AUIPC || instr.any.opcode == JAL) ? 0 : 1;
    assign ctl_signals.rs2_sel = (instr.any.opcode == AUIPC || instr.any.opcode == JAL || instr.any.opcode == JALR) ? 0 : 1;
    assign ctl_signals.rd_in_sel  = (instr.any.opcode == AUIPC) ? 2'b10 : 
                                    (instr.any.opcode == JAL || instr.any.opcode == JALR) ? 2'b00 : 2'b01;

    assign ctl_signals.alu_sel = (instr.any.opcode == AUIPC) ? ADD :
                                 (instr.any.opcode == BRANCH ) ? SUB : 0;
    assign ctl_signals.pc_in_sel = (instr.any.opcode == JAL || instr.any.opcode == JALR) ? 0 : 1; 

endmodule
