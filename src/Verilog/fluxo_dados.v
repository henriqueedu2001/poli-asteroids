module fluxo_dados(
    input clock,
    input [5:0] jogada, 
    input clear_asteroide,
    

    // implementa o movimento dos astros
    input clear_reg_asteroide,
    input enable_reg_asteroide_x,
    input enable_reg_asteroide_y,
    input clear_reg_jogada,
    input enable_reg_jogada,

    input select_mux_coor,
    input select_mux_incremento,
    input select_sum_sub,

    // implementa o decremento de vidas
    input clear_decrementer,
    input load_decrementer,
    input ent_decrementer,
    
    output tiro, //
    output colisao,
    output acertou, //
    output vidas,
    
    //depuração
    output db_up,
    output db_down,
    output db_right,
    output db_left,
    output db_special,
    output db_shot,

    output [3:0] db_asteroide_coor_x,
    output [3:0] db_asteroide_coor_y,

    output [3:0] db_num_vidas
);
         
wire [3:0] mux_incremento_out; 
wire [3:0] asteroide_coor_x, asteroide_coor_y;
wire [3:0] demux_coor_out;
wire [4:0] sum_sub_out;
wire [3:0] nave_coor_x, nave_coor_y;
wire [3:0] mux_coordenada_out;
wire wire_x_aste_igual_x_nave, wire_y_aste_igual_y_nave;
wire [3:0] num_vidas;
wire rco_decrementer;
wire [5:0] out_reg_jogada;

or (vidas, num_vidas[3], num_vidas[2], num_vidas[1], num_vidas[0]);

// define a posição da nave
assign nave_coor_x = 4'b0100;
assign nave_coor_y = 4'b0000;

assign db_up = out_reg_jogada[5];
assign db_down = out_reg_jogada[4];
assign db_right = out_reg_jogada[3];
assign db_left = out_reg_jogada[2];
assign db_special = out_reg_jogada[1];
assign db_shot = out_reg_jogada[0];
assign db_num_vidas = num_vidas;
assign colisao = (wire_x_aste_igual_x_nave && wire_y_aste_igual_y_nave) ? 1'b1 : 1'b0;

assign db_asteroide_coor_x = asteroide_coor_x;
assign db_asteroide_coor_y = asteroide_coor_y;

registrador_n #(6) reg_jogada (
    .clock  (clock),
    .clear  (clear_reg_jogada),
    .enable (enable_reg_jogada),
    .D      (jogada),
    .Q      (out_reg_jogada)
);

registrador_n #(4) reg_x_asteroide (
    .clock  (clock),
    .clear  (clear_reg_asteroide | clear_asteroide),
    .enable (enable_reg_asteroide_x),
    .D      ({sum_sub_out[3:0]}),
    .Q      (asteroide_coor_x)
);

registrador_n #(4) reg_y_asteroide (
    .clock  (clock),
    .clear  (clear_reg_asteroide),
    .enable (enable_reg_asteroide_y),
    .D      ({sum_sub_out[3:0]}),
    .Q      (asteroide_coor_y)
);

//mux que seleciona a coordenada a ser incrementada/decrementada
assign mux_coordenada_out = select_mux_coor ? asteroide_coor_y : asteroide_coor_x;

//mux que seleciona o incremento/decremento da coordenada
assign mux_incremento_out = select_mux_incremento ? 4'd2 : 4'd1;

somador_subtrator #(4) somador_subtrator(
    .a      (mux_coordenada_out),
    .b      (mux_incremento_out),
    .select (select_sum_sub),
    .resul  (sum_sub_out)
);

comparador_85 #(4) comparador_x (
    .A    (asteroide_coor_x),
    .B    (nave_coor_x),
    .ALBi (),
    .AGBi (),
    .AEBi (1'b1),
    .ALBo (),
    .AGBo (),
    .AEBo (wire_x_aste_igual_x_nave)
);

comparador_85 #(4) comparador_y (
    .A    (asteroide_coor_y),
    .B    (nave_coor_y),
    .ALBi (),
    .AGBi (),
    .AEBi (1'b1),
    .ALBo (),
    .AGBo (),
    .AEBo (wire_y_aste_igual_y_nave)
);


decrementer #(4) decrementer (
    .clock(clock), 
    .clr  (clear_decrementer), 
    .ld   (load_decrementer), 
    .ent  (ent_decrementer), 
    .enp  (1'b1 && ~rco_decrementer), 
    .D    (4'd3), 
    .Q    (num_vidas), 
    .rco  (rco_decrementer)
);

endmodule