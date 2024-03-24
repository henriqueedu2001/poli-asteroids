`include "memoria_frame.v"
`timescale 1ns/1ns

module memoria_frame_tb;

reg [3:0] coor_x;
reg [3:0] coor_y;
reg clk;
reg we;
wire [14:0] saida_x;
wire [3:0] saida_y;
memoria_frame memoria_frame(
            .coor_x(coor_x),
            .coor_y(coor_y),
            .clk(clk),
            .clear(clear),
            .we(we),
            .saida_x(saida_x),
            .saida_y(saida_y)
            );

reg [14:0] mem [15:0];
integer i = 0;
always #5 clk = ~clk;
reg [13:0] aux;
initial begin
    $dumpfile("wave.vcd");
    $dumpvars(2, memoria_frame_tb);
    clk = 0;
    aux = 15'd0;
    for (i = 0; i < 15; i = i + 1) begin
        mem[i] = 14'd0;
    end
    #10
    mem[7][7] = 1'b1;
    #10
    mem[7][8] = 1'b1;
    #10
    mem[7] = aux;
    #10
    // clk = 0;
    // coor_x = 4'd0
    // coor_y = 4'd0
    // we = 1'b0
    // clear = 1'b1;

    // #10

    // clear = 1'b0;
    $finish;

end
endmodule

