
module move_tiros (
        input clock,
        input reset,
        input iniciar,

        output movimentacao_concluida_tiro,
        output [4:0] db_estado
        
);




wire wire_clock;
wire wire_iniciar;
wire wire_reset;
wire [1:0] wire_opcode_tiro;
wire wire_loaded_tiro;
wire wire_rco_contador_tiro;
wire wire_x_borda_max_tiro;
wire wire_y_borda_max_tiro;
wire wire_x_borda_min_tiro;
wire wire_y_borda_min_tiro;
wire [1:0] wire_select_mux_pos_tiro;
wire wire_select_mux_coor_tiro;
wire wire_select_soma_sub;
wire wire_reset_contador_tiro;
wire wire_conta_contador_tiro;
wire wire_enable_mem_tiro;
wire wire_new_loaded;
wire wire_movimentacao_concluida_tiro;

uc_move_tiros uc_move_tiros(
        .clock(clock),
        .iniciar(iniciar),
        .reset(wire_reset),
        .opcode_tiro(wire_opcode_tiro),
        .loaded_tiro(wire_loaded_tiro),
        .rco_contador_tiro(wire_rco_contador_tiro),

        //entradas para verificar se o tiro saiu da tela
        .x_borda_max_tiro(wire_x_borda_max_tiro), 
        .y_borda_max_tiro(wire_y_borda_max_tiro), 
        .x_borda_min_tiro(wire_x_borda_min_tiro), 
        .y_borda_min_tiro(wire_y_borda_min_tiro), 

        //saidas 
        .select_mux_pos_tiro(wire_select_mux_pos_tiro),   
        .select_mux_coor_tiro(wire_select_mux_coor_tiro),  
        .select_soma_sub(wire_select_soma_sub),  
        .reset_contador_tiro(wire_reset_contador_tiro),
        .conta_contador_tiro(wire_conta_contador_tiro), 
        .enable_mem_tiro(wire_enable_mem_tiro),
        .new_loaded(wire_new_loaded),
        .movimentacao_concluida_tiro(wire_movimentacao_concluida_tiro), 
        .db_estado_registra_tiro(db_estado)
);

tiro tiro_fluxo_dados (
    .clock(clock),
    .conta_contador(wire_conta_contador_tiro),
    .reset_cont(wire_reset_contador_tiro),
    .select_mux_pos(wire_select_mux_pos_tiro),
    .select_mux_coor(wire_select_mux_coor_tiro),
    .select_soma_sub(wire_select_soma_sub),
    .enable_reg_nave(1'b1),
    .reset_reg_nave(1'b0),
    .enable_mem_aste(wire_enable_mem_tiro),
    .enable_mem_load(1'b0),

    .aste_coor_x( ),
    .aste_coor_y( ),

    .x_borda_min(wire_x_borda_min_tiro),
    .y_borda_min(wire_y_borda_min_tiro),
    .x_borda_max(wire_x_borda_max_tiro),
    .y_borda_max(wire_y_borda_max_tiro),

    .new_load(wire_new_load),

    .colisao(wire_colisao),
    .rco_contador(wire_rco_contador_tiro),
    .opcode(wire_opcode_tiro),
    .loaded(wire_loaded_tiro),

    .db_contador(  ),
    .db_wire_saida_som_sub(  )

);

endmodule

