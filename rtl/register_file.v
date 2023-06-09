
module register_file #(
    parameter REGISTER_WIDTH = 32,
    NREGS = 32
)
(
    input clk,
    input ce,
    
    input [4:0] rd_idx,
    input [REGISTER_WIDTH-1:0] data_in,
    input write_en,

    input [4:0] rs1_idx,
    input [4:0] rs2_idx,
    output reg [REGISTER_WIDTH-1:0] rs1,
    output reg [REGISTER_WIDTH-1:0] rs2
);

    reg [REGISTER_WIDTH-1:0] regs[NREGS-1:0];
    
    /* the ISA says x0 should be hardwired to zero
     * and any writes to it should be discarded
     */
    assign regs[0] = 32'b0; 

    always @ (posedge clk)
    begin
        if (ce)
        begin
            if (write_en && rd_idx != 5'b0)
            begin
                regs[rd_idx] <= data_in;
            end

            rs1 <= regs[rs1_idx];
            rs2 <= regs[rs2_idx];
        end 
    end

endmodule
