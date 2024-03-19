module compara_asteroides_com_nave_e_tiros (
        input clock,
        input reset,
        input compara_tiros_nave_asteroides,

        output sinal_fim_comparacao,
        output [1:0] num_vidas,
        output [4:0] db_estado_compara_asteroides_com_nave_e_tiros,
        output [4:0] db_estado_compara_tiros_e_asteroide
);

/* wires uc_compara_asteroides_com_nave_e_tiros */
wire wire_colisao_aste_com_nave;
wire wire_reset_contador_asteroides1;
wire wire_enable_decrementador;
wire wire_ha_vidas;
wire wire_new_loaded_asteroide;
wire wire_new_destruido_asteroide;
wire wire_enable_mem_destruido;
wire wire_rco_contador_asteroides;
wire wire_conta_contador_asteroides1;
wire wire_sinal_compara_tiros_e_asteroides;
wire wire_sinal_fim_compara_tiros_e_asteroides;

/* wires uc_compara_tiros_e_asteroides */
wire wire_reset_contador_asteroides2;
wire wire_reset_contador_tiros;
wire wire_loaded_tiro;
wire wire_rco_contador_tiro;
wire wire_conta_contador_asteroides2;
wire wire_conta_contador_tiros;
wire [3:0] wire_aste_coor_x;
wire [3:0] wire_aste_coor_y;
wire wire_colisao_tiro_asteroide;
wire wire_load_tiro;
wire load_asteroide;
wire wire_loaded_tiro_output;
wire wire_loaded_asteroide_output;
wire wire_asteroide_destruido;

or (wire_ha_vidas, num_vidas[0], num_vidas[1]);

uc_compara_asteroides_com_nave_e_tiros uc1 (
    /* inputs */
    .clock(clock),
    .reset(reset),
    .iniciar_comparacao_tiros_nave_asteroides(compara_tiros_nave_asteroides),
    .posicao_asteroide_igual_nave(wire_colisao_aste_com_nave),
    .ha_vidas(wire_ha_vidas),
    .rco_contador_asteroides(wire_rco_contador_asteroides),
    .fim_compara_tiros_e_asteroides(wire_sinal_fim_compara_tiros_e_asteroides),
    /* outputs */
    .enable_decrementador(wire_enable_decrementador),
    .new_loaded_asteroide(wire_new_loaded_asteroide),
    .new_destruido_asteroide(wire_new_destruido_asteroide),
    .enable_mem_destruido(wire_enable_mem_destruido),
    .conta_contador_asteroides(wire_conta_contador_asteroides1),
    .fim_compara_asteroides_com_tiros_e_nave(sinal_fim_comparacao),
    .sinal_compara_tiros_e_asteroide(wire_sinal_compara_tiros_e_asteroides),
    .reset_contador_asteroides(wire_reset_contador_asteroides1),
    .db_estado_compara_asteroides_com_nave_e_tiros(db_estado_compara_asteroides_com_nave_e_tiros)
);

uc_compara_tiros_e_asteroides uc2 (
    /* inputs */
    .clock(clock),
    .reset(reset),
    .compara_tiros_e_asteroides(wire_sinal_compara_tiros_e_asteroides),
    .posicao_tiro_igual_asteroide(wire_colisao_tiro_asteroide),
    .rco_contador_asteroides(wire_rco_contador_asteroides),
    .rco_contador_tiros(wire_rco_contador_tiro),
    .tiro_renderizado(wire_loaded_tiro),
    .aste_renderizado(wire_loaded_asteroide),
    /* outputs */
    .reset_contador_asteroides(wire_reset_contador_asteroides2),
    .reset_contador_tiros(wire_reset_contador_tiros),

    .loaded_tiro(wire_loaded_tiro_output),
    .loaded_asteroide(wire_loaded_asteroide_output),
    .asteroide_destruido(wire_asteroide_destruido),
    .enable_load_tiro(wire_load_tiro),
    .enable_load_asteroide(wire_load_asteroide),

    .conta_contador_asteroides(wire_conta_contador_asteroides2),
    .conta_contador_tiros(wire_conta_contador_tiros),
    .s_fim_comparacao(wire_sinal_fim_compara_tiros_e_asteroides),
    .db_estado_compara_tiros_e_asteroide(db_estado_compara_tiros_e_asteroide)
);

tiro tiro(
    .clock(clock),
    .conta_contador_tiro(wire_conta_contador_tiros),
    .reset_contador_tiro(wire_reset_contador_tiros),
    .select_mux_pos_tiro(),
    .select_mux_coor_tiro(),
    .select_soma_sub_tiro(),
    .enable_reg_nave(),
    .reset_reg_nave(),
    .enable_mem_tiro(),
    .enable_load_tiro(wire_load_tiro),
    .aste_coor_x(wire_aste_coor_x),
    .aste_coor_y(wire_aste_coor_y),
    .new_load_tiro(wire_loaded_tiro_output),
    //saidas
    .x_borda_min_tiro(),
    .y_borda_min_tiro(),
    .x_borda_max_tiro(),
    .y_borda_max_tiro(),
    .colisao_tiro_asteroide(wire_colisao_tiro_asteroide),//colisao com nave
    .rco_contador_tiro(wire_rco_contador_tiro),
    .opcode_tiro(),
    .loaded_tiro(wire_loaded_tiro),
    .db_contador_tiro(),
    .db_wire_saida_som_sub_tiro()
);

asteroide asteroide(
    .clock(clock),
    .reset_contador_aste(wire_reset_contador_asteroides1 | wire_reset_contador_asteroides2),
    .conta_contador_aste(wire_conta_contador_asteroides1 | wire_conta_contador_asteroides2),
    .select_mux_pos_aste(),
    .select_mux_coor_aste(),
    .select_soma_sub_aste(),
    .enable_reg_nave(),
    .reset_reg_nave(),
    .enable_mem_aste(),
    .enable_load_aste(wire_enable_mem_destruido | wire_load_asteroide),
    .new_load_aste(wire_new_loaded_asteroide | wire_loaded_asteroide_output),
    .new_destruido_aste(wire_new_destruido_asteroide | wire_asteroide_destruido),
    //saidas
    .colisao_aste_com_nave(wire_colisao_aste_com_nave),
    .rco_contador_aste(wire_rco_contador_asteroides),
    .opcode_aste(),
    .destruido_aste(),
    .loaded_aste(wire_loaded_asteroide),
    .aste_coor_x(wire_aste_coor_x),
    .aste_coor_y(wire_aste_coor_y),
    .db_contador_aste(),
    .db_wire_saida_som_sub_aste()
);

decrementador #(2) decrementador (
    .clock(clock), 
    .clr  (), 
    .ld   (reset), 
    .ent  (wire_enable_decrementador), 
    .enp  (1'b1), 
    .D    (2'b11), 
    .Q    (num_vidas), 
    .rco  ()
);




endmodule