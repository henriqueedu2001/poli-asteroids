module astro_genius (
        input clock,
        input reset,
        input iniciar,
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
        output [3:0] db_vidas,
        output [3:0] db_asteroide_x,
        output [3:0] db_asteroide_y,
        output [3:0] db_tiro_x,
        output [3:0] db_tiro_y,
        output db_aste_renderizado,
        output db_tiro_renderizado
);

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

assign db_aste_renderizado = wire_aste_renderizado;
assign db_tiro_renderizado = wire_tiro_renderizado;
assign db_asteroide_x = wire_aste_renderizado ? wire_aste_coor_x : 4'b0000;
assign db_asteroide_y = wire_aste_renderizado ? wire_aste_coor_y : 4'b0000;

assign db_tiro_x = wire_tiro_renderizado ? wire_tiro_coor_x : 4'b0000;
assign db_tiro_y = wire_tiro_renderizado ? wire_tiro_coor_y : 4'b0000;

uc_jogo_principal uc_jogo_principal(
    /* inputs */
    .clock(clock),
    .iniciar(iniciar),
    .reset(reset),
    .vidas(~wire_vidas), //rco do decrementador
    .fim_movimentacao_asteroides_e_tiros(wire_fim_movimentacao_asteroides_e_tiros), 
    .fim_registra_tiros(wire_tiro_registrado),
    .ocorreu_tiro(wire_ocorreu_tiro), 
    .ocorreu_jogada(wire_ocorreu_jogada), //saida do edge detector
    /* outputs */
    .enable_reg_jogada(wire_enable_reg_jogada),
    .reset_reg_jogada(wire_reset_reg_jogada), 
    .inicia_registra_tiros(wire_inicia_registra_tiros),
    .inicia_movimentacao_asteroides_e_tiros(wire_inicia_movimentacao_asteroides_e_tiros), 
    .reset_contador_asteroides(wire_reset_contador_asteroides_uc_principal),
    .reset_contador_tiro(wire_reset_contador_tiro_uc_principal),
    .reset_contador_vidas(wire_reset_contador_vidas),
    .reset_maquinas(wire_reset_maquinas),
    .pronto(pronto),
    .db_estado_jogo_principal(db_estado_jogo_principal)
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
wire wire_rco_contador_tiro_quantas_incrementacoes;
wire  wire_rco_contador_asteroides_quantas_incrementacoes;

// OUTPUT
wire wire_movimenta_tiro;
wire wire_sinal_movimenta_asteroides;
wire wire_sinal_compara_tiros_e_asteroides_uc_coordena_asteroides_tiros;
wire wire_sinal_compara_asteroides_com_a_nave_e_tiro;

// compartilhados
wire wire_conta_contador_tiro_uc_coordena_asteroides_tiros;
wire wire_reset_contador_tiro_uc_coordena_asteroides_tiros;
wire wire_reset_contador_asteroides_uc_coordena_asteroides_tiros;
wire wire_conta_contador_asteroides_uc_coordena_asteroides_tiros;

wire wire_sinal_compara_tiros_e_asteroide_uc_compara_asteroides_com_nave_e_tiros;

uc_coordena_asteroides_tiros uc_coordena_asteroides_tiros(
    /* inputs */
    .clock(clock),
    .reset(wire_reset_maquinas),
    .move_tiro_e_asteroides(wire_inicia_movimentacao_asteroides_e_tiros),
    .rco_contador_tiro(wire_rco_contador_tiro_quantas_incrementacoes),
    .rco_contador_asteroides(wire_rco_contador_asteroides_quantas_incrementacoes),
    .fim_move_tiros(wire_fim_move_tiros),
    .fim_move_asteroides(wire_fim_move_asteroides),
    .fim_comparacao_asteroides_com_a_nave_e_tiros(wire_fim_comparacao_asteroides_com_a_nave_e_tiros),
    .fim_comparacao_tiros_e_asteroides(wire_fim_comparacao_tiros_e_asteroides),
    /* outputs */
    .movimenta_tiro(wire_movimenta_tiro),
    .sinal_movimenta_asteroides(wire_sinal_movimenta_asteroides),
    .sinal_compara_tiros_e_asteroides(wire_sinal_compara_tiros_e_asteroides_uc_coordena_asteroides_tiros ),
    .sinal_compara_asteroides_com_a_nave_e_tiro(wire_sinal_compara_asteroides_com_a_nave_e_tiro),
    .conta_contador_tiro(wire_conta_contador_tiro_uc_coordena_asteroides_tiros),
    .reset_contador_tiro(wire_reset_contador_tiro_uc_coordena_asteroides_tiros),
    .reset_contador_asteroides(wire_reset_contador_asteroides_uc_coordena_asteroides_tiros),
    .conta_contador_asteroides(wire_conta_contador_asteroides_uc_coordena_asteroides_tiros),
    .fim_move_tiro_e_asteroides(wire_fim_movimentacao_asteroides_e_tiros),
    .db_estado_coordena_asteroides_tiros(db_estado_coordena_asteroides_tiros)
);




// wires da conexão da uc_compara_tiros_e_asteroides com outros modulos
// INPUT
wire wire_posicao_tiro_igual_asteroide;

// principal
wire wire_tiro_renderizado;
wire wire_aste_renderizado;

// OUTPUT
wire wire_reset_contador_asteroides_uc_compara_tiros_e_asteroides;
wire wire_reset_contador_tiros_uc_compara_tiros_e_asteroides;
wire wire_enable_load_tiro_uc_compara_tiros_e_asteroides;
wire wire_enable_load_asteroide_uc_compara_tiros_e_asteroides;
wire wire_new_loaded_tiro_uc_compara_tiros_e_asteroides;
wire wire_new_loaded_asteroide_uc_compara_tiros_e_asteroides;
wire wire_new_destruido_asteroide_uc_compara_tiros_e_asteroides;

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

    .s_fim_comparacao(wire_fim_comparacao_tiros_e_asteroides),
    .db_estado_compara_tiros_e_asteroide(db_estado_compara_tiros_e_asteroide)
);



