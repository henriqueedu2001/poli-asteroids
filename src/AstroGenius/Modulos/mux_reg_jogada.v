module mux_reg_jogada #(parameter N = 2)(
        input [3:0] select_mux_jogada,
        output [N-1:0] saida_mux
        );

        assign saida_mux = select_mux_jogada == 4'b0001 ? 2'b00 : 
                           select_mux_jogada == 4'b0010 ? 2'b10 :
                           select_mux_jogada == 4'b0100 ? 2'b11 : 2'b01 ;
endmodule




