/*
        Unidade de controle responsável por simular o menu do jogo, ela envia a proxima tela a 
        ser renderizada pelo computador, e com essa informação o algoritmo de renderização em python
        consegue realizar a tela. Os seletores desse menu são os botões tiro e especial.

*/
module uc_menu (
        /*input*/
        input reset,
        input clock,
        input ocorreu_jogada,
        input tiro,
        input especial,
        input fim_envia_dados,
        input pronto,
        /*output*/
        output reg reset_reg_jogada,
        output reg enable_reg_jogada,
        output reg envia_dados,
        output reg iniciar,
        output reg jogo_base_em_andamento,
        output reg reset_jogo_base,
        output reg [7:0] tela_renderizada,
        output reg [4:0] db_estado_uc_menu
);

        /* declaração dos estados dessa UC */
        parameter inicial                                = 5'b00000; // 0
        parameter menu_principal                         = 5'b00001; // 1
        parameter registra_jogada_menu_principal         = 5'b00010; // 2
        parameter envia_dados_menu_principal_tiro        = 5'b00011; // 3
        parameter espera_envia_menu_principal_tiro       = 5'b00100; // 4
        parameter iniciar_jogo                           = 5'b00101; // 5
        parameter espera_jogo                            = 5'b00110; // 6
        parameter tela_final                             = 5'b00111; // 7
        parameter registra_jogada_tela_final             = 5'b01000; // 8
        parameter envia_dados_tela_final_tiro            = 5'b01001; // 9
        parameter espera_envia_tela_final_tiro           = 5'b01010; // 10
        parameter registra_pontuacao                     = 5'b01011; // 11
        parameter registra_jogada_registra_pontuacao     = 5'b01100; // 12
        parameter envia_dados_registra_pontuacao         = 5'b01101; // 13
        parameter espera_envia_pontuacao                 = 5'b01110; // 14
        parameter envia_dados_menu_principal_especial    = 5'b01111; // 15
        parameter espera_envia_menu_principal_especial   = 5'b10000; // 16
        parameter ver_pontuacao                          = 5'b10001; // 17
        parameter registra_jogada_ver_pontuacao          = 5'b10010; // 18
        parameter envia_dados_ver_pontuacao              = 5'b10011; // 19
        parameter espera_envia_dados_ver_pontuacao       = 5'b10100; // 20
        parameter envia_dados_tela_final_especial        = 5'b10101; // 21
        parameter espera_envia_dados_tela_final_especial = 5'b10110; // 22
        parameter aux_registra_jogada_menu_principal     = 5'b10111; // 23
        parameter aux_registra_jogada_tela_final         = 5'b11000; // 24
        parameter aux_registra_jogada_registra_pontuacao = 5'b11001; // 25
        parameter aux_registra_jogada_ver_pontuacao      = 5'b11010; // 26
        parameter reinicia_jogo_base                     = 5'b11011; // 27
        parameter erro                                   = 5'b11111; // F

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
                inicial:                                proximo_estado = menu_principal;
                menu_principal:                         proximo_estado = ocorreu_jogada ? registra_jogada_menu_principal: menu_principal;
                registra_jogada_menu_principal:         proximo_estado = aux_registra_jogada_menu_principal;
                aux_registra_jogada_menu_principal:     proximo_estado = tiro ? envia_dados_menu_principal_tiro : envia_dados_menu_principal_especial;
                envia_dados_menu_principal_tiro:        proximo_estado = espera_envia_menu_principal_tiro;
                espera_envia_menu_principal_tiro:       proximo_estado = fim_envia_dados ? reinicia_jogo_base : espera_envia_menu_principal_tiro;
                reinicia_jogo_base:                     proximo_estado = iniciar_jogo;
                iniciar_jogo:                           proximo_estado = espera_jogo;
                espera_jogo:                            proximo_estado = pronto ? tela_final : espera_jogo;
                tela_final:                             proximo_estado = ocorreu_jogada ? registra_jogada_tela_final : tela_final;
                registra_jogada_tela_final:             proximo_estado = aux_registra_jogada_tela_final;
                aux_registra_jogada_tela_final:         proximo_estado = tiro ? envia_dados_tela_final_tiro : envia_dados_tela_final_especial;
                envia_dados_tela_final_tiro:            proximo_estado = espera_envia_tela_final_tiro;                
                espera_envia_tela_final_tiro:           proximo_estado = fim_envia_dados ? registra_pontuacao : espera_envia_tela_final_tiro;
                registra_pontuacao:                     proximo_estado = ocorreu_jogada ? registra_jogada_registra_pontuacao : registra_pontuacao;
                registra_jogada_registra_pontuacao:     proximo_estado = aux_registra_jogada_registra_pontuacao;
                aux_registra_jogada_registra_pontuacao: proximo_estado = tiro ? envia_dados_registra_pontuacao : registra_pontuacao;
                envia_dados_registra_pontuacao:         proximo_estado = espera_envia_pontuacao;
                espera_envia_pontuacao:                 proximo_estado = fim_envia_dados ? menu_principal : espera_envia_pontuacao;
                envia_dados_ver_pontuacao:              proximo_estado = espera_envia_dados_ver_pontuacao;
                espera_envia_dados_ver_pontuacao:       proximo_estado = fim_envia_dados ? menu_principal : espera_envia_dados_ver_pontuacao;
                envia_dados_menu_principal_especial:    proximo_estado = espera_envia_menu_principal_especial;
                espera_envia_menu_principal_especial:   proximo_estado = fim_envia_dados ? ver_pontuacao : espera_envia_menu_principal_especial;
                ver_pontuacao:                          proximo_estado = ocorreu_jogada ? registra_jogada_ver_pontuacao : ver_pontuacao;
                registra_jogada_ver_pontuacao:          proximo_estado = aux_registra_jogada_ver_pontuacao;
                aux_registra_jogada_ver_pontuacao:      proximo_estado = especial ? envia_dados_ver_pontuacao : ver_pontuacao;
                default:                                proximo_estado = erro;
        endcase
    end
