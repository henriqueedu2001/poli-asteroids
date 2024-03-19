module move_asteroides (
        input clock,
        input reset,
        input inicia_move_asteroides,

        output movimentacao_concluida_asteroides,
        output [4:0] db_estado_move_asteroides
);

wire wire_reset_contador_aste;
wire wire_loaded_aste;
wire wire_rco_contador_aste;
wire [1:0] wire_opcode_aste;
wire [1:0] wire_select_mux_pos_aste;
wire wire_select_soma_sub;
wire wire_select_mux_coor_aste;
wire wire_enable_mem_aste;
wire wire_conta_contador_aste;

uc_move_asteroides uc_move_asteroides (
    /* inputs */
    .clock(clock),
    .reset(reset),
    .movimenta_aste(inicia_move_asteroides),
    .loaded_aste(wire_loaded_aste),
    .rco_contador_aste(wire_rco_contador_aste),
    .opcode_aste(wire_opcode_aste),
    /* outputs */
    .select_mux_pos_aste(wire_select_mux_pos_aste),   //seletor do mux da posição 
    .select_mux_coor_aste(wire_select_mux_coor_aste),  //seletor do mux da coordenada 
    .select_soma_sub(wire_select_soma_sub),  
    .reset_contador_aste(wire_reset_contador_aste),
    .conta_contador_aste(wire_conta_contador_aste), 
    .enable_mem_aste(wire_enable_mem_aste), // enable da memoria de tiros
    .movimentacao_concluida_aste(movimentacao_concluida_asteroides), // sinal que indica o fim da movimentação dos tiros
    .db_estado_move_aste(db_estado_move_asteroides)

);

asteroide asteroide(
    /* inputs */
    .clock(clock),
    .conta_contador_aste(wire_conta_contador_aste),
    .reset_contador_aste(wire_reset_contador_aste),
    .select_mux_pos_aste(wire_select_mux_pos_aste),
    .select_mux_coor_aste(wire_select_mux_coor_aste),
    .select_soma_sub_aste(wire_select_soma_sub),
    .enable_reg_nave(),
    .reset_reg_nave(),
    .enable_mem_aste(wire_enable_mem_aste),
    .enable_load_aste(),
    .new_load_aste(),
    .new_destruido_aste(),
    /* outputs */
    .colisao_aste_com_nave(),
    .rco_contador_aste(wire_rco_contador_aste),
    .opcode_aste(wire_opcode_aste),
    .destruido_aste(),
    .loaded_aste(wire_loaded_aste),
    .aste_coor_x(),
    .aste_coor_y(),
    .db_contador_aste(),
    .db_wire_saida_som_sub_aste()
);

endmodule