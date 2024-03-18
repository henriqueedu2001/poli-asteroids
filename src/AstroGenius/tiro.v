module tiro(
    input clock,
    input conta_contador,
    input reset_cont,
    input [1:0] select_mux_pos,
    input select_mux_coor,
    input select_soma_sub,
    input enable_reg_nave,
    input reset_reg_nave,
    input enable_mem_aste,
    input enable_mem_load,

    input [3:0] aste_coor_x,
    input [3:0] aste_coor_y,

    input new_load,

    output x_borda_min,
    output y_borda_min,
    output x_borda_max,
    output y_borda_max,


    output colisao,
    output rco_contador,
    output [1:0] opcode,
    // output destruido,
    output loaded,

    //saidas que podem ser retiradas
    output [3:0] db_contador,
    output [4:0] db_wire_saida_som_sub

);
         
    wire [3:0] wire_saida_contador;
    wire [3:0] wire_saida_mux_coor;
    wire [9:0] wire_saida_mux_pos;
    wire [9:0] wire_saida_memoria_aste;
    wire wire_select_som_sub;
    wire [4:0] wire_saida_som_sub;
    wire wire_saida_comparador_x;
    wire wire_saida_comparador_y;
    wire [9:0] wire_saida_reg_nave;
    wire [1:0] memoria_loaded;
    wire wire_rco_contador;

    assign db_contador = wire_saida_contador;
    assign db_wire_saida_som_sub = wire_saida_som_sub;

    assign loaded = memoria_loaded[1];
    // assign destruido = memoria_loaded[0];
    assign opcode = wire_saida_memoria_aste[1:0];
    assign rco_contador = wire_rco_contador;
    assign wire_select_som_sub = select_soma_sub;

contador_m #(16, 4) contador(
    /* inputs */
    .clock   (clock),
    .zera_as (reset_cont),
    .zera_s  (),
    .conta   (conta_contador),
   /* outputs */
    .Q       (wire_saida_contador),
    .fim     (wire_rco_contador),
    .meio    ()
);

mux_pos #(4) mux_pos (
    /* inputs */
    .select_mux_pos (select_mux_pos),
    .resul_soma      (wire_saida_som_sub[3:0]),
    .mem_coor_x      (wire_saida_memoria_aste[9:6]),
    .mem_coor_y      (wire_saida_memoria_aste[5:2]),
    .mem_opcode      (wire_saida_memoria_aste[1:0]),
    .random_x        (wire_saida_reg_nave[9:6]),
    .random_y        (wire_saida_reg_nave[5:2]),
    .random_opcode   (wire_saida_reg_nave[1:0]),
    /* output */
    .saida_mux       (wire_saida_mux_pos)
);

memoria_aster memoria_aster (
    /* inputs */
    .clk  (clock),
    .we   (enable_mem_aste),
    .data (wire_saida_mux_pos),
    .addr (wire_saida_contador),
    /* output */
    .q    (wire_saida_memoria_aste) 
);

mux_coor #(4) mux_coor(
    .select_mux_coor (select_mux_coor),
    .mem_coor_x      (wire_saida_memoria_aste[9:6]),
    .mem_coor_y      (wire_saida_memoria_aste[5:2]),
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
    
    .A    (wire_saida_memoria_aste[9:6]), 
    .B    (wire_saida_reg_nave[9:6]),
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
    .A    (wire_saida_memoria_aste[5:2]), 
    .B    (wire_saida_reg_nave[5:2]),
    .ALBi (), 
    .AGBi (), 
    .AEBi (1'b1),  
    /* outputs */
    .ALBo (), 
    .AGBo (), 
    .AEBo (wire_saida_comparador_y)
);

and (colisao, wire_saida_comparador_x, wire_saida_comparador_y);

comparador_85 #(4) comparador_max_x (
    /* inputs */
    .A    (wire_saida_memoria_aste[9:6]), 
    .B    (4'd14),
    .ALBi (), 
    .AGBi (), 
    .AEBi (1'b1),  
    /* outputs */
    .ALBo (), 
    .AGBo (), 
    .AEBo (x_borda_max)
);

comparador_85 #(4) comparador_max_y (
    /* inputs */
    .A    (wire_saida_memoria_aste[5:2]), 
    .B    (4'd14),
    .ALBi (), 
    .AGBi (), 
    .AEBi (1'b1),  
    /* outputs */
    .ALBo (), 
    .AGBo (), 
    .AEBo (y_borda_max)
);

comparador_85 #(4) comparador_min_x (
    /* inputs */
    .A    (wire_saida_memoria_aste[9:6]), 
    .B    (4'd0),
    .ALBi (), 
    .AGBi (), 
    .AEBi (1'b1),  
    /* outputs */
    .ALBo (), 
    .AGBo (), 
    .AEBo (x_borda_min)
);

comparador_85 #(4) comparador_min_y (
    /* inputs */
    .A    (wire_saida_memoria_aste[5:2]), 
    .B    (4'd0),
    .ALBi (), 
    .AGBi (), 
    .AEBi (1'b1),  
    /* outputs */
    .ALBo (), 
    .AGBo (), 
    .AEBo (y_borda_min)
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

memoria_load memoria_load (
    /* inputs */
    .clk  (clock),
    .we   (enable_mem_load),
    .data ({new_load, 1'b0}),
    .addr (wire_saida_contador),
    /* output */
    .q    (memoria_loaded) 
);


endmodule