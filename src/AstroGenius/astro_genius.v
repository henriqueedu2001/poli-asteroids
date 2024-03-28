module astro_genius (
    input clock,
    input reset,
    input iniciar,
    input [2:0] dificuldade,
    input [5:0] chaves,
    output pronto,
    /* sinais de depuracao */
    output [4:0] db_estado_jogo_principal,
    output [4:0] db_estado_coordena_asteroides_tiros,
    output [4:0] db_estado_compara_tiros_e_asteroide,
    output [4:0] db_estado_move_tiros,
    output [4:0] db_estado_compara_asteroides_com_nave_e_tiros,
    output [4:0] db_estado_move_asteroides,
    output [3:0] db_estado_registra_tiro,
    output [3:0] db_estado_uc_gera_frame,
    output [3:0] db_estado_uc_renderiza,
    output [3:0] db_uc_gera_asteroide,
    output [14:0] matriz_x,
    output [3:0] matriz_y,
    output [6:0] db_vidas,
    output [6:0] db_pontos,
    output [6:0] db_tiro_x,
    output [6:0] db_tiro_y,
    output [6:0] db_asteroide_x,
    output [6:0] db_asteroide_y,
    output db_up,
    output db_down,
    output db_left,
    output db_right,
    output [3:0] db_estado_registra_tiro_especial,
    output db_especial
);


assign db_up = chaves[5];
assign db_down = chaves[4];
assign db_left = chaves[3];
assign db_right = chaves[2];

wire wire_vidas;
wire wire_fim_movimentacao_asteroides_e_tiros;
wire wire_inicia_registra_tiros;
wire wire_inicia_movimentacao_asteroides_e_tiros;
wire wire_reset_maquinas;
wire wire_reset_contador_asteroides_uc_principal;
wire wire_reset_contador_tiro_uc_principal; 
wire wire_enable_decrementador; 
wire wire_reset_contador_vidas;
wire wire_ocorreu_tiro;
wire wire_ocorreu_jogada;
wire wire_reset_reg_jogada;
wire wire_enable_reg_jogada;
wire wire_destruido_aste;
wire [3:0] wire_aste_coor_x;
wire [3:0] wire_aste_coor_y;
wire [1:0] wire_opcode_mux_out;
wire wire_reset_pontuacao_uc_principal;
wire wire_termina_uc_jogo_principal;
wire wire_fim_registra_especial;
wire wire_wire_ocorreu_tiro;
wire wire_tiro;
wire wire_especial;
wire wire_inicia_registra_especial;
wire wire_wire_reset_pontuacao;



/********************************************************************************************************************/
/*********************************************UC_JOGO_PRINCIPAL******************************************************/
/********************************************************************************************************************/
wire wire_ocorreu_especial;
uc_jogo_principal uc_jogo_principal(
    /* inputs */
    .clock(clock),
    .iniciar(iniciar),
    .reset(reset),
    .vidas(~wire_vidas),
    .fim_movimentacao_asteroides_e_tiros(wire_fim_movimentacao_asteroides_e_tiros), 
    .fim_registra_tiros(wire_tiro_registrado),
    .fim_registra_especial(wire_fim_registra_especial),
    .ocorreu_tiro(wire_ocorreu_tiro),
    .ocorreu_jogada(wire_ocorreu_jogada),
    .ocorreu_especial(wire_ocorreu_especial),
    .tiro(wire_saida_reg_jogada[0]),
    .especial(wire_saida_reg_jogada[1]),
    .rco_intervalo_especial(wire_rco_intervalo_especial),
    /* outputs */
    .enable_reg_jogada(wire_enable_reg_jogada),
    .reset_reg_jogada(wire_reset_reg_jogada),
    .reset_pontuacao(wire_reset_pontuacao_uc_principal),
    .inicia_registra_tiros(wire_inicia_registra_tiros),
    .inicia_registra_especial(wire_inicia_registra_especial),
    .inicia_movimentacao_asteroides_e_tiros(wire_inicia_movimentacao_asteroides_e_tiros), 
    .reset_contador_asteroides(wire_reset_contador_asteroides_uc_principal),
    .reset_contador_tiro(wire_reset_contador_tiro_uc_principal),
    .reset_contador_vidas(wire_reset_contador_vidas),
    .reset_maquinas(wire_reset_maquinas),
    .pronto(pronto),
    .termina(wire_termina_uc_jogo_principal),
    .db_estado_jogo_principal(db_estado_jogo_principal)
);

wire [1:0] wire_opcode_especial;
wire wire_enable_load_tiro_uc_registra_especial;
wire wire_select_mux_pos_uc_registra_especial;
wire [1:0] wire_select_mux_pos_tiro_uc_registra_especial;


/********************************************************************************************************************/
/*********************************************UC_REGISTRA_ESPECIAL***************************************************/
/********************************************************************************************************************/

