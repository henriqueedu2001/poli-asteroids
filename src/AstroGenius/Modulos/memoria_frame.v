module memoria_frame (
            input [3:0] coor_x,
            input [3:0] coor_y,
            input clk,
            input clear,
            input we,
            output [14:0] saida_x,
            output [3:0] saida_y
            );

    wire coor_x;
    wire coor_y;

    
    reg [14:0] mem [16:0];

    integer i = 0;

    initial begin
        for (i = 0; i < 15; i = i + 1) begin
            mem[i] = 14'b00000000000000;
        end


    end


    always @(posedge clk) begin
        if(we && ~clear) begin
            mem[coor_y][coor_x] <= 1'b1;
        end
        if(clear) begin
            mem[coor_y] <= 14'b00000000000000;
        end
    end

    assign saida_x = mem[coor_y];
    assign saida_y = coor_y;


endmodule