// wires da conexão da uc_move_tiros com outros modulos
// INPUT
wire [1:0] wire_opcode_tiro;
wire wire_x_borda_max_tiro;
wire wire_y_borda_max_tiro;
wire wire_x_borda_min_tiro;
wire wire_y_borda_min_tiro;

// OUTPUT
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
    .enable_mem_tiro(wire_enable_mem_tiro_uc_move_tiros), 
    .enable_load_tiro(wire_enable_load_tiro_uc_move_tiros),
    .new_loaded(wire_new_loaded_tiro_uc_move_tiros),                
    .movimentacao_concluida_tiro(wire_fim_move_tiros), 
    .db_estado_move_tiros(db_estado_move_tiros)
);

// INPUT
wire wire_posicao_asteroide_igual_nave;

// OUTPUT
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

// INPUT

wire [1:0] wire_opcode_aste;

// OUTPUT
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


asteroide asteroide(
    /* inputs */
    .clock(clock),
    .conta_contador_aste(wire_conta_contador_asteroides_uc_compara_tiros_e_asteroides|
                         wire_conta_contador_asteroides_uc_compara_asteroides_com_nave_e_tiros |
                         wire_conta_contador_aste_uc_move_asteroides),
    .reset_contador_aste(wire_reset_contador_asteroides_uc_principal | 
                         wire_reset_contador_asteroides_uc_compara_tiros_e_asteroides |
                         wire_reset_contador_asteroides_uc_compara_asteroides_com_nave_e_tiros |
                         wire_reset_contador_aste_uc_move_asteroides),
    .select_mux_pos_aste(wire_select_mux_pos_aste_uc_move_asteroides),
    .select_mux_coor_aste(wire_select_mux_coor_aste_uc_move_asteroides),
    .select_soma_sub_aste(wire_select_soma_sub_uc_move_asteroides),
    .enable_reg_nave(),
    .reset_reg_nave(),
    .enable_mem_aste(wire_enable_mem_aste_uc_move_asteroides),
    .enable_load_aste(wire_enable_load_asteroide_uc_compara_tiros_e_asteroides |
                      wire_enable_load_asteroides_uc_compara_asteroides_com_nave_e_tiros),
    // .new_load_aste(wire_new_loaded_asteroide_uc_compara_tiros_e_asteroides | 
    //                wire_new_loaded_asteroide_uc_compara_asteroides_com_nave_e_tiros),
    .new_load_aste(1'b0),
    .new_destruido_aste(wire_new_destruido_asteroide_uc_compara_tiros_e_asteroides |
                        wire_new_destruido_asteroide_uc_compara_asteroides_com_nave_e_tiros),
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

wire [3:0] wire_tiro_coor_x;
wire [3:0] wire_tiro_coor_y;


tiro tiro (
    /* inputs */
    .clock(clock),
    .conta_contador_tiro(wire_conta_contador_tiros_uc_compara_tiros_e_asteroides |
                         wire_conta_contador_tiro_uc_move_tiros |
                         wire_conta_contador_tiro_uc_registra_tiro),
    .reset_contador_tiro(wire_reset_contador_tiro_uc_principal |
                         wire_reset_contador_tiros_uc_compara_tiros_e_asteroides |
                         wire_reset_contador_tiro_uc_move_tiros |
                         wire_reset_contador_tiro_uc_registra_tiro),
    .select_mux_pos_tiro(wire_select_mux_pos_tiro_uc_move_tiros |
                         wire_select_mux_pos_tiro_uc_registra_tiro),
                         
    .select_mux_coor_tiro(wire_select_mux_coor_tiro_uc_move_tiros),
    .select_soma_sub_tiro(wire_select_soma_sub_uc_move_tiros),
    .enable_reg_nave(),
    .reset_reg_nave(),
    .enable_mem_tiro(wire_enable_mem_tiro_uc_move_tiros |
                    wire_enable_mem_tiro_uc_registra_tiro),
    .enable_load_tiro(wire_enable_load_tiro_uc_compara_tiros_e_asteroides |
                      wire_enable_load_tiro_uc_move_tiros |
                      wire_enable_load_tiro_uc_registra_tiro),
    .aste_coor_x(wire_aste_coor_x),
    .aste_coor_y(wire_aste_coor_y),
    // .new_load_tiro(wire_new_loaded_tiro_uc_compara_tiros_e_asteroides |
    //                wire_new_loaded_tiro_uc_move_tiros |
    //                wire_new_loaded_tiro_uc_registra_tiro),
    .new_load_tiro(wire_new_loaded_tiro_uc_registra_tiro),
    .opcode_registra_tiro(wire_opcode_mux_out),
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

wire [3:0] wire_quantidade_vidas;
assign db_vidas = wire_quantidade_vidas;
decrementador #(4) decrementador( 
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


 contador_m #(2, 4) incrementacoes_tiro(
   .clock(clock),
   .zera_as(wire_reset_contador_tiro_uc_coordena_asteroides_tiros),
   .zera_s(1'b0),
   .conta(wire_conta_contador_tiro_uc_coordena_asteroides_tiros),
   .Q(),
   .fim(wire_rco_contador_tiro_quantas_incrementacoes),
   .meio()
  );



 contador_m #(2, 4) incrementacoes_asteroides(
   .clock(clock),
   .zera_as(wire_reset_contador_asteroides_uc_coordena_asteroides_tiros),
   .zera_s(1'b0),
   .conta(wire_conta_contador_asteroides_uc_coordena_asteroides_tiros),
   .Q(),
   .fim(wire_rco_contador_asteroides_quantas_incrementacoes),
   .meio()
  );

    
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


wire jogada_up;
wire jogada_down;
wire jogada_right;
wire jogada_left;
wire jogada_especial;
wire jogada_tiro;

or (wire_ocorreu_jogada, jogada_up, jogada_down, jogada_right, jogada_left, jogada_especial, jogada_tiro);

mux_reg_jogada mux_jogada(
    .select_mux_jogada (wire_saida_reg_jogada[5:2]),
    /* output */
    .saida_mux       (wire_opcode_mux_out)
);


edge_detector edge_detector_jogada_up(
    .clock(clock),
    .reset(1'b0),
    .sinal(chaves[0]),
    .pulso(jogada_up)
);

edge_detector edge_detector_jogada_down(
    .clock(clock),
    .reset(1'b0),
    .sinal(chaves[1]),
    .pulso(jogada_down)
);

edge_detector edge_detector_jogada_right(
    .clock(clock),
    .reset(1'b0),
    .sinal(chaves[2]),
    .pulso(jogada_right)
);

edge_detector edge_detector_jogada_left(
    .clock(clock),
    .reset(1'b0),
    .sinal(chaves[3]),
    .pulso(jogada_left)
);

edge_detector edge_detector_jogada_especial(
    .clock(clock),
    .reset(1'b0),
    .sinal(chaves[4]),
    .pulso(jogada_especial)
);

edge_detector edge_detector_jogada_tiro(
    .clock(clock),
    .reset(1'b0),
    .sinal(chaves[5]),
    .pulso(jogada_tiro)
);

edge_detector edge_detector_tiro(
    .clock(clock),
    .reset(1'b0),
    .sinal(wire_saida_reg_jogada[0]),
    .pulso(wire_ocorreu_tiro)
);




endmodule
