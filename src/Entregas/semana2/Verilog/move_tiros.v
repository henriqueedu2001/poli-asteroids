module move_tiros (
        input clock,
        input reset,
        input iniciar,

        output movimentacao_concluida_tiro,
        output [4:0] db_estado,
        output [4:0] db_resul_soma_sub
        
);



wire [1:0] wire_opcode;
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
wire wire_enable_mem_load;

uc_move_tiros uc_move_tiros(
        .clock(clock),
        .movimenta_tiro(iniciar),
        .reset(reset),
        .opcode_tiro(wire_opcode),
        .loaded_tiro(wire_loaded_tiro),
        .rco_contador_tiro(wire_rco_contador_tiro),

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
        .enable_load_tiro(wire_enable_load_tiro),
        .new_loaded(wire_new_loaded),         
        .movimentacao_concluida_tiro(movimentacao_concluida_tiro),
        .db_estado_move_tiros(db_estado)

);



tiro tiro(
    .clock(clock),
    .conta_contador_tiro(wire_conta_contador_tiro),
    .reset_contador_tiro(wire_reset_contador_tiro),
    .select_mux_pos_tiro(wire_select_mux_pos_tiro),
    .select_mux_coor_tiro(wire_select_mux_coor_tiro),
    .select_soma_sub_tiro(wire_select_soma_sub),
    .enable_reg_nave(),
    .reset_reg_nave(),
    .enable_mem_tiro(wire_enable_mem_tiro),
    .enable_load_tiro(wire_enable_load_tiro),

    .aste_coor_x(),
    .aste_coor_y(),

    .new_load_tiro(wire_new_loaded),
    //saidas 
    .x_borda_min_tiro(wire_x_borda_min_tiro),
    .y_borda_min_tiro(wire_y_borda_min_tiro),
    .x_borda_max_tiro(wire_x_borda_max_tiro),
    .y_borda_max_tiro(wire_y_borda_max_tiro),


    .colisao_tiro_asteroide(),
    .rco_contador_tiro(wire_rco_contador_tiro),
    .opcode_tiro(wire_opcode),
    .loaded_tiro(wire_loaded_tiro),


    .db_contador_tiro(),
    .db_wire_saida_som_sub_tiro(db_resul_soma_sub)

);
endmodule