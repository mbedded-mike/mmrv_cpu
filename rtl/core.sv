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
                pc <= pc + 4;

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

    /* main instruction decoder */
    instr_decoder id(
        .clk(clk),
        .ce(mctl_signals.instrdec_ce),
        .instr(ir),
        .ctl_signals(dctl_signals),
        .rd_idx(rd_idx),
        .rs1_idx(rs1_idx),
        .rs2_idx(rs2_idx),
        .rd_in(rd_in)
    ); 
    
    /* general purpose register file */
    register_file gp_regfile(
        .clk(clk),
        .ce(mctl_signals.gp_regfile_ce),
        .rd_idx(rd_idx),
        .data_in(rd_in),
        .write_en(dctl_signals.regfile_we),
        .rs1_idx(rs1_idx),
        .rs2_idx(rs2_idx),
        .rs1(rs1),
        .rs2(rs2)
    );


endmodule;
