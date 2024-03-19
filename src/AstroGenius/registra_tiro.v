module registra_tiro (
        input clock                    ,
        input registra_tiro            ,
        input reset                    ,
        output tiro_registrado,
        output [3:0] db_estado
);

    wire wire_clock;
    wire wire_conta_contador;
    wire wire_reset_cont;
    wire [1:0] wire_select_mux_pos;
    wire wire_select_mux_coor;
    wire wire_select_soma_sub;
    wire wire_enable_reg_nave;
    wire wire_reset_reg_nave;
    wire wire_enable_mem_aste;
    wire wire_enable_mem_load;

    wire [3:0] wire_aste_coor_x;
    wire [3:0] wire_aste_coor_y;

    wire wire_x_borda_min;
    wire wire_y_borda_min;
    wire wire_x_borda_max;
    wire wire_y_borda_max;

    wire wire_new_load;
    wire wire_new_destruido;

    wire wire_colisao;
    wire wire_rco_contador;
    wire [1:0] wire_opcode;
    wire wire_loaded;

    wire [3:0] wire_db_contador;
    wire [4:0] wire_db_wire_saida_som_sub;


tiro tiro (
    .clock(clock),
    .conta_contador_tiro(wire_conta_contador),
    .reset_contador_tiro(wire_reset_cont),
    .select_mux_pos_tiro(wire_select_mux_pos),
    .select_mux_coor_tiro(wire_select_mux_coor),
    .select_soma_sub_tiro(wire_select_soma_sub),
    .enable_reg_nave(wire_enable_reg_nave),
    .reset_reg_nave(wire_reset_reg_nave),
    .enable_mem_tiro(wire_enable_mem_aste),
    .enable_load_tiro(wire_enable_mem_load),

    .aste_coor_x(wire_aste_coor_x),
    .aste_coor_y(wire_aste_coor_y),

    .x_borda_min_tiro(wire_x_borda_min),
    .y_borda_min_tiro(wire_y_borda_min),
    .x_borda_max_tiro(wire_x_borda_max),
    .y_borda_max_tiro(wire_y_borda_max),

    .new_load_tiro(wire_new_load),

    .colisao_tiro_asteroide(wire_colisao),
    .rco_contador_tiro(wire_rco_contador),
    .opcode_tiro(wire_opcode),
    .loaded_tiro(wire_loaded),

    .db_contador_tiro(wire_db_contador),
    .db_wire_saida_som_sub_tiro(wire_db_wire_saida_som_sub)

);

uc_registra_tiro uc (
        .clock( clock ),
        .registra_tiro( registra_tiro ), 
        .reset( reset ),
        .loaded_tiro( wire_loaded ),
        .rco_contador_tiro( wire_rco_contador ),
        .enable_mem_tiro ( wire_enable_mem_aste ), 
        .enable_load_tiro( wire_enable_mem_load ),
        .new_load(wire_new_load),

        .clear_contador_tiro ( wire_reset_cont ), 
        .conta_contador_tiro ( wire_conta_contador ), 

        .select_mux_pos ( wire_select_mux_pos ), 
        .tiro_registrado ( tiro_registrado ), 

        .db_estado_registra_tiro ( db_estado )


);


endmodule
