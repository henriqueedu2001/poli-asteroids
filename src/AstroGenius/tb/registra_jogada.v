module registra_jogada(
    input [5:0] chaves,
    input clock,
    input enable_reg_jogada,
    input reset_reg_jogada,
    output [1:0] wire_opcode_mux,
    output wire_tiro,
    output wire_especial
);

    wire [5:0] wire_saida_reg_jogada;

    assign wire_tiro = wire_saida_reg_jogada[0];
    assign wire_especial = wire_saida_reg_jogada[1];


registrador_n #(6) reg_jogada (
    /* inputs */
    .clock  (clock),
    .clear  (reset_reg_jogada),
    .enable (enable_reg_jogada),
    .D      (chaves),
    /* output */
    .Q      (wire_saida_reg_jogada)
);


mux_reg_jogada mux_jogada(
    .select_mux_jogada (wire_saida_reg_jogada[5:2]),
    /* output */
    .saida_mux       (wire_opcode_mux)
);

endmodule