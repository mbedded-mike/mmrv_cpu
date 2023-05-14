/* single port ram */
module sp_ram
(
    input clk,
    input ce,                           /* clock enable */
    input [31:0] data_in,   
    input [31:0] address,   
    output reg [31:0] data_out,  
    input data_le                      /* data latch enable */
);

    reg [7:0] data[31:0];
    
    assign data_out = { 
        data[address    ], 
        data[address + 1], 
        data[address + 2], 
        data[address + 3]
    };

    always @(posedge clk)
    begin
        if (ce && data_le)
        begin
            data[address    ] <= data_in[31:24];
            data[address + 1] <= data_in[23:16];
            data[address + 2] <= data_in[15: 8];
            data[address + 3] <= data_in[7 : 0];
        end
    end


endmodule