uc_registra_especial uc_registra_especial(
    /* inputs */
    .clock(clock),
    .reset(wire_reset_maquinas),
    .registra_tiro_especial(wire_inicia_registra_especial), 
    .loaded_tiro(wire_tiro_renderizado),
    .rco_contador_tiro(wire_rco_contador_tiro),
    .rco_opcode(wire_rco_contador_especial),
    /* outputs */
    .reset_contador_tiro(wire_reset_contador_tiro_uc_registra_especial), 
    .reset_contador_especial(wire_reset_contador_especial_uc_registra_especial),
    .reset_intervalo_especial(wire_reset_intervalo_especial),
    .enable_mem_tiro(wire_enable_mem_tiro_uc_registra_especial), 
    .select_mux_pos(wire_select_mux_pos_tiro_uc_registra_especial),
    .new_load(wire_new_load_uc_registra_especial),
    .enable_load_tiro(wire_enable_load_tiro_uc_registra_especial),
    .conta_contador_opcode(wire_conta_contador_opcode),
    .conta_contador_tiro(wire_conta_contador_tiro_uc_registra_especial),
    .especial_registrado(wire_fim_registra_especial), 
    .select_mux_especial_opcode(wire_select_mux_especial_opcode),
    .db_estado_registra_tiro_especial(db_estado_registra_tiro_especial)
);


mux_reg_jogada mux_jogada(
    .select_mux_jogada (wire_saida_reg_jogada[5:2]),
    /* output */
    .saida_mux       (wire_opcode_mux_out)
);

/**********mux para o seletor do opcode para registrar o tiro***************/
wire [1:0] wire_opcode_registra_tiro;
assign wire_opcode_registra_tiro = wire_select_mux_especial_opcode ?  wire_opcode_contador_especial : wire_opcode_mux_out;

wire wire_rco_contador_especial;
wire [1:0] wire_opcode_contador_especial;

contador_m #(4, 2) contador_tiro_especial_opcode (
    /* inputs */
    .clock(clock),
    .zera_as(wire_reset_contador_especial_uc_registra_especial),
    .zera_s(1'b0),
    .conta(wire_conta_contador_opcode),
    /* outputs */
    .Q(wire_opcode_contador_especial),
    .fim(wire_rco_contador_especial),
    .meio()
);

wire wire_rco_contador_tiro;
wire wire_rco_contador_asteroides;
wire wire_fim_move_tiros;
wire wire_fim_move_asteroides;
wire wire_fim_comparacao_asteroides_com_a_nave_e_tiros;
wire wire_fim_comparacao_tiros_e_asteroides;
wire wire_movimenta_tiro;
wire wire_sinal_movimenta_asteroides;
wire wire_sinal_compara_tiros_e_asteroides_uc_coordena_asteroides_tiros;
wire wire_sinal_compara_asteroides_com_a_nave_e_tiro;
wire wire_sinal_compara_tiros_e_asteroide_uc_compara_asteroides_com_nave_e_tiros;
wire wire_inicia_gera_frame_uc_coordena_asteroides_tiros;
wire wire_fim_gera_frame_uc_gera_frame;
wire wire_pausar_renderizacao;
wire wire_gera_asteroide;
wire wire_rco_contador_gera_aste;
wire reset_contador_gera_aste;


/********************************************************************************************************************/
/**************************************************DIFICULDADES******************************************************/
/********************************************************************************************************************/
wire wire_rco_contador_movimenta_tiro;
wire wire_rco_contador_movimenta_asteroide;
wire wire_reset_contador_movimenta_tiro;
wire wire_reset_contador_movimenta_asteroide;

parameter tiro_easy = 64'd800;
parameter tiro_medium = 64'd800;
parameter tiro_hard = 64'd800;

parameter tempo_move_asteroide_easy = 64'd5000;
parameter tempo_move_asteroide_medium = 64'd3000;
parameter tempo_move_asteroide_hard = 64'd1000;

parameter tempo_gera_asteroide_easy = 64'd10000;
parameter tempo_gera_asteroide_medium = 64'd3000;
parameter tempo_gera_asteroide_hard = 64'd1000;

parameter tempo_especial = 64'd20000;

wire [63:0] tempo_gera_aste;
wire [63:0] tempo_move_aste;
wire [63:0] tempo_move_tiro;

