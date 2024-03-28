/*

*   Unidade de controle utilzada para coordenar o movimento, comparação de asteroides 
*   e tiros e de coordenar a geração de asteroides, ela é pausada quando "instância" outras unidades
*
*/

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
    output reg gera_frame,
    output reg pausar_renderizacao, 
    output reg gera_asteroide, 
    output reg reset_gerador_random,
    output reg [4:0] db_estado_coordena_asteroides_tiros

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
            inicio:                                      proximo_estado = inicia_gera_aste;
            inicia_gera_aste:                            proximo_estado = espera_gera_aste;
            espera_gera_aste:                            proximo_estado = fim_gera_asteroide ? espera : espera_gera_aste;
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
            inicia_gera_frame:                           proximo_estado = espera_gera_frame; 
            espera_gera_frame:                           proximo_estado = fim_gera_frame ? fim_movimentacao : espera_gera_frame; 
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




