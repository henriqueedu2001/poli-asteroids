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
    output [3:0] db_vidas,
    output [3:0] db_pontos,
    output [3:0] db_tiro_x,
    output [3:0] db_tiro_y,
    output [3:0] db_asteroide_x,
    output [3:0] db_asteroide_y,
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

//wires da conexão da UC principal com outros modulos
wire wire_vidas;
wire wire_fim_movimentacao_asteroides_e_tiros;
wire wire_inicia_registra_tiros;
wire wire_inicia_movimentacao_asteroides_e_tiros;
wire wire_reset_maquinas;
wire wire_reset_contador_asteroides_uc_principal;
wire wire_reset_contador_tiro_uc_principal; //sintaxe: o final indica de onde está saindo o fio
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
// adicionados 
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
    .vidas(~wire_vidas), //rco do decrementador
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
// assign wire_opcode_especial = wire_select_mux_especial_opcode ? wire_opcode_contador_especial : ;


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


wire [1:0] wire_opcode_registra_tiro;
// mux para o seletor do opcode para registrar o tiro
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





// wires genericos 
wire wire_rco_contador_tiro;
wire wire_rco_contador_asteroides;

// wires da conexão da uc_coordena_asteroides_tiros com outros modulos
// INPUT
wire wire_fim_move_tiros;
wire wire_fim_move_asteroides;
wire wire_fim_comparacao_asteroides_com_a_nave_e_tiros;
wire wire_fim_comparacao_tiros_e_asteroides;

// OUTPUT
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
    /* input */
    .clock(clock)        ,
    .reset(wire_reset_maquinas),
    .gera_asteroide(wire_gera_asteroide),      
    .rco_contador_asteroide(wire_rco_contador_asteroides),
    .asteroide_renderizado(wire_aste_renderizado),

    /* output */
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
        /*input*/
        .clock(clock),
        .reset(reset_maquinas),
        .gera_frame(wire_inicia_gera_frame_uc_coordena_asteroides_tiros),
        .rco_contador_asteroides(wire_rco_contador_asteroides),
        .rco_contador_tiro(wire_rco_contador_tiro),
        .loaded_tiro(wire_tiro_renderizado),
        .loaded_asteroide(wire_aste_renderizado),
        /*output*/
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

// assign wire_entrada_x_memoria_frame = wire_tiro_coor_x;
 
// assign wire_entrada_y_memoria_frame = wire_tiro_coor_y;

