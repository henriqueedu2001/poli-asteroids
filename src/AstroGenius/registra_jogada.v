module registra_jogada(
    input clock,
    input enable_reg_jogada,
    input reset_reg_jogada
);

    wire [1:0] wire_saida_reg_jogada;
    wire wire_saida_opcode_mux;
    wire wire_tiro;
    wire wire_especial;

    assign wire_tiro = wire_saida_reg_jogada[0];
    assign wire_especial = wire_saida_reg_jogada[1];

registrador_n #(10) reg_jogada (
    /* inputs */
    .clock  (clock),
    .clear  (reset_reg_jogada),
    .enable (enable_reg_jogada | 1'b1),
    .D      (10'b0111_0111_00),
    /* output */
    .Q      (wire_saida_reg_jogada)
);

mux_reg_jogada #(4) mux_jogada(
    .select_mux_coor (wire_saida_reg_jogada),
    /* output */
    .saida_mux       (wire_saida_opcode_mux)
);

endmodule