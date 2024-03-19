module cordena_asteroide_tiro (
        input clock,
        input reset,
        input cordena_asteroide_tiro,

        output fim_cordena_asteroide_tiro,
        output [4:0] db_estado_coordena_asteroide_tiro 
);

wire wire_reset_contador_tiro;
wire wire_reset_contador_asteroides;
wire wire_sinal_compara_tiros_e_asteroides;
wire wire_sinal_fim_comparacao;
wire wire_rco_contador_tiro;
wire wire_movimenta_tiro;
wire wire_movimentacao_concluida_tiro;
wire wire_conta_contador_tiro;
wire wire_sinal_compara_asteroides_com_a_nave_e_tiro;
wire wire_fim_comparacao_asteroides_com_a_nave_e_tiros;
wire wire_rco_contador_asteroides;
wire wire_movimentacao_concluida_asteroides;
wire wire_conta_contador_asteroides;


compara_tiros_e_asteroides compara_tiros_e_asteroides(
    /* inputs */
    .clock(clock),
    .reset(reset),
    .compara_tiros_e_asteroides(wire_sinal_compara_tiros_e_asteroides),
    /* outputs */
    .sinal_fim_comparacao(wire_sinal_fim_comparacao),
    .db_estado_compara_tiros_e_asteroide()
);









move_tiros move_tiros (
    /* inputs */
    .clock(clock),
    .reset(reset),
    .iniciar(wire_movimenta_tiro),
    /* outputs */
    .movimentacao_concluida_tiro(wire_movimentacao_concluida_tiro),
    .db_estado(),
    .db_resul_soma_sub()
);



compara_asteroides_com_nave_e_tiros compara_asteroides_com_nave_e_tiros (
    /* inputs */
    .clock(clock),
    .reset(reset),
    .compara_tiros_nave_asteroides(wire_sinal_compara_asteroides_com_a_nave_e_tiro),
    /* outputs */
    .sinal_fim_comparacao(wire_fim_comparacao_asteroides_com_a_nave_e_tiros),
    .num_vidas(),
    .db_estado_compara_asteroides_com_nave_e_tiros(),
    .db_estado_compara_tiros_e_asteroide()
);

move_asteroides move_asteroides (
    /* inputs */
    .clock(clock),
    .reset(reset),
    .inicia_move_asteroides(wire_sinal_movimenta_asteroides),
    /* outputs */
    .movimentacao_concluida_asteroides(wire_movimentacao_concluida_asteroides),
    .db_estado_move_asteroides()
);



uc_coordena_asteroides_tiros uc_coordena_asteroides_tiros(
    /* inputs */
    .clock(clock),
    .reset(reset),
    .move_tiro_e_asteroides(cordena_asteroide_tiro),
    .rco_contador_tiro(wire_rco_contador_tiro),
    .rco_contador_asteroides(wire_rco_contador_asteroides),
    .fim_move_tiros(wire_movimentacao_concluida_tiro),
    .fim_move_asteroides(wire_movimentacao_concluida_asteroides),
    .fim_comparacao_asteroides_com_a_nave_e_tiros(wire_fim_comparacao_asteroides_com_a_nave_e_tiros),
    .fim_comparacao_tiros_e_asteroides(wire_sinal_fim_comparacao),
    /* outputs */
    .movimenta_tiro(wire_movimenta_tiro),
    .sinal_movimenta_asteroides(wire_sinal_movimenta_asteroides),
    .sinal_compara_tiros_e_asteroides(wire_sinal_compara_tiros_e_asteroides),
    .sinal_compara_asteroides_com_a_nave_e_tiro(wire_sinal_compara_asteroides_com_a_nave_e_tiro),
    .conta_contador_tiro(wire_conta_contador_tiro),
    .reset_contador_tiro(wire_reset_contador_tiro),
    .reset_contador_asteroides(wire_reset_contador_asteroides),
    .conta_contador_asteroides(wire_conta_contador_asteroides),
    .fim_move_tiro_e_asteroides(fim_cordena_asteroide_tiro),
    .db_estado_coordena_asteroides_tiros(db_estado_coordena_asteroide_tiro)
);



tiro tiro (
    /* inputs */
    .clock(clock),
    .conta_contador_tiro(wire_conta_contador_tiro),
    .reset_contador_tiro(wire_reset_contador_tiro),
    .select_mux_pos_tiro(),
    .select_mux_coor_tiro(),
    .select_soma_sub_tiro(),
    .enable_reg_nave(),
    .reset_reg_nave(),
    .enable_mem_tiro(),
    .enable_load_tiro(),
    .aste_coor_x(),
    .aste_coor_y(),
    .new_load_tiro(),
    /* outputs */
    .x_borda_min_tiro(),
    .y_borda_min_tiro(),
    .x_borda_max_tiro(),
    .y_borda_max_tiro(),
    .colisao_tiro_asteroide(),
    .rco_contador_tiro(wire_rco_contador_tiro),
    .opcode_tiro(),
    .loaded_tiro(),
    .db_contador_tiro(),
    .db_wire_saida_som_sub_tiro()
);


asteroide asteroide(
    /* inputs */
    .clock(clock),
    .conta_contador_aste(wire_conta_contador_asteroides),
    .reset_contador_aste(wire_reset_contador_asteroides),
    .select_mux_pos_aste(),
    .select_mux_coor_aste(),
    .select_soma_sub_aste(),
    .enable_reg_nave(),
    .reset_reg_nave(),
    .enable_mem_aste(),
    .enable_load_aste(),
    .new_load_aste(),
    .new_destruido_aste(),
    /* outputs */
    .colisao_aste_com_nave(),
    .rco_contador_aste(wire_rco_contador_asteroides),
    .opcode_aste(),
    .destruido_aste(),
    .loaded_aste(),
    .aste_coor_x(),
    .aste_coor_y(),
    .db_contador_aste(),
    .db_wire_saida_som_sub_aste()
);



endmodule