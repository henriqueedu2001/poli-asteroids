module mux_reg_jogada (
        input [3:0] select_mux_jogada,
        output [1:0] saida_mux
        );

        assign saida_mux = select_mux_jogada == 4'b0001 ? 2'b00 : 
                           select_mux_jogada == 4'b1000 ? 2'b10 :
                           select_mux_jogada == 4'b0010 ? 2'b01 : 2'b11;
endmodule