assign tempo_gera_aste = (dificuldade == 3'b100) ? tempo_gera_asteroide_easy :
                         (dificuldade == 3'b010) ? tempo_gera_asteroide_medium : tempo_gera_asteroide_hard;
                          
assign tempo_move_aste = (dificuldade == 3'b100) ? tempo_move_asteroide_easy:
                         (dificuldade == 3'b010) ? tempo_move_asteroide_medium : tempo_move_asteroide_hard;

assign tempo_move_tiro = (dificuldade == 3'b100) ? tiro_easy :
                         (dificuldade == 3'b010) ? tiro_medium : tiro_hard;

contador_163 #(64) contador_gera_asteroide  ( 
    /* inputs */
    .clock(clock), 
    .clr(wire_reset_contador_gera_asteroide), 
    .ld(1'b0), 
    .ent(1'b1), 
    .enp(wire_conta_contador_gera_asteroide), 
    .D(),
    .Max(tempo_gera_aste),
    /* outputs */
    .Q(),
    .rco(wire_rco_contador_gera_aste)
);

contador_163 #(64) contador_movimenta_tiro  ( 
    /* inputs */
    .clock(clock), 
    .clr(wire_reset_contador_movimenta_tiro), 
    .ld(1'b0), 
    .ent(1'b1), 
    .enp(1'b1), 
    .D(),
    .Max(tempo_move_tiro),
    /*outputs*/
    .Q(),
    .rco(wire_rco_contador_movimenta_tiro)
);

contador_163 #(64) contador_movimenta_asteroide  ( 
    /* inputs */
    .clock(clock), 
    .clr(wire_reset_contador_movimenta_asteroide), 
    .ld(1'b0), 
    .ent(1'b1), 
    .enp(1'b1), 
    .D(),
    .Max(tempo_move_aste),
    /*outputs*/
    .Q(),
    .rco(wire_rco_contador_movimenta_asteroide)
);

wire wire_reset_intervalo_especial;
wire wire_rco_intervalo_especial;
contador_163 #(64) contador_especial_163  ( 
    /* inputs */
    .clock(clock), 
    .clr(wire_reset_intervalo_especial), 
    .ld(1'b0), 
    .ent(1'b1), 
    .enp(1'b1), 
    .D(),
    .Max(tempo_especial),
    /*outputs*/
    .Q(),
    .rco(wire_rco_intervalo_especial)
);
assign db_especial = wire_rco_intervalo_especial;


/********************************************************************************************************************/
/*********************************************UC_COORDENA_ASTEROIDES*************************************************/
/********************************************************************************************************************/

uc_coordena_asteroides_tiros uc_coordena_asteroides_tiros(
    /* inputs */
    .clock(clock),
    .reset(wire_reset_maquinas),
    .move_tiro_e_asteroides(wire_inicia_movimentacao_asteroides_e_tiros),
    .rco_contador_movimenta_tiros(wire_rco_contador_movimenta_tiro),
    .rco_contador_movimenta_asteroides(wire_rco_contador_movimenta_asteroide),
    .fim_move_tiros(wire_fim_move_tiros),
    .fim_move_asteroides(wire_fim_move_asteroides),
    .fim_comparacao_asteroides_com_a_nave_e_tiros(wire_fim_comparacao_asteroides_com_a_nave_e_tiros),
    .fim_comparacao_tiros_e_asteroides(wire_fim_comparacao_tiros_e_asteroides),
    .fim_gera_frame(wire_fim_gera_frame_uc_gera_frame),
    .fim_gera_asteroide(wire_fim_gera_asteroide),
    .gera_aste(wire_rco_contador_gera_aste),
    .termina_operacao(wire_termina_uc_jogo_principal),
    /* outputs */
    .movimenta_tiro(wire_movimenta_tiro),
    .sinal_movimenta_asteroides(wire_sinal_movimenta_asteroides),
    .sinal_compara_tiros_e_asteroides(wire_sinal_compara_tiros_e_asteroides_uc_coordena_asteroides_tiros ),
    .sinal_compara_asteroides_com_a_nave_e_tiro(wire_sinal_compara_asteroides_com_a_nave_e_tiro),
    .fim_move_tiro_e_asteroides(wire_fim_movimentacao_asteroides_e_tiros),
    .db_estado_coordena_asteroides_tiros(db_estado_coordena_asteroides_tiros),
    .gera_frame(wire_inicia_gera_frame_uc_coordena_asteroides_tiros),
    .pausar_renderizacao(wire_pausar_renderizacao),
    .gera_asteroide(wire_gera_asteroide),
    .reset_gerador_random(wire_reset_gerador_random)
);

wire wire_reset_contador_asteroides_uc_gera_asteroide;
wire wire_conta_contador_asteroides_uc_gera_asteroide;
wire wire_enable_mem_aste_uc_gera_asteroide;
wire wire_enable_load_aste_uc_gera_asteroide;
wire wire_new_loaded_aste_uc_gera_asteroide;
wire wire_conta_contador_gera_asteroide;
wire wire_reset_contador_gera_asteroide;



/********************************************************************************************************************/
/*********************************************UC_GERA_ASTEROIDE******************************************************/
/********************************************************************************************************************/

uc_gera_asteroide uc_gera_asteroide (
    /* inputs */
    .clock(clock)        ,
    .reset(wire_reset_maquinas),
    .gera_asteroide(wire_gera_asteroide),      
    .rco_contador_asteroide(wire_rco_contador_asteroides),
    .asteroide_renderizado(wire_aste_renderizado),

    /* outputs */
    .reset_contador_asteroide(wire_reset_contador_asteroides_uc_gera_asteroide),
    .conta_contador_asteroide(wire_conta_contador_asteroides_uc_gera_asteroide),
    .conta_contador_gera_asteroide(wire_conta_contador_gera_asteroide),
    .reset_contador_gera_asteroide(wire_reset_contador_gera_asteroide),
    .enable_mem_aste(wire_enable_mem_aste_uc_gera_asteroide),
    .enable_load_aste(wire_enable_load_aste_uc_gera_asteroide),
    .new_loaded_aste(wire_new_loaded_aste_uc_gera_asteroide),
    .fim_gera_asteroide(wire_fim_gera_asteroide),
    .db_uc_gera_asteroide(db_uc_gera_asteroide)
);


wire wire_conta_contador_asteroides_uc_gera_frame;
wire wire_conta_contador_tiro_uc_gera_frame;
wire wire_reset_contador_tiro_uc_gera_frame;
wire wire_reset_contador_asteroide_uc_gera_frame;
wire wire_clear_mem_frame;
wire wire_enable_mem_frame;
wire [1:0] wire_select_mux_gera_frame;



/********************************************************************************************************************/
/*************************************************UC_GERA_FRAME******************************************************/
/********************************************************************************************************************/

uc_gera_frame uc_gera_frame (
        /*inputs*/
        .clock(clock),
        .reset(reset_maquinas),
        .gera_frame(wire_inicia_gera_frame_uc_coordena_asteroides_tiros),
        .rco_contador_asteroides(wire_rco_contador_asteroides),
        .rco_contador_tiro(wire_rco_contador_tiro),
        .loaded_tiro(wire_tiro_renderizado),
        .loaded_asteroide(wire_aste_renderizado),
        /*outputs*/
        .conta_contador_asteroide(wire_conta_contador_asteroides_uc_gera_frame),
        .conta_contador_tiro(wire_conta_contador_tiro_uc_gera_frame),
        .reset_contador_tiro(wire_reset_contador_tiro_uc_gera_frame),
        .reset_contador_asteroide(wire_reset_contador_asteroide_uc_gera_frame),
        .clear_mem_frame(wire_clear_mem_frame),
        .enable_mem_frame(wire_enable_mem_frame),
        .fim_gera_frame(wire_fim_gera_frame_uc_gera_frame),
        .select_mux_gera_frame(wire_select_mux_gera_frame),
        .db_estado_uc_gera_frame(db_estado_uc_gera_frame)
);


wire [3:0] wire_entrada_x_memoria_frame;
wire [3:0] wire_entrada_y_memoria_frame;

assign wire_entrada_x_memoria_frame = (wire_select_mux_gera_frame == 2'b00) ? wire_aste_coor_x : 
                                      (wire_select_mux_gera_frame == 2'b01) ? wire_tiro_coor_x : 
                                      (wire_select_mux_gera_frame == 2'b10) ? 4'b0111          : wire_saida_contador_frame ;
 
assign wire_entrada_y_memoria_frame = (wire_select_mux_gera_frame == 2'b00) ? wire_aste_coor_y : 
                                      (wire_select_mux_gera_frame == 2'b01) ? wire_tiro_coor_y :
                                      (wire_select_mux_gera_frame == 2'b10) ? 4'b0111          : wire_saida_contador_frame;

memoria_frame memoria_frame(
            /*inputs*/
            .coor_x(wire_entrada_y_memoria_frame),
            .coor_y(wire_entrada_x_memoria_frame),
            .clk   (clock),
            .clear(wire_clear_mem_frame),
            .we   (wire_enable_mem_frame),
            /*outputs*/
            .saida_x(matriz_x),
            .saida_y(matriz_y)
            );

wire wire_rco_contador_frame;
wire wire_conta_contador_frame;
wire wire_reset_contador_frame;



/********************************************************************************************************************/
/*********************************************UC_RENDERIZA******************************************************/
/********************************************************************************************************************/

wire [3:0] wire_saida_contador_frame; 
wire [3:0] entrada_y_mem_frame;

uc_renderiza uc_renderiza (
        /*inputs*/
        .clock(clock),
        .reset(wire_reset_maquinas),
        .pausar_renderizacao(wire_pausar_renderizacao),
        .rco_contador_frame(wire_rco_contador_frame),
        /*outputs*/
        .reset_contador_frame(wire_reset_contador_frame),
        .conta_contador_frame(wire_conta_contador_frame),
        .db_estado_uc_renderiza(db_estado_uc_renderiza)
);

 contador_m #(15, 4) contador_renderiza(
    /*inputs*/
   .clock(clock),
   .zera_as(wire_reset_contador_frame),
   .zera_s(1'b0),
   .conta(wire_conta_contador_frame),
   /*outputs*/
   .Q(wire_saida_contador_frame),
   .fim(wire_rco_contador_frame),
   .meio()
  );





/********************************************************************************************************************/
/*************************************UC_COMPARA_TIROS_E_ASTEROIDES**************************************************/
/********************************************************************************************************************/

wire wire_posicao_tiro_igual_asteroide;
wire wire_tiro_renderizado;
wire wire_aste_renderizado;
wire wire_reset_contador_asteroides_uc_compara_tiros_e_asteroides;
wire wire_reset_contador_tiros_uc_compara_tiros_e_asteroides;
wire wire_enable_load_tiro_uc_compara_tiros_e_asteroides;
wire wire_enable_load_asteroide_uc_compara_tiros_e_asteroides;
wire wire_new_loaded_tiro_uc_compara_tiros_e_asteroides;
wire wire_new_loaded_asteroide_uc_compara_tiros_e_asteroides;
wire wire_new_destruido_asteroide_uc_compara_tiros_e_asteroides;
wire wire_incrementa_pontos_uc_compara_tiros_e_asteroides;
wire wire_conta_contador_asteroides_uc_compara_tiros_e_asteroides;
wire wire_conta_contador_tiros_uc_compara_tiros_e_asteroides;

uc_compara_tiros_e_asteroides uc_compara_tiros_e_asteroides (
    /* inputs */
    .clock(clock),
    .reset(wire_reset_maquinas),
    .compara_tiros_e_asteroides(wire_sinal_compara_tiros_e_asteroides_uc_coordena_asteroides_tiros |
                                wire_sinal_compara_tiros_e_asteroide_uc_compara_asteroides_com_nave_e_tiros
                                ),
    .posicao_tiro_igual_asteroide(wire_posicao_tiro_igual_asteroide),
    .rco_contador_asteroides(wire_rco_contador_asteroides),
    .rco_contador_tiros(wire_rco_contador_tiro),
    .tiro_renderizado(wire_tiro_renderizado),
    .aste_renderizado(wire_aste_renderizado),
    /* outputs */
    .reset_contador_asteroides(wire_reset_contador_asteroides_uc_compara_tiros_e_asteroides),
    .reset_contador_tiros(wire_reset_contador_tiros_uc_compara_tiros_e_asteroides),
    .enable_load_tiro(wire_enable_load_tiro_uc_compara_tiros_e_asteroides),
    .enable_load_asteroide(wire_enable_load_asteroide_uc_compara_tiros_e_asteroides),
    .loaded_tiro(wire_new_loaded_tiro_uc_compara_tiros_e_asteroides),
    .loaded_asteroide(wire_new_loaded_asteroide_uc_compara_tiros_e_asteroides),
    .asteroide_destruido(wire_new_destruido_asteroide_uc_compara_tiros_e_asteroides),
    .conta_contador_asteroides(wire_conta_contador_asteroides_uc_compara_tiros_e_asteroides),
    .conta_contador_tiros(wire_conta_contador_tiros_uc_compara_tiros_e_asteroides),
    .incrementa_pontos(wire_incrementa_pontos_uc_compara_tiros_e_asteroides),
    .s_fim_comparacao(wire_fim_comparacao_tiros_e_asteroides),
    .db_estado_compara_tiros_e_asteroide(db_estado_compara_tiros_e_asteroide)
);


/********************************************************************************************************************/
/*************************************************UC_MOVE_TIROS******************************************************/
/********************************************************************************************************************/

wire [1:0] wire_opcode_tiro;
wire wire_x_borda_max_tiro;
wire wire_y_borda_max_tiro;
wire wire_x_borda_min_tiro;
wire wire_y_borda_min_tiro;
wire [1:0] wire_select_mux_pos_tiro_uc_move_tiros;
wire wire_select_mux_coor_tiro_uc_move_tiros;
wire wire_select_soma_sub_uc_move_tiros;
wire wire_reset_contador_tiro_uc_move_tiros;
wire wire_conta_contador_tiro_uc_move_tiros;
wire wire_enable_mem_tiro_uc_move_tiros;
wire wire_enable_load_tiro_uc_move_tiros;
wire wire_new_loaded_tiro_uc_move_tiros;

uc_move_tiros uc_move_tiros (
    /* inputs */
    .clock(clock),
    .movimenta_tiro(wire_movimenta_tiro),
    .reset(wire_reset_maquinas),
    .opcode_tiro(wire_opcode_tiro),
    .loaded_tiro(wire_tiro_renderizado),
    .rco_contador_tiro(wire_rco_contador_tiro),
    .x_borda_max_tiro(wire_x_borda_max_tiro),
    .y_borda_max_tiro(wire_y_borda_max_tiro),
    .x_borda_min_tiro(wire_x_borda_min_tiro),
    .y_borda_min_tiro(wire_y_borda_min_tiro), 
    /* outputs */
    .select_mux_pos_tiro (wire_select_mux_pos_tiro_uc_move_tiros),   
    .select_mux_coor_tiro(wire_select_mux_coor_tiro_uc_move_tiros),   
    .select_soma_sub(wire_select_soma_sub_uc_move_tiros),  
    .reset_contador_tiro(wire_reset_contador_tiro_uc_move_tiros),
    .conta_contador_tiro(wire_conta_contador_tiro_uc_move_tiros), 
    .reset_contador_movimenta_tiro(wire_reset_contador_movimenta_tiro),
    .enable_mem_tiro(wire_enable_mem_tiro_uc_move_tiros), 
    .enable_load_tiro(wire_enable_load_tiro_uc_move_tiros),
    .new_loaded(wire_new_loaded_tiro_uc_move_tiros),                
    .movimentacao_concluida_tiro(wire_fim_move_tiros), 
    .db_estado_move_tiros(db_estado_move_tiros)
);



/********************************************************************************************************************/
/**********************************UC_COMPARA_ASTEROIDES_COM_NAVE_E_TIROS********************************************/
/********************************************************************************************************************/
wire wire_posicao_asteroide_igual_nave;
wire wire_new_loaded_asteroide_uc_compara_asteroides_com_nave_e_tiros;
wire wire_new_destruido_asteroide_uc_compara_asteroides_com_nave_e_tiros;
wire wire_enable_load_asteroides_uc_compara_asteroides_com_nave_e_tiros;
wire wire_reset_contador_asteroides_uc_compara_asteroides_com_nave_e_tiros;
wire wire_conta_contador_asteroides_uc_compara_asteroides_com_nave_e_tiros;

uc_compara_asteroides_com_nave_e_tiros uc_compara_asteroides_com_nave_e_tiros (
    /* inputs */
    .clock(clock),
    .reset(wire_reset_maquinas),
    .iniciar_comparacao_tiros_nave_asteroides(wire_sinal_compara_asteroides_com_a_nave_e_tiro),
    .posicao_asteroide_igual_nave(wire_posicao_asteroide_igual_nave),
    .ha_vidas(~wire_vidas),
    .rco_contador_asteroides(wire_rco_contador_asteroides),
    .fim_compara_tiros_e_asteroides(wire_fim_comparacao_tiros_e_asteroides),
    .loaded_asteroide(wire_aste_renderizado),
    .destruido_asteroide(wire_destruido_aste),
    /* outputs */
    .enable_decrementador(wire_enable_decrementador),
    .new_loaded_asteroide(wire_new_loaded_asteroide_uc_compara_asteroides_com_nave_e_tiros),
    .new_destruido_asteroide(wire_new_destruido_asteroide_uc_compara_asteroides_com_nave_e_tiros),
    .fim_compara_asteroides_com_tiros_e_nave(wire_fim_comparacao_asteroides_com_a_nave_e_tiros),
    .enable_load_asteroide(wire_enable_load_asteroides_uc_compara_asteroides_com_nave_e_tiros),
    .conta_contador_asteroides(wire_conta_contador_asteroides_uc_compara_asteroides_com_nave_e_tiros), 
    .sinal_compara_tiros_e_asteroide(wire_sinal_compara_tiros_e_asteroide_uc_compara_asteroides_com_nave_e_tiros),
    .reset_contador_asteroides(wire_reset_contador_asteroides_uc_compara_asteroides_com_nave_e_tiros),
    .db_estado_compara_asteroides_com_nave_e_tiros(db_estado_compara_asteroides_com_nave_e_tiros)
);



/********************************************************************************************************************/
/*********************************************UC_MOVE_ASTEROIDES*****************************************************/
/********************************************************************************************************************/
wire [1:0] wire_opcode_aste;
wire [1:0] wire_select_mux_pos_aste_uc_move_asteroides;
wire wire_select_mux_coor_aste_uc_move_asteroides;
wire wire_select_soma_sub_uc_move_asteroides;
wire wire_reset_contador_aste_uc_move_asteroides;
wire wire_conta_contador_aste_uc_move_asteroides;
wire wire_enable_mem_aste_uc_move_asteroides;

uc_move_asteroides uc_move_asteroides(
    /* inputs */
    .clock(clock),
    .movimenta_aste(wire_sinal_movimenta_asteroides),
    .reset(wire_reset_maquinas),
    .opcode_aste(wire_opcode_aste),
    .loaded_aste(wire_aste_renderizado),
    .rco_contador_aste(wire_rco_contador_asteroides),
     /* outputs */    
    .select_mux_pos_aste(wire_select_mux_pos_aste_uc_move_asteroides),   
    .select_mux_coor_aste(wire_select_mux_coor_aste_uc_move_asteroides),  
    .select_soma_sub(wire_select_soma_sub_uc_move_asteroides),  
    .reset_contador_aste(wire_reset_contador_aste_uc_move_asteroides),
    .conta_contador_aste(wire_conta_contador_aste_uc_move_asteroides), 
    .reset_contador_movimenta_asteroide(wire_reset_contador_movimenta_asteroide),
    .enable_mem_aste(wire_enable_mem_aste_uc_move_asteroides), 
    .movimentacao_concluida_aste(wire_fim_move_asteroides), 
    .db_estado_move_aste(db_estado_move_asteroides)

);

//Outputs
wire wire_enable_mem_tiro_uc_registra_tiro;
wire wire_enable_load_tiro_uc_registra_tiro;
wire wire_new_loaded_tiro_uc_registra_tiro;
wire wire_reset_contador_tiro_uc_registra_tiro;
wire wire_conta_contador_tiro_uc_registra_tiro;
wire [1:0] wire_select_mux_pos_tiro_uc_registra_tiro;
wire wire_tiro_registrado;

/********************************************************************************************************************/
/*********************************************UC_REGISTRA_TIROS******************************************************/
/********************************************************************************************************************/

uc_registra_tiro uc_registra_tiro(
    /* inputs */
    .clock(clock),
    .registra_tiro(wire_inicia_registra_tiros),
    .reset(wire_reset_maquinas),
    .loaded_tiro(wire_tiro_renderizado),
    .rco_contador_tiro(wire_rco_contador_tiro),
    /* outputs */
    .enable_mem_tiro(wire_enable_mem_tiro_uc_registra_tiro), 
    .enable_load_tiro(wire_enable_load_tiro_uc_registra_tiro), 
    .new_load(wire_new_loaded_tiro_uc_registra_tiro),
    .clear_contador_tiro(wire_reset_contador_tiro_uc_registra_tiro), 
    .conta_contador_tiro(wire_conta_contador_tiro_uc_registra_tiro), 
    .select_mux_pos(wire_select_mux_pos_tiro_uc_registra_tiro), 
    .tiro_registrado(wire_tiro_registrado), 
    .db_estado_registra_tiro(db_estado_registra_tiro)

);


/********************************************************************************************************************/
/**************************************************ASTEROIDE ********************************************************/
/********************************************************************************************************************/

wire wire_reset_gerador_random;
wire wire_fim_gera_asteroide;

asteroide asteroide(
    /* inputs */
    .clock(clock),
    .conta_contador_aste(wire_conta_contador_asteroides_uc_compara_tiros_e_asteroides|
                         wire_conta_contador_asteroides_uc_compara_asteroides_com_nave_e_tiros |
                         wire_conta_contador_aste_uc_move_asteroides | 
                         wire_conta_contador_asteroides_uc_gera_frame |
                         wire_conta_contador_asteroides_uc_gera_asteroide ),
    .reset_contador_aste(wire_reset_contador_asteroides_uc_principal | 
                         wire_reset_contador_asteroides_uc_compara_tiros_e_asteroides |
                         wire_reset_contador_asteroides_uc_compara_asteroides_com_nave_e_tiros |
                         wire_reset_contador_aste_uc_move_asteroides |
                         wire_reset_contador_asteroide_uc_gera_frame |
                         wire_reset_contador_asteroides_uc_gera_asteroide ),
    .select_mux_pos_aste(wire_select_mux_pos_aste_uc_move_asteroides),
    .select_mux_coor_aste(wire_select_mux_coor_aste_uc_move_asteroides),
    .select_soma_sub_aste(wire_select_soma_sub_uc_move_asteroides),
    .enable_reg_nave(),
    .reset_reg_nave(),
    .reset_memoria_load(wire_reset_maquinas),
    .enable_mem_aste(wire_enable_mem_aste_uc_move_asteroides | wire_enable_mem_aste_uc_gera_asteroide),
    .enable_load_aste(wire_enable_load_asteroide_uc_compara_tiros_e_asteroides |
                      wire_enable_load_asteroides_uc_compara_asteroides_com_nave_e_tiros |
                      wire_enable_load_aste_uc_gera_asteroide),
    .new_load_aste(wire_new_loaded_aste_uc_gera_asteroide),
    .new_destruido_aste(wire_new_destruido_asteroide_uc_compara_tiros_e_asteroides |
                        wire_new_destruido_asteroide_uc_compara_asteroides_com_nave_e_tiros),
    .reset_gerador_random(wire_reset_gerador_random),
    /* outputs */
    .colisao_aste_com_nave(wire_posicao_asteroide_igual_nave),
    .rco_contador_aste(wire_rco_contador_asteroides),
    .opcode_aste(wire_opcode_aste),
    .destruido_aste(wire_destruido_aste),
    .loaded_aste(wire_aste_renderizado),
    .aste_coor_x(wire_aste_coor_x),
    .aste_coor_y(wire_aste_coor_y),
    .db_contador_aste(),
    .db_wire_saida_som_sub_aste()
);


/********************************************************************************************************************/
/*******************************************************TIRO*********************************************************/
/********************************************************************************************************************/
wire [3:0] wire_tiro_coor_x;
wire [3:0] wire_tiro_coor_y;

tiro tiro (
    /* inputs */
    .clock(clock),
    .conta_contador_tiro(wire_conta_contador_tiros_uc_compara_tiros_e_asteroides |
                         wire_conta_contador_tiro_uc_move_tiros    |
                         wire_conta_contador_tiro_uc_registra_tiro |
                         wire_conta_contador_tiro_uc_gera_frame    |
                         wire_conta_contador_tiro_uc_registra_especial),
    .reset_contador_tiro(wire_reset_contador_tiro_uc_principal                   |
                         wire_reset_contador_tiros_uc_compara_tiros_e_asteroides |
                         wire_reset_contador_tiro_uc_move_tiros    |
                         wire_reset_contador_tiro_uc_registra_tiro |
                         wire_reset_contador_tiro_uc_gera_frame    |
                         wire_reset_contador_tiro_uc_registra_especial),
    .select_mux_pos_tiro(wire_select_mux_pos_tiro_uc_move_tiros    |
                         wire_select_mux_pos_tiro_uc_registra_tiro |
                         wire_select_mux_pos_tiro_uc_registra_especial),
    .reset_memoria_load(wire_reset_maquinas),
    .select_mux_coor_tiro(wire_select_mux_coor_tiro_uc_move_tiros),
    .select_soma_sub_tiro(wire_select_soma_sub_uc_move_tiros),
    .enable_reg_nave(),
    .reset_reg_nave(),
    .enable_mem_tiro(wire_enable_mem_tiro_uc_move_tiros      |
                    wire_enable_mem_tiro_uc_registra_tiro    |
                    wire_enable_mem_tiro_uc_registra_especial),
    .enable_load_tiro(wire_enable_load_tiro_uc_compara_tiros_e_asteroides |
                      wire_enable_load_tiro_uc_move_tiros                 |
                      wire_enable_load_tiro_uc_registra_tiro              |
                      wire_enable_load_tiro_uc_registra_especial),
    .aste_coor_x(wire_aste_coor_x),
    .aste_coor_y(wire_aste_coor_y),
    .new_load_tiro(wire_new_loaded_tiro_uc_registra_tiro | 
                   wire_new_load_uc_registra_especial),
    .opcode_registra_tiro(wire_opcode_registra_tiro),
    /* outputs */
    .x_borda_min_tiro(wire_x_borda_min_tiro),
    .y_borda_min_tiro(wire_y_borda_min_tiro),
    .x_borda_max_tiro(wire_x_borda_max_tiro),
    .y_borda_max_tiro(wire_y_borda_max_tiro),
    .colisao_tiro_asteroide(wire_posicao_tiro_igual_asteroide),
    .rco_contador_tiro(wire_rco_contador_tiro),
    .opcode_tiro(wire_opcode_tiro),
    .loaded_tiro(wire_tiro_renderizado),
    .db_contador_tiro(),
    .db_wire_saida_som_sub_tiro(),
    .db_tiro_pos_x(wire_tiro_coor_x),
    .db_tiro_pos_y(wire_tiro_coor_y)
);


/********************************************************************************************************************/
/****************************************CONTADOR DE PONTUÇÃO E DE PONTOS *******************************************/
/********************************************************************************************************************/

contador_m #(1024, 10) contador_pontuacao (
    /* inputs */
    .clock(clock),
    .zera_as(wire_reset_pontuacao_uc_principal),
    .zera_s(),
    .conta(wire_incrementa_pontos_uc_compara_tiros_e_asteroides),
    /* outputs */
    .Q(wire_pontos_aux),
    .fim(),
    .meio()
  );

decrementador #(4) decrementador_de_vidas( 
    /* inputs */
    .clock(clock), 
    .clr(wire_reset_contador_vidas | reset), 
    .ld(1'b0), 
    .ent(1'b1), 
    .enp(wire_enable_decrementador), 
    .D(4'b0011), 
    /* outputs */
    .Q(wire_quantidade_vidas), 
    .rco(wire_vidas)
);


/********************************************************************************************************************/
/*****************************************DETECTORES DE JOGADAS E TIROS *********************************************/
/********************************************************************************************************************/

wire jogada_up;
wire jogada_down;
wire jogada_right;
wire jogada_left;
wire jogada_especial;
wire jogada_tiro;
wire [5:0] wire_saida_reg_jogada;

edge_detector edge_detector_jogada_up(
    /*inputs*/
    .clock(clock),
    .reset(1'b0),
    .sinal(chaves[5]),
    /*output*/
    .pulso(jogada_up)
);

edge_detector edge_detector_jogada_down(
    /*inputs*/
    .clock(clock),
    .reset(1'b0),
    .sinal(chaves[4]),
    /*output*/
    .pulso(jogada_down)
);

edge_detector edge_detector_jogada_left(
    /*inputs*/
    .clock(clock),
    .reset(1'b0),
    .sinal(chaves[3]),
    /*output*/
    .pulso(jogada_left)
);

edge_detector edge_detector_jogada_right(
    /*inputs*/
    .clock(clock),
    .reset(1'b0),
    .sinal(chaves[2]),
    /*output*/
    .pulso(jogada_right)
);

edge_detector edge_detector_jogada_especial(
    /*inputs*/
    .clock(clock),
    .reset(1'b0),
    .sinal(chaves[1]),
    /*output*/
    .pulso(jogada_especial)
);

edge_detector edge_detector_jogada_tiro(
    /*inputs*/
    .clock(clock),
    .reset(1'b0),
    .sinal(chaves[0]),
    /*output*/
    .pulso(jogada_tiro)
);

registrador_n #(6) reg_jogada (
    /* inputs */
    .clock  (clock),
    .clear  (wire_reset_reg_jogada),
    .enable (wire_enable_reg_jogada),
    .D      (chaves),
    /* output */
    .Q      (wire_saida_reg_jogada)
); 

or (wire_ocorreu_jogada, jogada_up, jogada_down, jogada_right, jogada_left, jogada_especial, jogada_tiro);

edge_detector edge_detector_tiro(
    /*inputs*/
    .clock(clock),
    .reset(1'b0),
    .sinal(wire_saida_reg_jogada[0]),
    /*output*/
    .pulso(wire_ocorreu_tiro)
);

edge_detector edge_detector_especial(
    /*inputs*/
    .clock(clock),
    .reset(1'b0),
    .sinal(wire_saida_reg_jogada[1]),
    /*output*/
    .pulso(wire_ocorreu_especial)
);


/********************************************************************************************************************/
/***********************************************PARTE DE DEPURAÇÃO***************************************************/
/********************************************************************************************************************/

wire [3:0] wire_aste_coor_x_out;
wire [3:0] wire_aste_coor_y_out;
wire [3:0] wire_tiro_coor_x_out;
wire [3:0] wire_tiro_coor_y_out;

registrador_n #(4) tiro_renderizado_x(
    /*inputs*/
    .clock(clock),
    .clear(),
    .enable(wire_tiro_renderizado),
    .D(wire_tiro_coor_x),
    /*output*/
    .Q(wire_tiro_coor_x_out)
);

registrador_n #(4) tiro_renderizado_y(
    /*inputs*/
    .clock(clock),
    .clear(),
    .enable(wire_tiro_renderizado),
    .D(wire_tiro_coor_y),
    /*output*/
    .Q(wire_tiro_coor_y_out)
);

registrador_n #(4) aste_renderizado_x(
    /*inputs*/
    .clock(clock),
    .clear(),
    .enable(wire_aste_renderizado),
    .D(wire_aste_coor_x),
    /*output*/
    .Q(wire_aste_coor_x_out)
);

registrador_n #(4) aste_renderizado_y(
    /*inputs*/
    .clock(clock),
    .clear(),
    .enable(wire_aste_renderizado),
    .D(wire_aste_coor_y),
    /*output*/
    .Q(wire_aste_coor_y_out)
);


/* posicao x do asteroide */
hexa7seg HEX5 (
    .hexa    (wire_aste_coor_x_out),
    .display (db_asteroide_x)
);

/* posicao y do asteroide */
hexa7seg HEX4 (
    .hexa    (wire_aste_coor_y_out),
    .display (db_asteroide_y)
);

/* posicao x do tiro */
hexa7seg HEX3 (
    .hexa    (wire_tiro_coor_x_out),
    .display (db_tiro_x)
);

/* posicao y do tiro */
hexa7seg HEX2 (
    .hexa    (wire_tiro_coor_y_out),
    .display (db_tiro_y)
);

wire [3:0] wire_quantidade_vidas;
/* display para as vidas */
hexa7seg HEX1 (
    .hexa    (wire_quantidade_vidas),
    .display (db_vidas)
);

/* display pra pontuacao */
wire [9:0] wire_pontos_aux;
hexa7seg HEX0 (
    .hexa    (wire_pontos_aux[3:0]),
    .display (db_pontos)
);
endmodule
