module astro_genius (
    input clock,
    input reset,
    input [5:0] chaves,
    output saida_serial,

    /* sinais de depuracao */
    output [14:0] matriz_x,
    output [3:0] matriz_y,
    // displays
    output [6:0] db_vidas,
    output [6:0] db_pontos,
    output [4:0] db_uc_menu,
    output [6:0] db_menu1,
    output [6:0] db_menu2,
	output db_up,
    output db_down,
    output db_left,
    output db_right,
    output db_especial,
    output db_tiro
);


hexa7seg HEX5 (
    .hexa    ({3'b0, db_uc_menu[4]}),
    .display (db_menu1)
);

hexa7seg HEX4 (
    .hexa    (db_uc_menu[3:0]),
    .display (db_menu2)
);

wire wire_reset;
wire wire_iniciar_jogo;
wire wire_gameover;
wire wire_jogo_base_em_andamento;

uc_menu uc_menu (
    /*input*/
    .reset(~reset),
    .clock(clock),
    .ocorreu_jogada(wire_ocorreu_jogada),
    .tiro(wire_saida_reg_jogada[0]),
    .especial(wire_saida_reg_jogada[1]),
    .fim_envia_dados(wire_fim_envia_dados), // com serialização
    // .fim_envia_dados(1'b1), // sem serializacao
    .pronto(wire_gameover),
        /*output*/
    .reset_reg_jogada(wire_reset_reg_jogada),
    .enable_reg_jogada(wire_enable_reg_jogada),
    .envia_dados(wire_envia_dados),
    .iniciar(wire_iniciar_jogo),
    .jogo_base_em_andamento(wire_jogo_base_em_andamento),
    .reset_jogo_base(wire_reset),
    .tela_renderizada(wire_tela_renderizada), // 8 bits
    .db_estado_uc_menu(db_uc_menu)
);

wire wire_envia_dados;
wire [7:0] wire_tela_renderizada;
wire wire_fim_envia_dados;




wire wire_enable_reg_jogada;
wire wire_reset_reg_jogada;
wire [5:0] wire_saida_reg_jogada;
registrador_n #(6) reg_jogada (
    /* inputs */
    .clock  (clock),
    .clear  (wire_reset_reg_jogada),
    .enable (wire_enable_reg_jogada),
    .D      (chaves),
    /* output */
    .Q      (wire_saida_reg_jogada)
); 

wire wire_ocorreu_jogada;

or (wire_ocorreu_jogada, wire_ocorreu_tiro, wire_ocorreu_especial);



assign db_up = chaves[5];
assign db_down = chaves[4];
assign db_left = chaves[3];
assign db_right = chaves[2];
assign db_especial = chaves[1];
assign db_tiro = chaves[0];

wire wire_ocorreu_tiro, wire_ocorreu_especial; 

edge_detector edge_detector_tiro(
    /*inputs*/
    .clock(clock),
    .reset(1'b0),
    .sinal(chaves[0]),
    /*output*/
    .pulso(wire_ocorreu_tiro)
);

edge_detector edge_detector_especial(
    /*inputs*/
    .clock(clock),
    .reset(1'b0),
    .sinal(chaves[1]),
    /*output*/
    .pulso(wire_ocorreu_especial)
);

jogo_base jogo_base(
    /* inputs */
    .clock(clock),
    .reset(wire_reset),
    .iniciar(wire_iniciar_jogo),
    .chaves(chaves),
    .jogo_base_em_andamento(wire_jogo_base_em_andamento),
    .tela_renderizar(wire_tela_renderizada),
    .iniciar_transmissao(wire_envia_dados),


    /* outputs */
    .gameover(wire_gameover),
    /* sinais de depuracao */
    .db_estado_jogo_principal(),
    .db_estado_coordena_asteroides_tiros(),
    .db_estado_compara_tiros_e_asteroide(),
    .db_estado_move_tiros(),
    .db_estado_compara_asteroides_com_nave_e_tiros(),
    .db_estado_move_asteroides(),
    .db_estado_registra_tiro(),
    .db_estado_uc_gera_frame(),
    .db_estado_uc_renderiza(),
    .db_uc_gera_asteroide(),
    .matriz_x(matriz_x),
    .matriz_y(matriz_y),
    //displays
    .db_vidas(db_vidas),
    .db_pontos(db_pontos),
    .db_tiro_x(),
    .db_tiro_y(),
    .db_asteroide_x(),
    .db_asteroide_y(),
    .db_up(),
    .db_down(),
    .db_left(),
    .db_right(),
    .db_estado_registra_tiro_especial(),
    .db_especial(),
    .db_estado_uc_envia_dados(),
    .acabou_transmissao(wire_fim_envia_dados),
    .saida_serial(saida_serial)
);

endmodule