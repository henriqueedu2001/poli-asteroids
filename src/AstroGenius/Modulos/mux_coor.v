module mux_coor #(parameter N = 4)(
        input select_mux_coor,
        input [N-1:0] mem_coor_x,
        input [N-1:0] mem_coor_y,
        output [N-1:0] saida_mux
        );

        parameter select_mem_coor_x = 1'b0;

        assign saida_mux = select_mux_coor == select_mem_coor_x ? mem_coor_x : mem_coor_y;
endmodule