memoria_frame memoria_frame(
            // input
            .coor_x(wire_entrada_y_memoria_frame),
            .coor_y(wire_entrada_x_memoria_frame),
            .clk   (clock),
            .clear(wire_clear_mem_frame),
            .we   (wire_enable_mem_frame),
            // output
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
        .clock(clock),
        .reset(wire_reset_maquinas),
        .pausar_renderizacao(wire_pausar_renderizacao),
        .rco_contador_frame(wire_rco_contador_frame),

        .reset_contador_frame(wire_reset_contador_frame),
        .conta_contador_frame(wire_conta_contador_frame),
        .db_estado_uc_renderiza(db_estado_uc_renderiza)
);

 contador_m #(15, 4) contador_renderiza(
   .clock(clock),
   .zera_as(wire_reset_contador_frame),
   .zera_s(1'b0),
   .conta(wire_conta_contador_frame),
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
    .clock(clock),
    .reset(1'b0),
    .sinal(chaves[5]),
    .pulso(jogada_up)
);

edge_detector edge_detector_jogada_down(
    .clock(clock),
    .reset(1'b0),
    .sinal(chaves[4]),
    .pulso(jogada_down)
);

edge_detector edge_detector_jogada_left(
    .clock(clock),
    .reset(1'b0),
    .sinal(chaves[3]),
    .pulso(jogada_left)
);

edge_detector edge_detector_jogada_right(
    .clock(clock),
    .reset(1'b0),
    .sinal(chaves[2]),
    .pulso(jogada_right)
);

edge_detector edge_detector_jogada_especial(
    .clock(clock),
    .reset(1'b0),
    .sinal(chaves[1]),
    .pulso(jogada_especial)
);

edge_detector edge_detector_jogada_tiro(
    .clock(clock),
    .reset(1'b0),
    .sinal(chaves[0]),
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
    .clock(clock),
    .reset(1'b0),
    .sinal(wire_saida_reg_jogada[0]),
    .pulso(wire_ocorreu_tiro)
);

edge_detector edge_detector_especial(
    .clock(clock),
    .reset(1'b0),
    .sinal(wire_saida_reg_jogada[1]),
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
    .clock(clock),
    .clear(),
    .enable(wire_tiro_renderizado),
    .D(wire_tiro_coor_x),
    .Q(wire_tiro_coor_x_out)
);

registrador_n #(4) tiro_renderizado_y(
    .clock(clock),
    .clear(),
    .enable(wire_tiro_renderizado),
    .D(wire_tiro_coor_y),
    .Q(wire_tiro_coor_y_out)
);

registrador_n #(4) aste_renderizado_x(
    .clock(clock),
    .clear(),
    .enable(wire_aste_renderizado),
    .D(wire_aste_coor_x),
    .Q(wire_aste_coor_x_out)
);

registrador_n #(4) aste_renderizado_y(
    .clock(clock),
    .clear(),
    .enable(wire_aste_renderizado),
    .D(wire_aste_coor_y),
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
    input reset_memoria_load,
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
    output [4:0] db_wire_saida_som_sub_tiro,
    output [3:0] db_tiro_pos_x,
    output [3:0] db_tiro_pos_y
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

    assign db_tiro_pos_x = wire_saida_memoria_tiro[9:6];
    assign db_tiro_pos_y = wire_saida_memoria_tiro[5:2];

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
    .select_mux_pos  (select_mux_pos_tiro),
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
    .clear(reset_memoria_load),
    .data ({new_load_tiro, 1'b0}),
    .addr (wire_saida_contador),
    /* output */
    .q    (memoria_loaded) 
);


endmodule

module comparador_85 #(parameter N = 4)(
                input [N-1:0] A, 
                input [N-1:0] B,
                input       ALBi, 
                input       AGBi, 
                input       AEBi,  
                output      ALBo, 
                output      AGBo, 
                output      AEBo
                );

    wire[N:0]  CSL, CSG;

    assign CSL  = ~A + B + ALBi;
    assign ALBo = ~CSL[N];
    assign CSG  = A + ~B + AGBi;
    assign AGBo = ~CSG[N];
    assign AEBo = ((A == B) && AEBi);

endmodule 

module contador_163 #(parameter N = 16) ( 
                        input clock, 
                        input clr, 
                        input ld, 
                        input ent, 
                        input enp, 
                        input [N-1:0] D,
                        input [N-1:0] Max,
                        output reg [N-1:0] Q, 
                        output reg rco
                    );

    initial begin
        Q = 0;
    end
        
    always @ (posedge clock)
        if (clr)               Q <= 0;
        else if (ld)           Q <= D;
        else if (ent && enp && Q <= Max)   Q <= Q + 1;
        else                   Q <= Q;

    always @ (Q or ent)
        if (ent && (Q >= Max))     rco = 1;
        else                       rco = 0;
endmodule

module contador_m #(parameter M=16, N=4)
  (
   input  wire          clock,
   input  wire          zera_as,
   input  wire          zera_s,
   input  wire          conta,
   output reg  [N-1:0]  Q,
   output reg           fim,
   output reg           meio
  );

  always @(posedge clock or posedge zera_as) begin
    if (zera_as) begin
      Q <= 0;
    end else if (clock) begin
      if (zera_s) begin
        Q <= 0;
      end else if (conta) begin
        if (Q == M-1) begin
          Q <= 0;
        end else begin
          Q <= Q + 1;
        end
      end
    end
  end

  // Saidas
  always @ (Q)
      if (Q == M-1)   fim = 1;
      else            fim = 0;

  always @ (Q)
      if (Q == M/2-1) meio = 1;
      else            meio = 0;

endmodule


// modulo que decrementa em 1 a cada boda de subida caso ent, enp sejam HIGH

module decrementador #(parameter N=4) ( 
                      input clock       , 
                      input clr         , 
                      input ld          , 
                      input ent         , 
                      input enp         , 
                      input [N-1:0] D     , 
                      output reg [N-1:0] Q , 
                      output reg rco
                    );

	 initial begin
		Q = 3;
    end
    

    always @ (posedge clock)
        if (clr)                           Q <= 3;
        else if (ld)                       Q <= D;
        else if (ent && enp &&  Q != 0)    Q <= Q - 1;
        else                               Q <= Q;
 
    always @ (Q or ent)
        if (ent && (Q == 0))       rco = 1;
        else                       rco = 0;

endmodule


 module edge_detector (
    input  clock,
    input  reset,
    input  sinal,
    output pulso
);

    reg reg0;
    reg reg1;

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            reg0 <= 1'b0;
            reg1 <= 1'b0;
        end else if (clock) begin
            reg0 <= sinal;
            reg1 <= reg0;
        end
    end

    assign pulso = ~reg1 & reg0;

endmodule


module memoria_aste(
    input        clk,
    input        we,
    input  [9:0] data,
    input  [3:0] addr,
    output [9:0] q
);

    // Variavel RAM (armazena dados)
    reg [9:0] ram[15:0];

    // Registra endereco de acesso
    reg [3:0] addr_reg;

    // Especifica conteudo inicial da RAM
    // a partir da leitura de arquivo usando $readmemb
    initial begin
        ram[4'b0]  =  10'b0111_1110_11; // (7,14)
        ram[4'd1]  =  10'b0000_0000_00; // (7,14)
        ram[4'd2]  =  10'b0000_0000_00; // (7,14)
        ram[4'd3]  =  10'b0000_0000_00; // (0,7)
        ram[4'd4]  =  10'b0000_0000_00; // (7,0)
        ram[4'd5]  =  10'b0000_0000_00; // (14,7)
        ram[4'd6]  =  10'b0000_0000_00; // (7,14)
        ram[4'd7]  =  10'b0000_0000_00; // (14,7)
        ram[4'd8]  =  10'b0000_0000_00; // (7,14)
        ram[4'd9]  =  10'b0000_0000_00; // (7,7)
        ram[4'd10] =  10'b0000_0000_00; // (7,0)
        ram[4'd11] =  10'b0000_0000_00; // (7,0)
        ram[4'd12] =  10'b0000_0000_00; // (0,7)
        ram[4'd13] =  10'b0000_0000_00; // (0,7)
        ram[4'd14] =  10'b0000_0000_00; // (7,14)
        ram[4'd15] =  10'b0000_0000_00; // (7,14)

        // ram[4'b0]  =  10'b0111_1110_11; // (7,14)
        // ram[4'd1]  =  10'b0111_0000_10; // (7,14)
        // ram[4'd2]  =  10'b0111_1110_11; // (7,14)
        // ram[4'd3]  =  10'b0000_0111_00; // (0,7)
        // ram[4'd4]  =  10'b0111_0000_00; // (7,0)
        // ram[4'd5]  =  10'b1110_0111_01; // (14,7)
        // ram[4'd6]  =  10'b0111_1110_11; // (7,14)
        // ram[4'd7]  =  10'b1110_0111_01; // (14,7)
        // ram[4'd8]  =  10'b0111_1110_11; // (7,14)
        // ram[4'd9]  =  10'b0111_0111_00; // (7,7)
        // ram[4'd10] =  10'b0111_0000_10; // (7,0)
        // ram[4'd11] =  10'b0111_0000_10; // (7,0)
        // ram[4'd12] =  10'b0000_0111_00; // (0,7)
        // ram[4'd13] =  10'b0000_0111_00; // (0,7)
        // ram[4'd14] =  10'b0111_1110_11; // (7,14)
        // ram[4'd15] =  10'b0111_1110_11; // (7,14)
    end 

    always @ (posedge clk)
    begin
        // Escrita da memoria
        if (we)
            ram[addr] <= data;

        addr_reg <= addr;
    end

    // Atribuicao continua retorna dado
    assign q = ram[addr_reg];

endmodule

module memoria_load_aste(
    input        clk,
    input        we,
    input        clear,
    input  [1:0] data,
    input  [3:0] addr,
    output [1:0] q
);
    integer i;
    // Variavel RAM (armazena dados)
    reg [1:0] ram[15:0];

    // Registra endereco de acesso
    reg [3:0] addr_reg;

    // Especifica conteudo inicial da RAM
    // a partir da leitura de arquivo usando $readmemb
    initial 
    begin : INICIA_RAM
        ram[4'b0] =  2'b00;
        ram[4'd1] =  2'b00;
        ram[4'd2] =  2'b00;
        ram[4'd3] =  2'b00;
        ram[4'd4] =  2'b00; 
        ram[4'd5] =  2'b00;
        ram[4'd6] =  2'b00;
        ram[4'd7] =  2'b00;
        ram[4'd8] =  2'b00;
        ram[4'd9] =  2'b00;
        ram[4'd10] = 2'b00;
        ram[4'd11] = 2'b00;
        ram[4'd12] = 2'b00;
        ram[4'd13] = 2'b00;
        ram[4'd14] = 2'b00;
        ram[4'd15] = 2'b00;
    end 

    always @ (posedge clk)
    begin
        // Escrita da memoria
        if (we && ~clear)
            ram[addr] <= data;
        
        if (clear) begin
            for (i = 0; i < 16; i = i + 1) begin
                ram[i] = 2'b00;
            end
        end

        addr_reg <= addr;
    end

    // Atribuicao continua retorna dado
    assign q = ram[addr_reg];

endmodule

module memoria_tiro(
    input        clk,
    input        we,
    input  [9:0] data,
    input  [3:0] addr,
    output [9:0] q
);

    // Variavel RAM (armazena dados)
    reg [9:0] ram[15:0];

    // Registra endereco de acesso
    reg [3:0] addr_reg;

    // Especifica conteudo inicial da RAM
    // a partir da leitura de arquivo usando $readmemb
    initial begin
        ram[4'b0] =  10'b0000_0000_00;
        ram[4'd1] =  10'b0000_0000_00;
        ram[4'd2] =  10'b0000_0000_00;
        ram[4'd3] =  10'b0000_0000_00;
        ram[4'd4] =  10'b0000_0000_00;
        ram[4'd5] =  10'b0000_0000_00;
        ram[4'd6] =  10'b0000_0000_00;
        ram[4'd7] =  10'b0000_0000_00;
        ram[4'd8] =  10'b0000_0000_00;
        ram[4'd9] =  10'b0000_0000_00;
        ram[4'd10] = 10'b0000_0000_00;
        ram[4'd11] = 10'b0000_0000_00;
        ram[4'd12] = 10'b0000_0000_00;
        ram[4'd13] = 10'b0000_0000_00;
        ram[4'd14] = 10'b0000_0000_00;
        ram[4'd15] = 10'b0000_0000_00;
    end 

    always @ (posedge clk)
    begin
        // Escrita da memoria
        if (we)
            ram[addr] <= data;

        addr_reg <= addr;
    end

    // Atribuicao continua retorna dado
    assign q = ram[addr_reg];

endmodule

module memoria_load_tiro(
    input        clk,
    input        we,
    input        clear,
    input  [1:0] data,
    input  [3:0] addr,
    output [1:0] q
);
    integer i;
    // Variavel RAM (armazena dados)
    reg [1:0] ram[15:0];

    // Registra endereco de acesso
    reg [3:0] addr_reg;

    // Especifica conteudo inicial da RAM
    // a partir da leitura de arquivo usando $readmemb
    initial 
    begin : INICIA_RAM
        ram[4'b0] =  2'b00;
        ram[4'd1] =  2'b00;
        ram[4'd2] =  2'b00;
        ram[4'd3] =  2'b00;
        ram[4'd4] =  2'b00; 
        ram[4'd5] =  2'b00;
        ram[4'd6] =  2'b00;
        ram[4'd7] =  2'b00;
        ram[4'd8] =  2'b00;
        ram[4'd9] =  2'b00;
        ram[4'd10] = 2'b00;
        ram[4'd11] = 2'b00;
        ram[4'd12] = 2'b00;
        ram[4'd13] = 2'b00;
        ram[4'd14] = 2'b00;
        ram[4'd15] = 2'b00;
    end 

    always @ (posedge clk)
    begin
        // Escrita da memoria
        if (we && ~clear)
            ram[addr] <= data;
        
        if (clear) begin
            for(i = 0; i < 16; i = i + 1) begin
                ram[i] = 2'b00;
            end
        end
        
        addr_reg <= addr;
    end

    // Atribuicao continua retorna dado
    assign q = ram[addr_reg];

endmodule

module memoria_frame (
            input [3:0] coor_x,
            input [3:0] coor_y,
            input clk,
            input clear,
            input we,
            output [14:0] saida_x,
            output [3:0] saida_y
            );

    // wire coor_x;
    // wire coor_y;
    // reg [numero de bits em cada linha] mem [numero de linhas] 
    reg [14:0] mem [15:0];
    reg [14:0] addreg;
    integer i = 0;

    initial begin
        for (i = 0; i < 15; i = i + 1) begin
            mem[i] = 15'd0;
        end


    end

    always @(posedge clk) begin
        if(we && ~clear) begin
            mem[coor_y][4'd15 - coor_x] <= 1'b1;
        end
        if(clear) begin
            for (i = 0; i < 15; i = i + 1) begin
                mem[i] <= 15'd0;
            end 
        end
    end

    assign saida_x = mem[coor_y];
    assign saida_y = coor_y;


endmodule



module rom_aste (
    input        clk,
    input  [3:0] addr,
    output [9:0] q
);

    // Variavel RAM (armazena dados)
    reg [9:0] ram [15:0];

    // Registra endereco de acesso
    reg [3:0] addr_reg;
    // Especifica conteudo inicial da RAM
    // a partir da leitura de arquivo usando $readmemb
    initial begin
        ram[4'd0]  =  10'b0000_0111_00; // (0, 7) -> horizontal crescente
        ram[4'd1]  =  10'b1110_0111_01; // (14,7) -> horizontal decrescente
        ram[4'd2]  =  10'b0111_0000_10; // (7, 0) -> vertical crescente
        ram[4'd3]  =  10'b0111_1110_11; // (7,14) -> vertical decrescente
        
        ram[4'd4]  =  10'b0000_0111_00; // (0, 7) -> horizontal crescente
        ram[4'd5]  =  10'b1110_0111_01; // (14,7) -> horizontal decrescente
        ram[4'd6]  =  10'b0111_0000_10; // (7, 0) -> vertical crescente
        ram[4'd7]  =  10'b0111_1110_11; // (7,14) -> vertical decrescente

        ram[4'd8]  =  10'b0000_0111_00; // (0, 7) -> horizontal crescente
        ram[4'd9]  =  10'b1110_0111_01; // (14,7) -> horizontal decrescente
        ram[4'd10]  =  10'b0111_0000_10; // (7, 0) -> vertical crescente
        ram[4'd11]  =  10'b0111_1110_11; // (7,14) -> vertical decrescente

        ram[4'd12]  =  10'b0000_0111_00; // (0, 7) -> horizontal crescente
        ram[4'd13]  =  10'b1110_0111_01; // (14,7) -> horizontal decrescente
        ram[4'd14]  =  10'b0111_0000_10; // (7, 0) -> vertical crescente
        ram[4'd15]  =  10'b0111_1110_11; // (7,14) -> vertical decrescente
    end 

    always @ (posedge clk)
    begin
        addr_reg <= addr;
    end

    // Atribuicao continua retorna dado
    assign q = ram[addr_reg];

endmodule

module mux_coor #(parameter N = 4)(
        input select_mux_coor,
        input [N-1:0] mem_coor_x,
        input [N-1:0] mem_coor_y,
        output [N-1:0] saida_mux
        );

        parameter select_mem_coor_x = 1'b0;

        assign saida_mux = select_mux_coor == select_mem_coor_x ? mem_coor_x : mem_coor_y;
endmodule






module mux_pos #(parameter N = 4)(
        input [1:0] select_mux_pos,
        input [N-1:0] resul_soma,
        input [N-1:0] mem_coor_x,
        input [N-1:0] mem_coor_y,
        input [1:0]   mem_opcode,
        input [N-1:0] random_x,
        input [N-1:0] random_y,
        input [1:0] random_opcode,
        output [9:0] saida_mux
);

        parameter posicao_op_random = 2'b00;
        parameter resul_soma_coor_x = 2'b01;
        parameter resul_soma_coor_y = 2'b10;

        // 00 - seleciona a posição e opcode randomicos
        // 01 - seleciona o resultado da soma na coordenada X e opcode da memoria (Y da memoria)
        // 10 - seleciona o resultado da soma na coordenada Y e opcode da memoria (X da memoria)

        assign saida_mux = select_mux_pos == posicao_op_random ? {random_x, random_y, random_opcode}  :
                           select_mux_pos == resul_soma_coor_x ? {resul_soma, mem_coor_y, mem_opcode} :
                           select_mux_pos == resul_soma_coor_y ? {mem_coor_x, resul_soma, mem_opcode} : {mem_coor_x, mem_coor_y, mem_opcode};
endmodule

module mux_reg_jogada (
        input [3:0] select_mux_jogada,
        output [1:0] saida_mux
        );

        assign saida_mux = select_mux_jogada == 4'b0001 ? 2'b00 : 
                           select_mux_jogada == 4'b1000 ? 2'b10 :
                           select_mux_jogada == 4'b0010 ? 2'b01 : 2'b11;
endmodule






//registrador_n #(N = 5)(

// )
module registrador_n #(parameter N = 4)(
    input        clock ,
    input        clear ,
    input        enable,
    input  [N-1:0] D     ,
    output [N-1:0] Q
);

    reg [N-1:0] IQ;

    always @(posedge clock or posedge clear) begin
        if (clear)
            IQ <= 0;
        else if (enable)
            IQ <= D;
    end

    assign Q = IQ;

endmodule

// modulo que implementa o somador/subtrator, caso select seja um então ocorre a soma
// caso seja 0 então ocorre a subtração

module somador_subtrator #(parameter N=4) ( 
                          input [N-1:0] a,
                          input [N-1:0] b,
                          input select,
                          output [N:0] resul
                    );

  reg [N:0] res;

  always@(*) begin
    if(~select) res = a + b;
    else res = a-b;
  end

  assign resul = res;


  // assign resul = select ? a + b : a - b;

endmodule

module random (
    input clock,
    input reset,
    output [3:0] rnd 
);

    wire feedback = random[12] ^ random[3] ^ random[2] ^ random[0]; 

    reg [12:0] random, random_next;
    reg [12:0] count, count_next; // Declare count and count_next as 13-bit registers

    initial begin
        random = 13'hF; // An LFSR cannot have an all 0 state, thus reset to FF
        count = 0;
    end

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            random <= 13'hF;
            count <= 0;
        end else begin
            random <= random_next;
            count <= count_next;
        end
    end

    always @(*) begin
        random_next = random; // Default state stays the same
        count_next = count;

        random_next = {random[11:0], feedback}; // Shift left the XOR'd every posedge clock
        count_next = (count == 13) ? 0 : count + 1; // Increment count only if it's not already 13

        if (count == 13) begin
            random_next = {random[11:0], feedback}; // Assign the random number to output after 13 shifts
        end
    end

    assign rnd = random[12:9]; // Output the most significant 4 bits of random

endmodule


module hexa7seg (hexa, display);
    input      [3:0] hexa;
    output reg [3:0] display;

    /*
     *    ---
     *   | 0 |
     * 5 |   | 1
     *   |   |
     *    ---
     *   | 6 |
     * 4 |   | 2
     *   |   |
     *    ---
     *     3
     */
        
    always @(hexa)
    case (hexa)
        4'h0:    display = 4'h0;
        4'h1:    display = 4'h1;
        4'h2:    display = 4'h2;
        4'h3:    display = 4'h3;
        4'h4:    display = 4'h4;
        4'h5:    display = 4'h5;
        4'h6:    display = 4'h6;
        4'h7:    display = 4'h7;
        4'h8:    display = 4'h8;
        4'h9:    display = 4'h9;
        4'ha:    display = 4'ha;
        4'hb:    display = 4'hb;
        4'hc:    display = 4'hc;
        4'hd:    display = 4'hd;
        4'he:    display = 4'he;
        4'hf:    display = 4'hf;
        default: display = 4'h0;
    endcase
endmodule

module uc_compara_asteroides_com_nave_e_tiros (
        input clock,
        input reset,
        input iniciar_comparacao_tiros_nave_asteroides,
        input posicao_asteroide_igual_nave,
        input ha_vidas,
        input rco_contador_asteroides,
        input fim_compara_tiros_e_asteroides,

        input loaded_asteroide,
        input destruido_asteroide,

        output reg enable_decrementador,
        output reg new_loaded_asteroide,
        output reg new_destruido_asteroide,
        output reg fim_compara_asteroides_com_tiros_e_nave,
        output reg enable_load_asteroide,
        output reg conta_contador_asteroides,
        output reg sinal_compara_tiros_e_asteroide,
        output reg reset_contador_asteroides,

        output reg [4:0] db_estado_compara_asteroides_com_nave_e_tiros
);

    parameter inicio                             = 5'b00000; // 0
    parameter espera                             = 5'b00001; // 1
    parameter reset_contador                     = 5'b00010; // 2
    parameter compara                            = 5'b00011; // 3
    parameter decrementa_vida                    = 5'b00100; // 4
    parameter destroi_asteroide                  = 5'b00101; // 5
    parameter salva_destruicao                   = 5'b00110; // 6
    parameter compara_tiros_e_asteroides         = 5'b00111; // 7
    parameter espera_compara_tiros_e_asteroides  = 5'b01000; // 8
    parameter incrementa_contador_de_asteroides  = 5'b01001; // 9
    parameter fim_comparacao                     = 5'b01010; // 10
    parameter aux                                = 5'b01011; // 11
    parameter erro                               = 5'b01111; // F


    // Variáveis de estado
    reg [4:0] estado_atual, proximo_estado;

    // Memória de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            estado_atual <= inicio;
        else
            estado_atual <= proximo_estado;
    end


    // Lógica de transição de estados
    always @* begin
        case (estado_atual)
            inicio:                              proximo_estado = espera;
            espera:                              proximo_estado = iniciar_comparacao_tiros_nave_asteroides ? reset_contador : espera;
            reset_contador:                      proximo_estado = compara;

            compara:                             proximo_estado = (posicao_asteroide_igual_nave && loaded_asteroide && ~destruido_asteroide) ? decrementa_vida : 
                                                                  rco_contador_asteroides ? compara_tiros_e_asteroides : incrementa_contador_de_asteroides;
            
            decrementa_vida:                     proximo_estado = ha_vidas ? destroi_asteroide : fim_comparacao;
            destroi_asteroide:                   proximo_estado = salva_destruicao;
            salva_destruicao:                    proximo_estado = rco_contador_asteroides ? compara_tiros_e_asteroides : incrementa_contador_de_asteroides;
            compara_tiros_e_asteroides:          proximo_estado = espera_compara_tiros_e_asteroides;
            espera_compara_tiros_e_asteroides:   proximo_estado = fim_compara_tiros_e_asteroides ? fim_comparacao : espera_compara_tiros_e_asteroides;
            incrementa_contador_de_asteroides:   proximo_estado = aux;
            aux:                                 proximo_estado = compara;
            fim_comparacao:                      proximo_estado = espera;
            default:                             proximo_estado = inicio;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin

        reset_contador_asteroides = (estado_atual == reset_contador)         ? 1'b1 : 1'b0;
        enable_decrementador      = (estado_atual == decrementa_vida)        ? 1'b1 : 1'b0;
        new_loaded_asteroide      = (estado_atual == destroi_asteroide ||
                                     estado_atual == salva_destruicao)       ? 1'b0 : 1'b1;
        new_destruido_asteroide   = (estado_atual == destroi_asteroide ||
                                     estado_atual == salva_destruicao)       ? 1'b1 : 1'b0;
        enable_load_asteroide      = (estado_atual == salva_destruicao)       ? 1'b1 : 1'b0;
        fim_compara_asteroides_com_tiros_e_nave = (estado_atual == fim_comparacao)                        ? 1'b1 : 1'b0;
        conta_contador_asteroides               = (estado_atual == incrementa_contador_de_asteroides)     ? 1'b1 : 1'b0;
        sinal_compara_tiros_e_asteroide         = (estado_atual == compara_tiros_e_asteroides)            ? 1'b1 : 1'b0;

        // Saída de depuração (estado)
        case (estado_atual)
            inicio:                             db_estado_compara_asteroides_com_nave_e_tiros = 5'b00000; // 0
            espera:                             db_estado_compara_asteroides_com_nave_e_tiros = 5'b00001; // 1
            reset_contador:                     db_estado_compara_asteroides_com_nave_e_tiros = 5'b00010; // 2
            compara:                            db_estado_compara_asteroides_com_nave_e_tiros = 5'b00011; // 3
            decrementa_vida:                    db_estado_compara_asteroides_com_nave_e_tiros = 5'b00100; // 4
            destroi_asteroide:                  db_estado_compara_asteroides_com_nave_e_tiros = 5'b00101; // 5
            salva_destruicao:                   db_estado_compara_asteroides_com_nave_e_tiros = 5'b00110; // 6
            compara_tiros_e_asteroides:         db_estado_compara_asteroides_com_nave_e_tiros = 5'b00111; // 7
            espera_compara_tiros_e_asteroides:  db_estado_compara_asteroides_com_nave_e_tiros = 5'b01000; // 8
            incrementa_contador_de_asteroides:  db_estado_compara_asteroides_com_nave_e_tiros = 5'b01001; // 9
            fim_comparacao:                     db_estado_compara_asteroides_com_nave_e_tiros = 5'b01010; // 10
            aux:                                db_estado_compara_asteroides_com_nave_e_tiros = 5'b01011; // 11
            erro:                               db_estado_compara_asteroides_com_nave_e_tiros = 5'b01111; // F  
            default:                            db_estado_compara_asteroides_com_nave_e_tiros = 5'b00000; 

        endcase
    end
endmodule



module uc_compara_tiros_e_asteroides (
        input clock,
        input reset,
        input compara_tiros_e_asteroides,
        input posicao_tiro_igual_asteroide,
        input rco_contador_asteroides,
        input rco_contador_tiros,
        input tiro_renderizado,
        input aste_renderizado,

        output reg reset_contador_asteroides,
        output reg reset_contador_tiros,
        output reg enable_load_tiro,
        output reg enable_load_asteroide,
        output reg loaded_tiro,
        output reg loaded_asteroide,
        output reg asteroide_destruido,
        output reg conta_contador_asteroides,
        output reg conta_contador_tiros,
        output reg incrementa_pontos,
        output reg s_fim_comparacao,
        output reg [4:0] db_estado_compara_tiros_e_asteroide
);

    parameter inicio                = 5'b00000; // 0
    parameter espera                = 5'b00001; // 1
    parameter reseta_contador       = 5'b00010; // 2
    parameter verifica_renderizado  = 5'b00011; // 3
    parameter compara               = 5'b00100; // 4
    parameter destroi_asteroide     = 5'b00101; // 5
    parameter salva_destruicao      = 5'b00110; // 6
    parameter incrementa_asteroides = 5'b00111; // 7
    parameter incrementa_tiros      = 5'b01000; // 8
    parameter fim_comparacao        = 5'b01001; // 9
    parameter auxiliar_tiro         = 5'b01010; // 10
    parameter auxiliar_aste         = 5'b01011; // 11
    parameter erro                  = 5'b01111; // F


    // Variáveis de estado
    reg [4:0] estado_atual, proximo_estado;

    // Memória de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            estado_atual <= inicio;
        else
            estado_atual <= proximo_estado;
    end


    // Lógica de transição de estados
    always @* begin
        case (estado_atual)
            inicio:                proximo_estado = espera;
            espera:                proximo_estado = compara_tiros_e_asteroides ? reseta_contador : espera;
            reseta_contador:       proximo_estado = verifica_renderizado;
            verifica_renderizado:  proximo_estado = (tiro_renderizado && aste_renderizado) ? compara : 
                                                    (~rco_contador_asteroides && ~aste_renderizado) ? incrementa_asteroides :
                                                    (~tiro_renderizado && ~rco_contador_tiros) ? incrementa_tiros : 
                                                    (rco_contador_asteroides && rco_contador_tiros) ? fim_comparacao : 
                                                    (rco_contador_asteroides && ~rco_contador_tiros) ?  incrementa_tiros : incrementa_asteroides; //adicionar no diagrama
            compara:               proximo_estado = posicao_tiro_igual_asteroide? destroi_asteroide : 
                                                    (~posicao_tiro_igual_asteroide && ~rco_contador_asteroides) ? incrementa_asteroides :
                                                    (~posicao_tiro_igual_asteroide && rco_contador_asteroides && ~rco_contador_tiros) ? incrementa_tiros : 
                                                    (~posicao_tiro_igual_asteroide && rco_contador_asteroides && rco_contador_tiros) ? fim_comparacao : erro;
            destroi_asteroide:     proximo_estado = salva_destruicao;
            salva_destruicao:      proximo_estado = ~rco_contador_asteroides ? incrementa_asteroides :
                                                    (rco_contador_asteroides && ~rco_contador_tiros) ? incrementa_tiros :
                                                    (rco_contador_asteroides && rco_contador_tiros) ? fim_comparacao : erro;
            fim_comparacao:        proximo_estado = espera;
            incrementa_asteroides: proximo_estado = auxiliar_aste;
            auxiliar_aste:         proximo_estado = verifica_renderizado;
            incrementa_tiros:      proximo_estado = auxiliar_tiro;
            auxiliar_tiro:         proximo_estado = verifica_renderizado;
            default:               proximo_estado = inicio;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin
        reset_contador_asteroides    =   (estado_atual == reseta_contador ||
                                          estado_atual == incrementa_tiros)      ? 1'b1 : 1'b0;
        reset_contador_tiros         =   (estado_atual == reseta_contador)       ? 1'b1 : 1'b0;
        enable_load_tiro             =   (estado_atual == salva_destruicao)      ? 1'b1 : 1'b0;
        enable_load_asteroide        =   (estado_atual == salva_destruicao)      ? 1'b1 : 1'b0;
        loaded_tiro                  =   (estado_atual == destroi_asteroide ||
                                          estado_atual == salva_destruicao  )    ? 1'b0 : 1'b1;
        loaded_asteroide             =   (estado_atual == destroi_asteroide ||
                                          estado_atual == salva_destruicao  )    ? 1'b0 : 1'b1;
        asteroide_destruido          =   (estado_atual == destroi_asteroide ||
                                          estado_atual == salva_destruicao  )    ? 1'b1 : 1'b0;
        incrementa_pontos            =   (estado_atual == destroi_asteroide)     ? 1'b1 : 1'b0;
        conta_contador_asteroides    =   (estado_atual == incrementa_asteroides) ? 1'b1 : 1'b0;
        conta_contador_tiros         =   (estado_atual == incrementa_tiros)      ? 1'b1 : 1'b0;
        s_fim_comparacao             =   (estado_atual == fim_comparacao)        ? 1'b1 : 1'b0;


        // Saída de depuração (estado)
        case (estado_atual)
            inicio:                db_estado_compara_tiros_e_asteroide = 5'b00000; // 0
            espera:                db_estado_compara_tiros_e_asteroide = 5'b00001; // 1
            reseta_contador:       db_estado_compara_tiros_e_asteroide = 5'b00010; // 2
            verifica_renderizado:  db_estado_compara_tiros_e_asteroide = 5'b00011; // 3
            compara:               db_estado_compara_tiros_e_asteroide = 5'b00100; // 4
            destroi_asteroide:     db_estado_compara_tiros_e_asteroide = 5'b00101; // 5
            salva_destruicao:      db_estado_compara_tiros_e_asteroide = 5'b00110; // 6
            incrementa_asteroides: db_estado_compara_tiros_e_asteroide = 5'b00111; // 7
            incrementa_tiros:      db_estado_compara_tiros_e_asteroide = 5'b01000; // 8
            fim_comparacao:        db_estado_compara_tiros_e_asteroide = 5'b01001; // 9
            auxiliar_tiro:         db_estado_compara_tiros_e_asteroide = 5'b01010; // 10
            auxiliar_aste:         db_estado_compara_tiros_e_asteroide = 5'b01011; // 11
            erro:                  db_estado_compara_tiros_e_asteroide = 5'b01111; // F  
            default:               db_estado_compara_tiros_e_asteroide = 5'b00000; 
        endcase
    end
endmodule



module uc_coordena_asteroides_tiros (
    /*input*/
    input clock,
    input reset,
    input move_tiro_e_asteroides, 
    input rco_contador_movimenta_asteroides,
    input rco_contador_movimenta_tiros,
    input fim_move_tiros, 
    input fim_move_asteroides,
    input fim_comparacao_asteroides_com_a_nave_e_tiros, 
    input fim_comparacao_tiros_e_asteroides,

    input fim_gera_frame,
    input fim_gera_asteroide,
    input gera_aste,
    input termina_operacao,

    /*output*/
    output reg movimenta_tiro,
    output reg sinal_movimenta_asteroides, 
    output reg sinal_compara_tiros_e_asteroides,
    output reg sinal_compara_asteroides_com_a_nave_e_tiro , 
    output reg fim_move_tiro_e_asteroides,             
    output reg [4:0] db_estado_coordena_asteroides_tiros,

    output reg gera_frame,
    output reg pausar_renderizacao, 
    output reg gera_asteroide, 
    output reg reset_gerador_random 
);

    parameter inicio                                      = 5'b00000; // 0
    parameter inicia_gera_aste                            = 5'b00001; // 1
    parameter espera_gera_aste                            = 5'b00010; // 2

    parameter espera                                      = 5'b00011; // 3
    parameter compara_tiros_e_asteroides                  = 5'b00100; // 4
    parameter espera_compara_tiros_e_asteroides           = 5'b00101; // 5
    parameter move_tiros                                  = 5'b00110; // 6
    parameter espera_move_tiros                           = 5'b00111; // 7
    parameter compara_asteroides_com_a_nave_e_tiro        = 5'b01000; // 8
    parameter espera_compara_asteroides_com_a_nave_e_tiro = 5'b01001; // 9
    parameter move_asteroides                             = 5'b01010; // 10
    parameter espera_move_asteroides                      = 5'b01011; // 11
    parameter inicia_gera_frame                           = 5'b01100; // 12
    parameter espera_gera_frame                           = 5'b01101; // 13
    parameter fim_movimentacao                            = 5'b01110; // 14


    parameter erro                                        = 5'b11111; // 


    // Variáveis de estado
    reg [4:0] estado_atual, proximo_estado;

    // Memória de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            estado_atual <= inicio;
        else
            estado_atual <= proximo_estado;
    end


    // Lógica de transição de estados
    always @* begin
        case (estado_atual)
            // inicio:                                      proximo_estado = espera;

            inicio:                                      proximo_estado = inicia_gera_aste;
            inicia_gera_aste:                            proximo_estado = espera_gera_aste;
            espera_gera_aste:                            proximo_estado = fim_gera_asteroide ? espera : espera_gera_aste;
            // espera:                                      proximo_estado = gera_aste ? inicia_gera_aste : 
            //                                                               (move_tiro_e_asteroides && ~gera_aste) ? compara_tiros_e_asteroides : espera;
            espera:                                      proximo_estado = gera_aste ? inicia_gera_aste : 
                                                                (move_tiro_e_asteroides && ~gera_aste) ? compara_tiros_e_asteroides : 
                                                                          (termina_operacao) ?compara_tiros_e_asteroides : espera;                                                            
            compara_tiros_e_asteroides:                  proximo_estado = espera_compara_tiros_e_asteroides;
            espera_compara_tiros_e_asteroides:           proximo_estado = (fim_comparacao_tiros_e_asteroides && ~rco_contador_movimenta_tiros) ? compara_asteroides_com_a_nave_e_tiro :
                                                                          (fim_comparacao_tiros_e_asteroides && rco_contador_movimenta_tiros) ? move_tiros : espera_compara_tiros_e_asteroides;
            move_tiros:                                  proximo_estado = espera_move_tiros;
            espera_move_tiros:                           proximo_estado = fim_move_tiros ? compara_tiros_e_asteroides : espera_move_tiros;
            compara_asteroides_com_a_nave_e_tiro:        proximo_estado = espera_compara_asteroides_com_a_nave_e_tiro;
            espera_compara_asteroides_com_a_nave_e_tiro: proximo_estado = (fim_comparacao_asteroides_com_a_nave_e_tiros && ~rco_contador_movimenta_asteroides) ? inicia_gera_frame :
                                                                          (fim_comparacao_asteroides_com_a_nave_e_tiros && rco_contador_movimenta_asteroides) ? move_asteroides :
                                                                          espera_compara_asteroides_com_a_nave_e_tiro;
            move_asteroides:                             proximo_estado = espera_move_asteroides;
            espera_move_asteroides:                      proximo_estado = fim_move_asteroides ? compara_asteroides_com_a_nave_e_tiro : espera_move_asteroides;
            inicia_gera_frame:                           proximo_estado = espera_gera_frame; //
            espera_gera_frame:                           proximo_estado = fim_gera_frame ? fim_movimentacao : espera_gera_frame; //
            fim_movimentacao:                            proximo_estado = espera;
            default:                                     proximo_estado = inicio;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin
        reset_gerador_random             = (estado_atual == inicio)                     ? 1'b1 : 1'b0;
        sinal_compara_tiros_e_asteroides = (estado_atual == compara_tiros_e_asteroides) ? 1'b1 : 1'b0;
        movimenta_tiro                   = (estado_atual == move_tiros)                 ? 1'b1 : 1'b0;
        sinal_movimenta_asteroides       = (estado_atual == move_asteroides)            ? 1'b1 : 1'b0;
        fim_move_tiro_e_asteroides       = (estado_atual == fim_movimentacao)           ? 1'b1 : 1'b0;
        gera_frame                       = (estado_atual == inicia_gera_frame)          ? 1'b1 : 1'b0;
        gera_asteroide                   = (estado_atual == inicia_gera_aste)           ? 1'b1 : 1'b0;
        pausar_renderizacao              = (estado_atual == inicia_gera_frame || estado_atual == espera_gera_frame) ? 1'b1 : 1'b0;
        sinal_compara_asteroides_com_a_nave_e_tiro = (estado_atual == compara_asteroides_com_a_nave_e_tiro)          ? 1'b1 : 1'b0;


        // Saída de depuração (estado)
        case (estado_atual)
            inicio:                                      db_estado_coordena_asteroides_tiros = 5'b00000; // 0
            inicia_gera_aste:                            db_estado_coordena_asteroides_tiros = 5'b00001; // 1
            espera_gera_aste:                            db_estado_coordena_asteroides_tiros = 5'b00010; // 2

            espera:                                      db_estado_coordena_asteroides_tiros = 5'b00011; // 3
            compara_tiros_e_asteroides:                  db_estado_coordena_asteroides_tiros = 5'b00100; // 4
            espera_compara_tiros_e_asteroides:           db_estado_coordena_asteroides_tiros = 5'b00101; // 5
            move_tiros:                                  db_estado_coordena_asteroides_tiros = 5'b00110; // 6
            espera_move_tiros:                           db_estado_coordena_asteroides_tiros = 5'b00111; // 7
            compara_asteroides_com_a_nave_e_tiro:        db_estado_coordena_asteroides_tiros = 5'b01000; // 8
            espera_compara_asteroides_com_a_nave_e_tiro: db_estado_coordena_asteroides_tiros = 5'b01001; // 9
            move_asteroides:                             db_estado_coordena_asteroides_tiros = 5'b01010; // 10
            espera_move_asteroides:                      db_estado_coordena_asteroides_tiros = 5'b01011; // 11
            inicia_gera_frame:                           db_estado_coordena_asteroides_tiros = 5'b01100; // 12
            espera_gera_frame:                           db_estado_coordena_asteroides_tiros = 5'b01101; // 13
            fim_movimentacao:                            db_estado_coordena_asteroides_tiros = 5'b01110; // 14
            default:                                     db_estado_coordena_asteroides_tiros = 5'b11111; 
        endcase
    end

endmodule







module uc_gera_asteroide (
        /* input */
        input clock                    ,
        input reset                    ,
        input gera_asteroide        ,
        input rco_contador_asteroide,
        input asteroide_renderizado,

        /* output */
        output reg reset_contador_asteroide,
        output reg conta_contador_asteroide,
        output reg conta_contador_gera_asteroide,
        output reg reset_contador_gera_asteroide,
        output reg enable_mem_aste,
        output reg enable_load_aste,
        output reg new_loaded_aste,
        output reg fim_gera_asteroide,
        output reg [3:0] db_uc_gera_asteroide

);

        parameter inicial                = 4'b0000; // 0
        parameter espera                 = 4'b0001; // 1
        parameter zera_contador          = 4'b0010; // 2
        parameter verifica_loaded        = 4'b0011; // 3
        parameter verifica_rco           = 4'b0100; // 4
        parameter incrementa_contador    = 4'b0101; // 5
        parameter espera_mem_aste        = 4'b0110; // 6
        parameter salva                  = 4'b0111; // 7
        parameter sinaliza               = 4'b1000; // 8
        parameter erro                   = 4'b1111; // F


        // Variáveis de estado
        reg [3:0] estado_atual, proximo_estado;


        // Memória de estado
        always @(posedge clock or posedge reset) begin
                if (reset)
                        estado_atual <= inicial;
                else
                        estado_atual <= proximo_estado;
        end

        // mudança de estados
        always @* begin
        case (estado_atual)
                inicial:                 proximo_estado = espera;
                espera:                  proximo_estado = gera_asteroide ? zera_contador : espera;
                zera_contador:           proximo_estado = verifica_loaded;
                verifica_loaded:         proximo_estado = asteroide_renderizado ? verifica_rco : salva;
                verifica_rco:            proximo_estado = rco_contador_asteroide ? sinaliza : incrementa_contador;
                incrementa_contador:     proximo_estado = espera_mem_aste;
                espera_mem_aste:         proximo_estado = verifica_loaded;
                salva:                   proximo_estado = sinaliza;
                sinaliza:                proximo_estado = espera;
   
                default:                  proximo_estado = erro;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin
        reset_contador_asteroide = (estado_atual == zera_contador)       ? 1'b1 : 1'b0;
        conta_contador_asteroide = (estado_atual == incrementa_contador) ? 1'b1 : 1'b0;
        enable_mem_aste          = (estado_atual == salva)               ? 1'b1 : 1'b0;
        enable_load_aste         = (estado_atual == salva)               ? 1'b1 : 1'b0;
        new_loaded_aste          = (estado_atual == salva)               ? 1'b1 : 1'b0; 
        fim_gera_asteroide       = (estado_atual == sinaliza)            ? 1'b1 : 1'b0;

        reset_contador_gera_asteroide = (estado_atual == inicial || estado_atual == sinaliza) ? 1'b1 : 1'b0;
        conta_contador_gera_asteroide = (estado_atual == espera) ? 1'b1 : 1'b0;
        // Saída de depuração (estado)
        case (estado_atual)
                inicial:                 db_uc_gera_asteroide = 4'b0000; // 0
                espera:                  db_uc_gera_asteroide = 4'b0001; // 1
                zera_contador:           db_uc_gera_asteroide = 4'b0010; // 2
                verifica_loaded:         db_uc_gera_asteroide = 4'b0011; // 3
                verifica_rco:            db_uc_gera_asteroide = 4'b0100; // 4
                incrementa_contador:     db_uc_gera_asteroide = 4'b0101; // 5
                espera_mem_aste:         db_uc_gera_asteroide = 4'b0110; // 6
                salva:                   db_uc_gera_asteroide = 4'b0111; // 7
                sinaliza:                db_uc_gera_asteroide = 4'b1000; // 8
                default:                 db_uc_gera_asteroide = 4'b1111;
        endcase
    end

endmodule



module uc_gera_frame (
        input clock,
        input reset,
        input gera_frame,
        input rco_contador_asteroides,
        input rco_contador_tiro,
        input loaded_tiro,
        input loaded_asteroide,

        output reg conta_contador_asteroide,
        output reg conta_contador_tiro,
        output reg reset_contador_tiro,
        output reg reset_contador_asteroide,
        output reg clear_mem_frame,
        output reg enable_mem_frame,
        output reg fim_gera_frame,
        output reg [1:0] select_mux_gera_frame,

        output reg [3:0] db_estado_uc_gera_frame
);

        /* declaração dos estados dessa UC */
        parameter inicial                    = 4'b0000; // 0
        parameter espera                     = 4'b0001; // 1
        parameter reseta_contadores          = 4'b0010; // 2
        parameter verifica_loaded_asteroide  = 4'b0011; // 3
        parameter salva_aste                 = 4'b0100; // 4
        parameter verifica_rco_asteroide     = 4'b0101; // 5
        parameter incrementa_asteroides      = 4'b0110; // 6
        parameter verifica_loaded_tiro       = 4'b0111; // 7
        parameter salva_tiro                 = 4'b1000; // 8
        parameter verifica_rco_tiro          = 4'b1001; // 9
        parameter incrementa_tiro            = 4'b1010; // A
        parameter sinaliza                   = 4'b1011; // B
        parameter espera_mem_aste            = 4'b1100; // C
        parameter espera_mem_tiro            = 4'b1101; // D
        parameter salva_nave                 = 4'b1110; // E



        // Variáveis de estado
        reg [3:0] estado_atual, proximo_estado;


        // Memória de estado
        always @(posedge clock or posedge reset) begin
                if (reset)
                        estado_atual <= inicial;
                else
                        estado_atual <= proximo_estado;
        end

        // mudança de estados
        always @* begin
        case (estado_atual)
                inicial:                  proximo_estado = espera;
                espera:                   proximo_estado = gera_frame ? reseta_contadores : espera;
                reseta_contadores:        proximo_estado = verifica_loaded_asteroide;
                verifica_loaded_asteroide: proximo_estado = loaded_asteroide ? salva_aste : verifica_rco_asteroide;
                // verifica_rco_asteroide:   proximo_estado = rco_contador_asteroides ? salva_nave : incrementa_asteroides;
                
                verifica_rco_asteroide:   proximo_estado = rco_contador_asteroides ? verifica_loaded_tiro : incrementa_asteroides;

                
                salva_nave:               proximo_estado = sinaliza;

                incrementa_asteroides:    proximo_estado = espera_mem_aste;
                
                espera_mem_aste:          proximo_estado = verifica_loaded_asteroide;


                salva_aste:               proximo_estado = verifica_rco_asteroide;
                incrementa_tiro:          proximo_estado = espera_mem_tiro;

                espera_mem_tiro:          proximo_estado = verifica_loaded_tiro;
                verifica_loaded_tiro:     proximo_estado = loaded_tiro ? salva_tiro : verifica_rco_tiro;
                verifica_rco_tiro:        proximo_estado = rco_contador_tiro ? salva_nave : incrementa_tiro;

                salva_tiro:               proximo_estado = verifica_rco_tiro;
                sinaliza:                 proximo_estado = espera;
                default:                  proximo_estado = inicial;
        endcase 
    end

    // Lógica de saída (maquina Moore)
    always @* begin
        reset_contador_tiro       = (estado_atual == reseta_contadores)           ? 1'b1 : 1'b0;
        reset_contador_asteroide  = (estado_atual == reseta_contadores)           ? 1'b1 : 1'b0;
        // clear_mem_frame           = (estado_atual == verifica_loaded_asteroide)   ? 1'b1 : 1'b0;
        clear_mem_frame           = (estado_atual == reseta_contadores)           ? 1'b1 : 1'b0;
        enable_mem_frame          = (estado_atual == salva_aste || 
                                     estado_atual == salva_tiro || 
                                     estado_atual == salva_nave )? 1'b1 : 1'b0;
        conta_contador_tiro       = (estado_atual == incrementa_tiro)           ? 1'b1 : 1'b0;
        conta_contador_asteroide  = (estado_atual == incrementa_asteroides)     ? 1'b1 : 1'b0;
        fim_gera_frame            = (estado_atual == sinaliza)                  ? 1'b1 : 1'b0;
        select_mux_gera_frame     = (estado_atual == salva_aste)? 2'b00 : //asteroide
                                    (estado_atual == salva_tiro)? 2'b01 : //tiro
                                     (estado_atual == salva_nave)? 2'b10 : 2'b11; //nave e monta frame respectivamente
        // Saída de depuração (estado)
        case (estado_atual)
                inicial:                    db_estado_uc_gera_frame= 4'b0000; // 0
                espera:                     db_estado_uc_gera_frame= 4'b0001; // 1
                reseta_contadores:          db_estado_uc_gera_frame= 4'b0010; // 2
                verifica_loaded_asteroide:  db_estado_uc_gera_frame= 4'b0011; // 3
                salva_aste:                 db_estado_uc_gera_frame= 4'b0100; // 4
                verifica_rco_asteroide:     db_estado_uc_gera_frame= 4'b0101; // 5
                incrementa_asteroides:      db_estado_uc_gera_frame= 4'b0110; // 6
                verifica_loaded_tiro:       db_estado_uc_gera_frame= 4'b0111; // 7
                salva_tiro:                 db_estado_uc_gera_frame= 4'b1000; // 8
                verifica_rco_tiro:          db_estado_uc_gera_frame= 4'b1001; // 9
                incrementa_tiro:            db_estado_uc_gera_frame= 4'b1010; // 10
                sinaliza:                   db_estado_uc_gera_frame= 4'b1011; // 11
                espera_mem_aste:            db_estado_uc_gera_frame= 4'b1100; // 12
                espera_mem_tiro:            db_estado_uc_gera_frame= 4'b1101; // 13
                salva_nave:                 db_estado_uc_gera_frame= 4'b1110; // 14

                default:                    db_estado_uc_gera_frame = 4'b1111;
        endcase
    end








endmodule



module uc_registra_especial (
        input clock                    ,
        input reset                    ,
        input registra_tiro_especial   , // entrada que inicia a máquina de estados
        input loaded_tiro              ,
        input rco_contador_tiro        ,
        input rco_opcode               ,
        output reg reset_contador_tiro , // reset do contador que aponta para a posição do tiro na memoria
        output reg reset_contador_especial,
        output reg reset_intervalo_especial,
        output reg enable_mem_tiro     , // enable da memoria de tiros
        output reg [1:0] select_mux_pos, // mux que seleciona a posição que será salva na memoria (salva a posição da nave e o opcode)
        output reg new_load            ,
        output reg enable_load_tiro    , // enable da memoria de tiros
        output reg conta_contador_opcode,
        output reg conta_contador_tiro  , // conta do contador que aponta para a posição do tiro na memoria
        output reg especial_registrado  , // saida final que indica o fim da operação registra tiro
        output reg select_mux_especial_opcode,
        output reg [3:0] db_estado_registra_tiro_especial
);

        /* declaração dos estados dessa UC */
        parameter inicial                    = 4'b0000; // 0
        parameter espera                     = 4'b0001; // 1
        parameter zera_contador              = 4'b0010; // 2
        parameter verifica                   = 4'b0011; // 3
        parameter salva_tiro                 = 4'b0100; // 4
        parameter verifica_rco_opcode        = 4'b0101; // 5
        parameter incrementa_contador_opcode = 4'b0110; // 6
        parameter verifica_rco_tiros         = 4'b0111; // 7
        parameter incrementa_contador_tiro   = 4'b1000; // 8
        parameter aux                        = 4'b1001; // 9
        parameter sinaliza                   = 4'b1010; // A
        parameter erro                       = 4'b1111; // F

        // Variáveis de estado
        reg [3:0] estado_atual, proximo_estado;


        // Memória de estado
        always @(posedge clock or posedge reset) begin
                if (reset)
                        estado_atual <= inicial;
                else
                        estado_atual <= proximo_estado;
        end

        // mudança de estados
        always @* begin
        case (estado_atual)
                inicial:                    proximo_estado = espera;
                espera:                     proximo_estado = registra_tiro_especial ? zera_contador : espera;
                zera_contador:              proximo_estado = verifica;
                verifica:                   proximo_estado = loaded_tiro ? verifica_rco_tiros : salva_tiro; 
                verifica_rco_tiros:         proximo_estado = rco_contador_tiro ? sinaliza : incrementa_contador_tiro;
                incrementa_contador_tiro:   proximo_estado = aux;
                aux:                        proximo_estado = verifica;
                salva_tiro:                 proximo_estado = verifica_rco_opcode;
                verifica_rco_opcode:        proximo_estado = rco_opcode ? sinaliza : incrementa_contador_opcode;
                incrementa_contador_opcode: proximo_estado = verifica;
                sinaliza:                   proximo_estado = espera;
                default:                    proximo_estado = erro;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin
        reset_contador_tiro        = (estado_atual == zera_contador) ? 1'b1 : 1'b0;
        reset_contador_especial    = (estado_atual == zera_contador) ? 1'b1 : 1'b0;
        enable_mem_tiro            = (estado_atual == salva_tiro)    ? 1'b1 : 1'b0;
        new_load                   = (estado_atual == salva_tiro)    ? 1'b1 : 1'b0;
        enable_load_tiro           = (estado_atual == salva_tiro)    ? 1'b1 : 1'b0;
        select_mux_especial_opcode = (estado_atual == salva_tiro)    ? 1'b1 : 1'b0;
        especial_registrado        = (estado_atual == sinaliza)      ? 1'b1 : 1'b0;
        select_mux_pos             = (estado_atual == salva_tiro)    ? 2'b00 : 2'b00; 
        conta_contador_tiro        = (estado_atual == incrementa_contador_tiro)   ? 1'b1 : 1'b0;
        conta_contador_opcode      = (estado_atual == incrementa_contador_opcode) ? 1'b1 : 1'b0;
        reset_intervalo_especial   = (estado_atual == sinaliza)      ? 1'b1 : 1'b0;

        // Saída de depuração (estado)
        case (estado_atual)
            inicial:                    db_estado_registra_tiro_especial = 4'b0000; // 0
            espera:                     db_estado_registra_tiro_especial = 4'b0001; // 1
            zera_contador:              db_estado_registra_tiro_especial = 4'b0010; // 2
            verifica:                   db_estado_registra_tiro_especial = 4'b0011; // 3
            salva_tiro:                 db_estado_registra_tiro_especial = 4'b0100; // 4
            verifica_rco_opcode:        db_estado_registra_tiro_especial = 4'b0101; // 5
            incrementa_contador_opcode: db_estado_registra_tiro_especial = 4'b0110; // 6
            verifica_rco_tiros:         db_estado_registra_tiro_especial = 4'b0111; // 7
            incrementa_contador_tiro:   db_estado_registra_tiro_especial = 4'b1000; // 8
            aux:                        db_estado_registra_tiro_especial = 4'b1001; // 9
            sinaliza:                   db_estado_registra_tiro_especial = 4'b1010; // A
            erro:                       db_estado_registra_tiro_especial = 4'b1111; // F
            default:                    db_estado_registra_tiro_especial = erro;
        endcase
    end








endmodule


module uc_jogo_principal (

        input clock,
        input iniciar, // entrada que inicia a máquina de estados
        input reset,
        input vidas,


        input fim_movimentacao_asteroides_e_tiros, // indica o fim da uc_coordena_asteroides_tiros.v
        input fim_registra_tiros,
        input fim_registra_especial, // adicionado 27/03 17h30
        input ocorreu_tiro,
        input ocorreu_jogada,

        input ocorreu_especial, // adicionado 27/03 17h30
        input tiro,      // adicionado 27/03 17h30
        input especial, // adicionado 27/03 17h30

        input rco_intervalo_especial,
        // sinais do registrador
        output reg enable_reg_jogada,
        output reg reset_reg_jogada, 
        output reg inicia_registra_tiros,
        output reg inicia_registra_especial, // adicionado 27/03 17h30
        output reg inicia_movimentacao_asteroides_e_tiros, // saída para o inicio da máquina de estados uc_coordena_asteroides_tiros.v

        // resets de contadores
        output reg reset_contador_asteroides,
        output reg reset_contador_tiro,
        output reg reset_contador_vidas,
        // resets de outras máquinas de estados
        output reg reset_maquinas,
        output reg reset_pontuacao,
        output reg pronto,
        output reg termina,
        output reg [4:0] db_estado_jogo_principal
);

 /* declaração dos estados dessa UC */
        parameter inicial                                 = 5'b00000; // 0
        parameter inicializa_elementos                    = 5'b00001; // 1
        parameter espera_jogada                           = 5'b00010; // 2
        parameter registra_jogada                         = 5'b00011; // 3
        parameter termina_movimentacao_asteroides_e_tiros = 5'b00100; // 4
        parameter espera_registra_tiros                   = 5'b00101; // 5 
        parameter fim_jogo                                = 5'b00110; // 6 
        parameter inicia_state_registra_tiros             = 5'b00111; // 7
        parameter espera_salvamento                       = 5'b01000; // 8
        parameter espera_salvamento2                      = 5'b01001; // 9
        parameter inicia_state_registra_especial          = 5'b01010; // 10 // adicionado 27/03 17h30
        parameter espera_registra_especial                = 5'b01011; // 11 // adicionado 27/03 17h30
        parameter erro                                    = 5'b11111; // F

// Variáveis de estado
        reg [4:0] estado_atual, proximo_estado;

        // Memória de estado
        always @(posedge clock or posedge reset) begin
                if (reset)
                        estado_atual <= inicial;
                else
                        estado_atual <= proximo_estado;
        end

        // mudança de estados
        always @* begin
        case (estado_atual)
                inicial:              proximo_estado = iniciar ? inicializa_elementos : inicial;                                 
                inicializa_elementos: proximo_estado = espera_jogada;
                // espera_jogada:        proximo_estado = ~vidas ? fim_jogo :
                //                                        (vidas && ocorreu_jogada)  ? registra_jogada : 
                //                                        (vidas && ~ocorreu_jogada) ? espera_jogada   : erro;

                espera_jogada:        proximo_estado = ~vidas ? fim_jogo :  
                                                        (ocorreu_jogada)  ? registra_jogada : espera_jogada;

                registra_jogada:      proximo_estado = espera_salvamento;
                espera_salvamento:    proximo_estado = espera_salvamento2; 
                // espera_salvamento2: proximo_estado   = ~vidas ? fim_jogo : 
                //                                        (vidas && ocorreu_tiro)  ? termina_movimentacao_asteroides_e_tiros :
                //                                        (vidas && ~ocorreu_tiro) ? espera_jogada : erro; 

                espera_salvamento2: proximo_estado   = ~vidas ? fim_jogo : 
                                                (ocorreu_tiro || (ocorreu_especial  && rco_intervalo_especial))  ? termina_movimentacao_asteroides_e_tiros : espera_jogada;

                // termina_movimentacao_asteroides_e_tiros: proximo_estado = (fim_movimentacao_asteroides_e_tiros && ~vidas            )? fim_jogo :
                //                                                           (fim_movimentacao_asteroides_e_tiros && vidas && especial && rco_intervalo_especial)? inicia_state_registra_especial :
                //                                                           (fim_movimentacao_asteroides_e_tiros && vidas && tiro    )? inicia_state_registra_tiros : termina_movimentacao_asteroides_e_tiros;


termina_movimentacao_asteroides_e_tiros: proximo_estado = (fim_movimentacao_asteroides_e_tiros && ~vidas            )? fim_jogo :
                                                          (fim_movimentacao_asteroides_e_tiros && vidas && especial && rco_intervalo_especial)? inicia_state_registra_especial :
                                                          (fim_movimentacao_asteroides_e_tiros && vidas && tiro    )? inicia_state_registra_tiros : termina_movimentacao_asteroides_e_tiros;

                inicia_state_registra_especial:    proximo_estado = espera_registra_especial;
                espera_registra_especial:          proximo_estado = fim_registra_especial ? espera_jogada : espera_registra_especial;

                inicia_state_registra_tiros:       proximo_estado = espera_registra_tiros;
                espera_registra_tiros:             proximo_estado = fim_registra_tiros ? espera_jogada : espera_registra_tiros;                      
                fim_jogo:                          proximo_estado = reset ? inicial : fim_jogo;   
                default:                           proximo_estado = erro;                             
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin
        reset_reg_jogada          = (estado_atual == inicializa_elementos ||
                                     estado_atual == espera_jogada        ||
                                     estado_atual == fim_jogo)             ? 1'b1 : 1'b0;
        reset_contador_asteroides = (estado_atual == inicializa_elementos ||
                                     estado_atual == fim_jogo)             ? 1'b1 : 1'b0;
        reset_contador_tiro       = (estado_atual == inicializa_elementos ||
                                     estado_atual == fim_jogo)             ? 1'b1 : 1'b0;
        reset_maquinas            = (estado_atual == inicializa_elementos  ||
                                     estado_atual == fim_jogo)             ? 1'b1 : 1'b0;
        reset_pontuacao           = (estado_atual == inicializa_elementos) ? 1'b1 : 1'b0;
        reset_contador_vidas      = (estado_atual == inicializa_elementos ||
                                     estado_atual == fim_jogo)             ? 1'b1 : 1'b0;
        enable_reg_jogada         = (estado_atual == registra_jogada)      ? 1'b1 : 1'b0;
        inicia_registra_tiros     = (estado_atual == inicia_state_registra_tiros) ? 1'b1 : 1'b0;
        inicia_registra_especial  = (estado_atual == inicia_state_registra_especial) ? 1'b1 : 1'b0;
        pronto                    = (estado_atual == fim_jogo)             ? 1'b1 : 1'b0;
        inicia_movimentacao_asteroides_e_tiros = (estado_atual == espera_jogada) ? 1'b1 : 1'b0;
        termina                   = (estado_atual == termina_movimentacao_asteroides_e_tiros) ? 1'b1 : 1'b0;

        // Saída de depuração (estado)
        case (estado_atual)
                inicial                                 : db_estado_jogo_principal = 5'b00000; // 0
                inicializa_elementos                    : db_estado_jogo_principal = 5'b00001; // 1
                espera_jogada                           : db_estado_jogo_principal = 5'b00010; // 2 
                registra_jogada                         : db_estado_jogo_principal = 5'b00011; // 3 
                termina_movimentacao_asteroides_e_tiros : db_estado_jogo_principal = 5'b00100; // 4 
                espera_registra_tiros                   : db_estado_jogo_principal = 5'b00101; // 5 
                fim_jogo                                : db_estado_jogo_principal = 5'b00110; // 6
                inicia_state_registra_tiros             : db_estado_jogo_principal = 5'b00111; // 7
                espera_salvamento                       : db_estado_jogo_principal = 5'b01000; // 8
                espera_salvamento2                      : db_estado_jogo_principal = 5'b01001; // 9
                inicia_state_registra_especial          : db_estado_jogo_principal = 5'b01010; // 10 
                espera_registra_especial                : db_estado_jogo_principal = 5'b01011; // 11 
                default                                 : db_estado_jogo_principal = 5'b11111;
        endcase
    end

endmodule


module uc_move_asteroides (
        input clock,
        input movimenta_aste,
        input reset,
        input [1:0] opcode_aste,
        input loaded_aste,
        input rco_contador_aste,

        //saidas 
        output reg [1:0] select_mux_pos_aste,   //seletor do mux da posição 
        output reg select_mux_coor_aste,  //seletor do mux da posição 
        output reg select_soma_sub,  
        output reg reset_contador_aste,
        output reg conta_contador_aste, 
        output reg reset_contador_movimenta_asteroide,
        output reg enable_mem_aste, // enable da memoria de tiros
        output reg movimentacao_concluida_aste, // sinal que indica o fim da movimentação dos tiros
        output reg [4:0] db_estado_move_aste

);

        parameter inicio                 = 5'b00000; // 0
        parameter espera                 = 5'b00001; // 1
        parameter reseta_contador        = 5'b00010; // 2
        parameter verifica_loaded        = 5'b00011; // 3
        parameter verifica_opcode        = 5'b00100; // 4
        parameter horizontal_crescente   = 5'b00101; // 5 
        parameter horizontal_decrescente = 5'b00110; // 6
        parameter vertical_crescente     = 5'b00111; // 7
        parameter vertical_decrescente   = 5'b01000; // 8
        parameter salva_posicao          = 5'b01001; // 9
        parameter incrementa_contador    = 5'b01010; // 10
        parameter aux                    = 5'b01011; // 11
        parameter sinaliza               = 5'b01110; // 12
        parameter erro                   = 5'b11111; // erro

// Variáveis de estado
        reg [4:0] estado_atual, proximo_estado;

        // Memória de estado
        always @(posedge clock or posedge reset) begin
                if (reset)
                        estado_atual <= inicio;
                else
                        estado_atual <= proximo_estado;
        end

        // mudança de estados
        always @* begin
        case (estado_atual) 
                inicio:                proximo_estado = espera;
                espera:                proximo_estado = movimenta_aste ? reseta_contador : espera;
                reseta_contador:       proximo_estado = verifica_loaded;
                verifica_loaded:       proximo_estado = loaded_aste ? verifica_opcode :
                                                        (~loaded_aste && rco_contador_aste) ? sinaliza :
                                                        (~loaded_aste && ~rco_contador_aste) ? incrementa_contador : erro;
                verifica_opcode:        proximo_estado = opcode_aste == 2'b00 ? horizontal_crescente : 
                                                         opcode_aste == 2'b01 ? horizontal_decrescente :
                                                         opcode_aste == 2'b10 ? vertical_crescente : vertical_decrescente;
                horizontal_crescente:   proximo_estado = salva_posicao; 
                horizontal_decrescente: proximo_estado = salva_posicao;
                vertical_crescente:     proximo_estado = salva_posicao;
                vertical_decrescente:   proximo_estado = salva_posicao;
                salva_posicao:          proximo_estado = rco_contador_aste ? sinaliza : incrementa_contador;
                incrementa_contador:    proximo_estado = aux;
                aux:                    proximo_estado = verifica_loaded;
                sinaliza:               proximo_estado = espera;
                default:                proximo_estado = inicio;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin
        reset_contador_aste         = (estado_atual == reseta_contador)        ? 1'b1 : 1'b0;
        movimentacao_concluida_aste = (estado_atual == sinaliza)               ? 1'b1 : 1'b0;
        conta_contador_aste         = (estado_atual == incrementa_contador)    ? 1'b1 : 1'b0;
        enable_mem_aste             = (estado_atual == horizontal_crescente    || 
                                       estado_atual == horizontal_decrescente  ||
                                       estado_atual == vertical_crescente      ||
                                       estado_atual == vertical_decrescente)   ? 1'b1 : 1'b0;
        select_soma_sub             = (estado_atual == horizontal_decrescente  ||
                                       estado_atual == vertical_decrescente)   ? 1'b1 : 1'b0;
        select_mux_pos_aste         = (estado_atual == horizontal_crescente    ||
                                       estado_atual == horizontal_decrescente) ? 2'b01 :  
                                      (estado_atual == vertical_crescente      ||
                                       estado_atual == vertical_decrescente)   ? 2'b10 : 2'b00;
        select_mux_coor_aste        = (estado_atual == vertical_crescente      ||
                                       estado_atual == vertical_decrescente)   ? 1'b1 : 1'b0;
        reset_contador_movimenta_asteroide = (estado_atual == sinaliza) ? 1'b1 : 1'b0;

        // Saída de depuração (estado)
        case (estado_atual)
            inicio:                 db_estado_move_aste = 5'b00000; // 0
            espera:                 db_estado_move_aste = 5'b00001; // 1
            reseta_contador:        db_estado_move_aste = 5'b00010; // 2
            verifica_loaded:        db_estado_move_aste = 5'b00011; // 3
            verifica_opcode:        db_estado_move_aste = 5'b00100; // 4
            horizontal_crescente:   db_estado_move_aste = 5'b00101; // 5 
            horizontal_decrescente: db_estado_move_aste = 5'b00110; // 6
            vertical_crescente:     db_estado_move_aste = 5'b00111; // 7
            vertical_decrescente:   db_estado_move_aste = 5'b01000; // 8
            salva_posicao:          db_estado_move_aste = 5'b01001; // 9
            incrementa_contador:    db_estado_move_aste = 5'b01010; // 10
            aux:                    db_estado_move_aste = 5'b01011; // 11
            sinaliza:               db_estado_move_aste = 5'b01110; // 12
            erro:                   db_estado_move_aste = 5'b11111; // erro
            default:                db_estado_move_aste = 5'b11111; // 
        endcase
    end
endmodule




module uc_move_tiros (
        input clock                    ,
        input movimenta_tiro           ,
        input reset                    ,
        input [1:0] opcode_tiro        ,
        input loaded_tiro              ,
        input rco_contador_tiro        ,

        //entradas para verificar se o tiro saiu da tela
        input x_borda_max_tiro         , //true se a coord. X do tiro estiver no MAXIMO da horizontal
        input y_borda_max_tiro         , //true se a coord. Y do tiro estiver no MAXIMO da vetical
        input x_borda_min_tiro         , //true se a coord. Y do tiro estiver no MINIMO da horizontal
        input y_borda_min_tiro         , //true se a coord. Y do tiro estiver no MINIMO da vetical

        //saidas 
        output reg [1:0] select_mux_pos_tiro ,   //seletor do mux da posição 
        output reg select_mux_coor_tiro,  //seletor do mux da posição 
        output reg select_soma_sub     ,  
        output reg reset_contador_tiro ,
        output reg conta_contador_tiro , 
        output reg reset_contador_movimenta_tiro,
        output reg enable_mem_tiro     , // enable da memoria de tiros
        output reg enable_load_tiro    ,
        output reg new_loaded,                 // valor do loaded que será salvo na nossa memoria (é 0 quando tiro sair da tela) 
        output reg movimentacao_concluida_tiro, // sinal que indica o fim da movimentação dos tiros
        output reg [4:0] db_estado_move_tiros

);

    parameter inicio                 = 5'b00000; // 0
    parameter espera                 = 5'b00001; // 1
    parameter reseta_contador        = 5'b00010; // 2
    parameter verifica_loaded        = 5'b00011; // 3
    parameter verifica_saiu_tela     = 5'b00100; // 4
    parameter altera_loaded          = 5'b00101; // 5
    parameter salva_loaded           = 5'b00110; // 6
    parameter incrementa_contador    = 5'b00111; // 7
    parameter verifica_opcode        = 5'b01000; // 8 
    parameter horizontal_crescente   = 5'b01001; // 9 
    parameter horizontal_decrescente = 5'b01010; // A
    parameter vertical_crescente     = 5'b01011; // B
    parameter vertical_decrescente   = 5'b01100; // C
    parameter salva_posicao          = 5'b01101; // D
    parameter sinaliza               = 5'b01110; // E
    parameter aux                    = 5'b01111; // F
    parameter erro                   = 5'b11111; // erro

// Variáveis de estado
        reg [3:0] estado_atual, proximo_estado;

        // Memória de estado
        always @(posedge clock or posedge reset) begin
                if (reset)
                        estado_atual <= inicio;
                else
                        estado_atual <= proximo_estado;
        end

        // mudança de estados
        always @* begin
        case (estado_atual) 
                inicio:                proximo_estado = espera;
                espera:                proximo_estado = movimenta_tiro ? reseta_contador : espera;
                reseta_contador:       proximo_estado = verifica_loaded;
                verifica_loaded:       proximo_estado =   loaded_tiro                        ? verifica_saiu_tela  : 
                                                        (~loaded_tiro && ~rco_contador_tiro) ? incrementa_contador : 
                                                        (~loaded_tiro && rco_contador_tiro)  ? sinaliza : verifica_loaded;
                verifica_saiu_tela:    proximo_estado = (opcode_tiro == 2'b00 && x_borda_max_tiro  ||
                                                         opcode_tiro == 2'b01 && x_borda_min_tiro  ||
                                                         opcode_tiro == 2'b10 && y_borda_max_tiro  ||
                                                         opcode_tiro == 2'b11 && y_borda_min_tiro  )? altera_loaded : verifica_opcode;
                altera_loaded:          proximo_estado = salva_loaded;
                salva_loaded:           proximo_estado = rco_contador_tiro ? sinaliza : incrementa_contador;
                verifica_opcode:        proximo_estado = opcode_tiro == 2'b00 ? horizontal_crescente : 
                                                         opcode_tiro == 2'b01 ? horizontal_decrescente :
                                                         opcode_tiro == 2'b10 ? vertical_crescente : vertical_decrescente;
                horizontal_crescente:   proximo_estado = salva_posicao; 
                horizontal_decrescente: proximo_estado = salva_posicao;
                vertical_crescente:     proximo_estado = salva_posicao;
                vertical_decrescente:   proximo_estado = salva_posicao;
                salva_posicao:          proximo_estado = rco_contador_tiro ? sinaliza : incrementa_contador;
                incrementa_contador:    proximo_estado = aux;
                aux:                    proximo_estado = verifica_loaded;
                sinaliza:               proximo_estado = espera;
                default:                proximo_estado = inicio;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin
        reset_contador_tiro         = (estado_atual == reseta_contador) ? 1'b1 : 1'b0;
        new_loaded                  = (estado_atual == altera_loaded || 
                                       estado_atual == salva_loaded) ? 1'b0 : 1'b1;
        enable_load_tiro             = (estado_atual == salva_loaded) ? 1'b1 : 1'b0;
        enable_mem_tiro             = (estado_atual == horizontal_crescente || 
                                        estado_atual == horizontal_decrescente ||
                                        estado_atual == vertical_crescente ||
                                        estado_atual == vertical_decrescente) ? 1'b1 : 1'b0;
        conta_contador_tiro         = (estado_atual == incrementa_contador) ? 1'b1 : 1'b0;
        select_soma_sub             = (estado_atual == horizontal_decrescente ||
                                       estado_atual == vertical_decrescente      )? 1'b1 : 1'b0;

        select_mux_pos_tiro         = (estado_atual == horizontal_crescente ||
                                       estado_atual == horizontal_decrescente) ? 2'b01 :  
                                      (estado_atual == vertical_crescente ||
                                       estado_atual == vertical_decrescente) ? 2'b10 : 2'b00;

        select_mux_coor_tiro        = (estado_atual == vertical_crescente ||
                                       estado_atual == vertical_decrescente) ? 1'b1 : 1'b0;
        movimentacao_concluida_tiro = (estado_atual == sinaliza) ? 1'b1 : 1'b0;

        reset_contador_movimenta_tiro = (estado_atual == sinaliza) ? 1'b1 : 1'b0;

        // Saída de depuração (estado)
        case (estado_atual)
                inicio:                 db_estado_move_tiros = 5'b00000; // 0
                espera:                 db_estado_move_tiros = 5'b00001; // 1
                reseta_contador:        db_estado_move_tiros = 5'b00010; // 2
                verifica_loaded:        db_estado_move_tiros = 5'b00011; // 3
                verifica_saiu_tela:     db_estado_move_tiros = 5'b00100; // 4
                altera_loaded:          db_estado_move_tiros = 5'b00101; // 5
                salva_loaded:           db_estado_move_tiros = 5'b00110; // 6
                incrementa_contador:    db_estado_move_tiros = 5'b00111; // 7
                verifica_opcode:        db_estado_move_tiros = 5'b01000; // 8 
                horizontal_crescente:   db_estado_move_tiros = 5'b01001; // 9 
                horizontal_decrescente: db_estado_move_tiros = 5'b01010; // A
                vertical_crescente:     db_estado_move_tiros = 5'b01011; // B
                vertical_decrescente:   db_estado_move_tiros = 5'b01100; // C
                salva_posicao:          db_estado_move_tiros = 5'b01101; // D
                sinaliza:               db_estado_move_tiros = 5'b01110; // E
                aux:                    db_estado_move_tiros = 5'b01111; // F
                erro:                   db_estado_move_tiros = 5'b11111; // erro
                default:                db_estado_move_tiros = 5'b11111; // 
        endcase
    end
endmodule




module uc_registra_tiro (
        input clock                    ,
        input registra_tiro            , // entrada que inicia a máquina de estados
        input reset                    ,
        input loaded_tiro              ,
        input rco_contador_tiro        ,
        output reg enable_mem_tiro     , // enable da memoria de tiros
        output reg enable_load_tiro    , // enable da memoria de tiros
        output reg new_load            ,
        //contador
        output reg clear_contador_tiro  , // clear do contador que aponta para a posição do tiro na memoria
        output reg conta_contador_tiro  , // conta do contador que aponta para a posição do tiro na memoria
        output reg [1:0] select_mux_pos , // mux que seleciona a posição que será salva na memoria (salva a posição da nave e o opcode)
        output reg tiro_registrado      , // saida final que indica o fim da operação registra tiro
        output reg [3:0] db_estado_registra_tiro

);

        /* declaração dos estados dessa UC */
        parameter inicial                  = 4'b0000; // 0
        parameter espera                   = 4'b0001; // 1
        parameter zera_contador            = 4'b0010; // 2
        parameter verifica                 = 4'b0011; // 3
        parameter incrementa_contador_tiro = 4'b0100; // 4
        parameter salva_tiro               = 4'b0101; // 5
        parameter sinaliza                 = 4'b0110; // 6
        parameter aux                      = 4'b0111; // 7
        parameter erro                     = 4'b1111; // F


        // Variáveis de estado
        reg [3:0] estado_atual, proximo_estado;


        // Memória de estado
        always @(posedge clock or posedge reset) begin
                if (reset)
                        estado_atual <= inicial;
                else
                        estado_atual <= proximo_estado;
        end

        // mudança de estados
        always @* begin
        case (estado_atual)
                inicial:                  proximo_estado = espera;
                espera:                   proximo_estado = registra_tiro ? zera_contador : espera;
                
                zera_contador:            proximo_estado = verifica;

                verifica:                 proximo_estado = (loaded_tiro && ~rco_contador_tiro) ? incrementa_contador_tiro : 
                                                           (loaded_tiro && rco_contador_tiro)  ? sinaliza   : salva_tiro;
                incrementa_contador_tiro: proximo_estado = aux;
                aux:                      proximo_estado = verifica;
                salva_tiro:               proximo_estado = sinaliza;
                sinaliza:                 proximo_estado = espera;
                default:                  proximo_estado = inicial;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin
        clear_contador_tiro = (estado_atual == zera_contador) ? 1'b1 : 1'b0;
        new_load            = (estado_atual == salva_tiro)    ? 1'b1 : 1'b0;
        enable_mem_tiro     = (estado_atual == salva_tiro)    ? 1'b1 : 1'b0;
        enable_load_tiro    = (estado_atual == salva_tiro)    ? 1'b1 : 1'b0;
        tiro_registrado     = (estado_atual == sinaliza)      ? 1'b1 : 1'b0;
        select_mux_pos      = (estado_atual == salva_tiro)    ? 2'b00 : 2'b00;   
        conta_contador_tiro = (estado_atual == incrementa_contador_tiro) ? 1'b1 : 1'b0;

        // Saída de depuração (estado)
        case (estado_atual)
            inicial:                  db_estado_registra_tiro = 4'b0000; // 0
            espera:                   db_estado_registra_tiro = 4'b0001; // 1
            zera_contador:            db_estado_registra_tiro = 4'b0010; // 2
            verifica:                 db_estado_registra_tiro = 4'b0011; // 3
            incrementa_contador_tiro: db_estado_registra_tiro = 4'b0100; // 4
            salva_tiro:               db_estado_registra_tiro = 4'b0101; // 5
            sinaliza:                 db_estado_registra_tiro = 4'b0110; // 6                    
            aux:                      db_estado_registra_tiro = 4'b0111; // 7
            erro:                     db_estado_registra_tiro = 4'b1111; // F
            default:                  db_estado_registra_tiro = 4'b0000;
        endcase
    end








endmodule



module uc_renderiza (
        input clock                    ,
        input reset                    ,
        input pausar_renderizacao      ,
        input rco_contador_frame       ,
        output reg reset_contador_frame,    
        output reg conta_contador_frame,    
        output reg [3:0] db_estado_uc_renderiza
);

        /* declaração dos estados dessa UC */
        parameter inicial                 = 4'b0000; // 0
        parameter zera_contador           = 4'b0001; // 1
        parameter conta_contador          = 4'b0010; // 2
        parameter pausado                 = 4'b0011; // 3
        // parameter incrementa_contador_tiro = 4'b0100; // 4
        // parameter salva_tiro               = 4'b0101; // 5
        // parameter sinaliza                 = 4'b0110; // 6
        // parameter aux                      = 4'b0111; // 7
        parameter erro                     = 4'b1111; // F


        // Variáveis de estado
        reg [3:0] estado_atual, proximo_estado;


        // Memória de estado
        always @(posedge clock or posedge reset) begin
                if (reset)
                        estado_atual <= inicial;
                else
                        estado_atual <= proximo_estado;
        end

        // mudança de estados
        always @* begin
        case (estado_atual)
                inicial:                  proximo_estado = zera_contador;
                zera_contador:            proximo_estado = pausar_renderizacao ? pausado : conta_contador;
                conta_contador:           proximo_estado = pausar_renderizacao ? pausado : 
                                                           (rco_contador_frame && ~pausar_renderizacao)? zera_contador : conta_contador;
                pausado:                  proximo_estado = pausar_renderizacao ? pausado : zera_contador;

                default:                  proximo_estado = erro;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin

        reset_contador_frame   = (estado_atual == zera_contador || estado_atual == inicial) ? 1'b1 : 1'b0;
        conta_contador_frame   = (estado_atual == conta_contador) ? 1'b1 : 1'b0;

        // Saída de depuração (estado)
        case (estado_atual)
                inicial:                 db_estado_uc_renderiza = 4'b0000; // 0
                zera_contador:           db_estado_uc_renderiza = 4'b0001; // 1
                conta_contador:          db_estado_uc_renderiza = 4'b0010; // 2
                pausado:                 db_estado_uc_renderiza = 4'b0011; // 3
                erro:                    db_estado_uc_renderiza = 4'b1111; // F
                default:                 db_estado_uc_renderiza = 4'b0000;
        endcase
    end








endmodule


