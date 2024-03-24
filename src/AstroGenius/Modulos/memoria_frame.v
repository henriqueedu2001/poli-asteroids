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
    // reg [numero de bits em cada linha] mem [numero de linhas] 
    reg [14:0] mem [15:0];
    reg [14:0] addreg;
    integer i = 0;

    initial begin
        for (i = 0; i < 15; i = i + 1) begin
            mem[i] = 15'd0;
        end


    end

    always @(posedge clk) begin
        if(we && ~clear) begin
            mem[coor_y][4'd15 - coor_x] <= 1'b1;
        end
        if(clear) begin
            for (i = 0; i < 15; i = i + 1) begin
                mem[i] <= 15'd0;
            end 
        end
    end

    assign saida_x = mem[coor_y];
    assign saida_y = coor_y;


endmodule

