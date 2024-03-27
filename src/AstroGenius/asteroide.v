module asteroide(
    input clock,
    input conta_contador_aste,
    input reset_contador_aste,
    input [1:0] select_mux_pos_aste,
    input select_mux_coor_aste,
    input select_soma_sub_aste,
    input enable_reg_nave,
    input reset_reg_nave,
    input enable_mem_aste,
    input enable_load_aste,
    input reset_memoria_load,
    input new_load_aste,
    input new_destruido_aste,

    input reset_gerador_random,

    output colisao_aste_com_nave,
    output rco_contador_aste,
    output [1:0] opcode_aste,
    output destruido_aste,
    output loaded_aste,

    output [3:0] aste_coor_x,
    output [3:0] aste_coor_y,

    //saidas que podem ser retiradas
    output [3:0] db_contador_aste,
    output [4:0] db_wire_saida_som_sub_aste
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
    wire wire_rco_contador_aste;

    assign db_contador_aste = wire_saida_contador;
    assign db_wire_saida_som_sub_aste = wire_saida_som_sub;

    assign loaded_aste = memoria_loaded[1];
    assign destruido_aste = memoria_loaded[0];
    assign opcode_aste = wire_saida_memoria_aste[1:0];
    assign aste_coor_x = wire_saida_memoria_aste[9:6];
    assign aste_coor_y = wire_saida_memoria_aste[5:2];
    assign rco_contador_aste = wire_rco_contador_aste;
    assign wire_select_som_sub = select_soma_sub_aste;

contador_m #(16, 4) contador(
    /* inputs */
    .clock   (clock),
    .zera_as (reset_contador_aste),
    .zera_s  (),
    .conta   (conta_contador_aste),
   /* outputs */
    .Q       (wire_saida_contador),
    .fim     (wire_rco_contador_aste),
    .meio    ()
);

mux_pos #(4) mux_pos (
    /* inputs */
    .select_mux_pos (select_mux_pos_aste),
    .resul_soma      (wire_saida_som_sub[3:0]),
    .mem_coor_x      (wire_saida_memoria_aste[9:6]), 
    .mem_coor_y      (wire_saida_memoria_aste[5:2]), 
    .mem_opcode      (wire_saida_memoria_aste[1:0]),
    .random_x        (random_asteroide[9:6]), // 4'b0000
    .random_y        (random_asteroide[5:2]), // 4'b0111
    .random_opcode   (random_asteroide[1:0]), // 2'b00
    /* output */
    .saida_mux       (wire_saida_mux_pos)
);

memoria_aste memoria_aste (
    /* inputs */
    .clk  (clock),
    .we   (enable_mem_aste),
    .data (wire_saida_mux_pos),
    .addr (wire_saida_contador),
    /* output */
    .q    (wire_saida_memoria_aste) 
);

wire [3:0] addr_rom;
wire [9:0] random_asteroide;
random random (
    .clock(clock),
    .reset(reset_gerador_random),
    .rnd(addr_rom) 
);

rom_aste rom_aste(
    .clk(clock),
    .addr(addr_rom),
    .q(random_asteroide)
);

mux_coor #(4) mux_coor(
    .select_mux_coor (select_mux_coor_aste),
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

comparador_85 #(4) comparador_x (
    
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

comparador_85 #(4) comparador_y (
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

and (colisao_aste_com_nave, wire_saida_comparador_x, wire_saida_comparador_y);

registrador_n #(10) reg_nave (
    /* inputs */
    .clock  (clock)                 ,
    .clear  (reset_reg_nave)        ,
    .enable (1'b1),
    .D      (10'b0111_0111_00)      ,
    /* output */
    .Q      (wire_saida_reg_nave)
);

memoria_load_aste memoria_load_aste (
    /* inputs */
    .clk  (clock),
    .we   (enable_load_aste),
    .clear(reset_memoria_load),
    .data ({new_load_aste, new_destruido_aste}),
    .addr (wire_saida_contador),
    /* output */
    .q    (memoria_loaded) 
);


endmodule