//     espera_envia_dados_ver_pontuacao
    // Lógica de saída (maquina Moore)
    always @* begin
        reset_reg_jogada  = (estado_atual == inicial)          ? 1'b1 : 1'b0;
        iniciar           = (estado_atual == iniciar_jogo)     ? 1'b1 : 1'b0;
        jogo_base_em_andamento = (estado_atual == iniciar_jogo || 
                                  estado_atual == espera_jogo  ) ? 1'b1 : 1'b0;
        enable_reg_jogada = (estado_atual == registra_jogada_menu_principal      ||
                             estado_atual == registra_jogada_tela_final          ||
                             estado_atual == registra_jogada_registra_pontuacao  ||
                             estado_atual == registra_jogada_ver_pontuacao       ) ? 1'b1 : 1'b0;
        envia_dados       = (estado_atual == envia_dados_menu_principal_tiro     ||
                             estado_atual == envia_dados_menu_principal_especial ||
                             estado_atual == envia_dados_tela_final_especial     ||
                             estado_atual == envia_dados_tela_final_tiro         ||
                             estado_atual == envia_dados_registra_pontuacao      ||
                             estado_atual == envia_dados_ver_pontuacao           ) ? 1'b1 : 1'b0;

        reset_jogo_base = (estado_atual == reinicia_jogo_base) ? 1'b1 : 1'b0;
        tela_renderizada = (estado_atual == menu_principal                       ||
                            estado_atual == registra_jogada_menu_principal       ||
                            estado_atual == aux_registra_jogada_menu_principal   )? 8'b11110000  : // menu principal
                           (estado_atual == envia_dados_menu_principal_tiro      ||
                            estado_atual == espera_envia_menu_principal_tiro     )? 8'b11110100  : //  tela do jogo em andamento (com os asteroides, tiros e a nave)
                           (estado_atual == envia_dados_menu_principal_especial  ||
                            estado_atual == espera_envia_menu_principal_especial) ? 8'b11110001  : // ver scores de outros jogadores

                           (estado_atual == ver_pontuacao                     ||
                            estado_atual == registra_jogada_ver_pontuacao     ||
                            estado_atual == aux_registra_jogada_ver_pontuacao ||
                            estado_atual == envia_dados_ver_pontuacao         ||
                            estado_atual == espera_envia_dados_ver_pontuacao ) ? 8'b11110000  : // menu principal

                           (estado_atual == tela_final                       || 
                            estado_atual == registra_jogada_tela_final       || 
                            estado_atual == aux_registra_jogada_tela_final   )? 8'b11110010  : // tela de game over
                           (estado_atual == envia_dados_tela_final_tiro      || 
                            estado_atual == espera_envia_tela_final_tiro     )? 8'b11110011 : // tela de registrar a pontuação
                           (estado_atual == envia_dados_tela_final_especial  ||
                            estado_atual == espera_envia_dados_tela_final_especial) ? 8'b11110000 : // menu principal

                           (estado_atual == envia_dados_registra_pontuacao         ||
                            estado_atual == espera_envia_pontuacao                 ) ? 8'b11110000   /*menu principal*/ : 8'b11110000 ;
                   

        // Saída de depuração (estado)
        case (estado_atual)
                inicial:                                db_estado_uc_menu = 5'b00000; // 0
                menu_principal:                         db_estado_uc_menu = 5'b00001; // 1
                registra_jogada_menu_principal:         db_estado_uc_menu = 5'b00010; // 2
                envia_dados_menu_principal_tiro:        db_estado_uc_menu = 5'b00011; // 3
                espera_envia_menu_principal_tiro:       db_estado_uc_menu = 5'b00100; // 4
                iniciar_jogo:                           db_estado_uc_menu = 5'b00101; // 5
                espera_jogo:                            db_estado_uc_menu = 5'b00110; // 6
                tela_final:                             db_estado_uc_menu = 5'b00111; // 7
                registra_jogada_tela_final:             db_estado_uc_menu = 5'b01000; // 8
                envia_dados_tela_final_tiro:            db_estado_uc_menu = 5'b01001; // 9
                espera_envia_tela_final_tiro:           db_estado_uc_menu = 5'b01010; // 10
                registra_pontuacao:                     db_estado_uc_menu = 5'b01011; // 11
                registra_jogada_registra_pontuacao:     db_estado_uc_menu = 5'b01100; // 12
                envia_dados_registra_pontuacao:         db_estado_uc_menu = 5'b01101; // 13
                espera_envia_pontuacao:                 db_estado_uc_menu = 5'b01110; // 14
                envia_dados_menu_principal_especial:    db_estado_uc_menu = 5'b01111; // 15
                espera_envia_menu_principal_especial:   db_estado_uc_menu = 5'b10000; // 16
                ver_pontuacao:                          db_estado_uc_menu = 5'b10001; // 17
                registra_jogada_ver_pontuacao:          db_estado_uc_menu = 5'b10010; // 18
                envia_dados_ver_pontuacao:              db_estado_uc_menu = 5'b10011; // 19
                espera_envia_dados_ver_pontuacao:       db_estado_uc_menu = 5'b10100; // 20
                envia_dados_tela_final_especial:        db_estado_uc_menu = 5'b10101; // 21
                espera_envia_dados_tela_final_especial: db_estado_uc_menu = 5'b10110; // 22
                aux_registra_jogada_menu_principal:     db_estado_uc_menu = 5'b10111; // 23
                aux_registra_jogada_tela_final:         db_estado_uc_menu = 5'b11000; // 24
                aux_registra_jogada_registra_pontuacao: db_estado_uc_menu = 5'b11001; // 25
                aux_registra_jogada_ver_pontuacao:      db_estado_uc_menu = 5'b11010; // 26
                reinicia_jogo_base:                     db_estado_uc_menu = 5'b11011; // 27
        default:                                        db_estado_uc_menu = 5'b11111; // erro
        endcase
    end
endmodule
