module sram_macro(
    input clk,
    input rst_n,
    input cs,
    input we,
    //input [3:0] write_allow,

    input [11:0] wr_addr,
    input [11:0] rd_addr,

    input [15:0] datain,
    output [15:0] dataout
);

reg [15:0] dataout_stored;
reg cs_int;

wire [15:0] dataout_int;

always @(posedge clk) begin
    if(!rst_n) begin
        cs_int <= 1;
        dataout_stored <= 0;
    end else begin
        if(cs)
            dataout_stored <= dataout_int;
        cs_int <= cs;
    end
end

assign dataout = cs_int ? dataout_int : dataout_stored;


wire [15:0] dout1;

sky130_sram_1kbyte_1r1w_8x1024_8 sram0(
    .clk0(clk),
    .csb0(!cs),

    .web0(!we),
//    .wmask0(write_allow[3:0]),
    
    .addr0(wr_addr),
    .din0(datain[7:0]),

    .clk1(clk),
    .csb1(!cs),
    .addr1(rd_addr),
    .dout1(dataout_int[7:0])
);

sky130_sram_1kbyte_1r1w_8x1024_8 sram1(
    .clk0(clk),
    .csb0(!cs),

    .web0(!we),
//    .wmask0(write_allow[3:0]),
    
    .addr0(wr_addr),
    .din0(datain[15:8]),

    .clk1(clk),
    .csb1(!cs),
    .addr1(rd_addr),
    .dout1(dataout_int[15:8])
);
endmodule