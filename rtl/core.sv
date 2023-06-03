`include "rtl/main_ctl.sv"
`include "rtl/instr.sv"

/* top level module for the CPU core */
module core
(
    input clk,
    input ce,
    input reset,

    input [31:0] memout,
    output [31:0] memin,
    output [31:0] memaddr
);
    reg [31:0] pc; /* program counter */
    reg [31:0] ir; /* instruction register */
    

    main_ctl_signals mctl_signals;
    decoder_ctl_signals_t dctl_signals;

    assign memaddr = pc;

    always @ (posedge clk)
    begin
        if (ce)
        begin
            if (mctl_signals.pc_inc)
            begin
                if (dctl_signals.pc_in_sel)
                    pc <= pc + 4;
                else
                    pc <= alu_result;
            end

            if (mctl_signals.fetch_en)
            begin
                ir <= memout;
                // synthesis translate_off
                $display("\t PC:\t0x%8h", pc);
                $display("\t IR:\t0x%8h", memout);
                // synthesis translate_on
            end

        end
        
        if (reset)
        begin   
                // FIXME: this should point elsewhere
                pc <= 32'b0;
                ir <= 32'b0;
        end
    end  

    /* main control unit (FSM for the multicycle arch) typ*/
    main_ctl mctl(
        .clk(clk),
        .ce(ce),
        .reset(reset),
        .instr(ir),
        .ctl_signals(mctl_signals)
    );
    
    wire [4:0] rd_idx;
    wire [4:0] rs1_idx;
    wire [4:0] rs2_idx;

    wire [31:0] rs1;
    wire [31:0] rs2;
    wire [31:0] rd_in;
    /* immediate value, literally extracted from an instruction */
    wire [31:0] imm;

    /* main instruction decoder */
    instr_decoder id(
        .clk(clk),
        .ce(mctl_signals.instrdec_ce),
        .instr(ir),
        .ctl_signals(dctl_signals),
        .rd_idx(rd_idx),
        .rs1_idx(rs1_idx),
        .rs2_idx(rs2_idx),
        .rd_in(imm)
    ); 
    
    /* general purpose register file */
    register_file gp_regfile(
        .clk(clk),
        .ce(mctl_signals.gp_regfile_ce),
        .rd_idx(rd_idx),
        .data_in(rd_in),
        .write_en(dctl_signals.regfile_we | mctl_signals.gp_regfile_we),
        .rs1_idx(rs1_idx),
        .rs2_idx(rs2_idx),
        .rs1(rs1),
        .rs2(rs2)
    );

    wire [31:0] alu_lhs;
    wire [31:0] alu_rhs;
    wire [31:0] alu_result;

    alu main_alu(
        .clk(clk),
        .ce(mctl_signals.alu_ce),
        .op_sel(dctl_signals.alu_sel),
        .operand1(alu_lhs),
        .operand2(alu_rhs),
        .result(alu_result)
    );

    assign alu_lhs = dctl_signals.rs1_sel ? rs1 : pc;
    assign alu_rhs = dctl_signals.rs2_sel ? rs2 : imm;
    
    assign rd_in =  dctl_signals.rd_in_sel == 2'b01  ? imm : 
                    dctl_signals.rd_in_sel == 2'b10  ? alu_result :
                                                       pc; 

endmodule;
