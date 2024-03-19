module tiro(
    input clock,
    input conta_contador_tiro,
    input reset_contador_tiro,
    input [1:0] select_mux_pos_tiro,
    input select_mux_coor_tiro,
    input select_soma_sub_tiro,
    input enable_reg_nave,
    input reset_reg_nave,
    input enable_mem_tiro,
    input enable_load_tiro,
    input [3:0] aste_coor_x,
    input [3:0] aste_coor_y,
    input new_load_tiro,
    input [1:0] opcode_registra_tiro,
    output x_borda_min_tiro,
    output y_borda_min_tiro,
    output x_borda_max_tiro,
    output y_borda_max_tiro,
    output colisao_tiro_asteroide,
    output rco_contador_tiro,
    output [1:0] opcode_tiro,
    // output destruido,
    output loaded_tiro,
    //saidas que podem ser retiradas
    output [3:0] db_contador_tiro,
    output [4:0] db_wire_saida_som_sub_tiro

);
         
    wire [3:0] wire_saida_contador;
    wire [3:0] wire_saida_mux_coor;
    wire [9:0] wire_saida_mux_pos;
    wire [9:0] wire_saida_memoria_tiro;
    wire wire_select_som_sub;
    wire [4:0] wire_saida_som_sub;
    wire wire_saida_comparador_x;
    wire wire_saida_comparador_y;
    wire [9:0] wire_saida_reg_nave;
    wire [1:0] memoria_loaded;
    wire wire_rco_contador_tiro;

    assign db_contador_tiro = wire_saida_contador;
    assign db_wire_saida_som_sub_tiro = wire_saida_som_sub;

    assign loaded_tiro = memoria_loaded[1];
    // assign destruido = memoria_loaded[0];
    assign opcode_tiro = wire_saida_memoria_tiro[1:0];
    assign rco_contador_tiro = wire_rco_contador_tiro;
    assign wire_select_som_sub = select_soma_sub_tiro;

contador_m #(16, 4) contador(
    /* inputs */
    .clock   (clock),
    .zera_as (reset_contador_tiro),
    .zera_s  (),
    .conta   (conta_contador_tiro),
   /* outputs */
    .Q       (wire_saida_contador),
    .fim     (wire_rco_contador_tiro),
    .meio    ()
);

mux_pos #(4) mux_pos (
    /* inputs */
    .select_mux_pos (select_mux_pos_tiro),
    .resul_soma      (wire_saida_som_sub[3:0]),
    .mem_coor_x      (wire_saida_memoria_tiro[9:6]),
    .mem_coor_y      (wire_saida_memoria_tiro[5:2]),
    .mem_opcode      (wire_saida_memoria_tiro[1:0]),
    .random_x        (wire_saida_reg_nave[9:6]),
    .random_y        (wire_saida_reg_nave[5:2]),
    .random_opcode   (opcode_registra_tiro),
    /* output */
    .saida_mux       (wire_saida_mux_pos)
);

memoria_tiro memoria_tiro (
    /* inputs */
    .clk  (clock),
    .we   (enable_mem_tiro),
    .data (wire_saida_mux_pos),
    .addr (wire_saida_contador),
    /* output */
    .q    (wire_saida_memoria_tiro) 
);

mux_coor #(4) mux_coor(
    .select_mux_coor (select_mux_coor_tiro),
    .mem_coor_x      (wire_saida_memoria_tiro[9:6]),
    .mem_coor_y      (wire_saida_memoria_tiro[5:2]),
    /* output */
    .saida_mux       (wire_saida_mux_coor)
);

somador_subtrator #(4) som_sub (
    /* inputs */
    .a(wire_saida_mux_coor),
    .b(4'b0001),
    .select(wire_select_som_sub),
    /* output */
    .resul(wire_saida_som_sub)
);

comparador_85 #(4) comparador_pos_x (
    
    .A    (wire_saida_memoria_tiro[9:6]), 
    .B    (aste_coor_x),
    .ALBi (), 
    .AGBi (), 
    .AEBi (1'b1),  
    /* outputs */
    .ALBo (), 
    .AGBo (), 
    .AEBo (wire_saida_comparador_x)
);

comparador_85 #(4) comparador_pos_y (
    /* inputs */
    .A    (wire_saida_memoria_tiro[5:2]), 
    .B    (aste_coor_y),
    .ALBi (), 
    .AGBi (), 
    .AEBi (1'b1),  
    /* outputs */
    .ALBo (), 
    .AGBo (), 
    .AEBo (wire_saida_comparador_y)
);

and (colisao_tiro_asteroide, wire_saida_comparador_x, wire_saida_comparador_y);

comparador_85 #(4) comparador_max_x (
    /* inputs */
    .A    (wire_saida_memoria_tiro[9:6]), 
    .B    (4'd14),
    .ALBi (), 
    .AGBi (), 
    .AEBi (1'b1),  
    /* outputs */
    .ALBo (), 
    .AGBo (), 
    .AEBo (x_borda_max_tiro)
);

comparador_85 #(4) comparador_max_y (
    /* inputs */
    .A    (wire_saida_memoria_tiro[5:2]), 
    .B    (4'd14),
    .ALBi (), 
    .AGBi (), 
    .AEBi (1'b1),  
    /* outputs */
    .ALBo (), 
    .AGBo (), 
    .AEBo (y_borda_max_tiro)
);

comparador_85 #(4) comparador_min_x (
    /* inputs */
    .A    (wire_saida_memoria_tiro[9:6]), 
    .B    (4'd0),
    .ALBi (), 
    .AGBi (), 
    .AEBi (1'b1),  
    /* outputs */
    .ALBo (), 
    .AGBo (), 
    .AEBo (x_borda_min_tiro)
);

comparador_85 #(4) comparador_min_y (
    /* inputs */
    .A    (wire_saida_memoria_tiro[5:2]), 
    .B    (4'd0),
    .ALBi (), 
    .AGBi (), 
    .AEBi (1'b1),  
    /* outputs */
    .ALBo (), 
    .AGBo (), 
    .AEBo (y_borda_min_tiro)
);

registrador_n #(10) reg_nave (
    /* inputs */
    .clock  (clock)                 ,
    .clear  (reset_reg_nave)        ,
    .enable (enable_reg_nave | 1'b1),
    .D      (10'b0111_0111_00)      ,
    /* output */
    .Q      (wire_saida_reg_nave)
);

memoria_load_tiro memoria_load_tiro (
    /* inputs */
    .clk  (clock),
    .we   (enable_load_tiro),
    .data ({new_load_tiro, 1'b0}),
    .addr (wire_saida_contador),
    /* output */
    .q    (memoria_loaded) 
);


endmodule