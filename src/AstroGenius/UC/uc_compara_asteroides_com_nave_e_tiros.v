/*
*   Unidade de controle utilzada para comparar somente a posição de tiros e de asteroides,
*   essa unidade de controle é chamada quando ocorre a operação de Incrementar a Posição dos Tiros.
*   Primeiro é percorrido a memoria de tiros e a posição de cada tiro é comparado com a posição de 
*   todos os asteroides renderizados e, quando iguais, a posição dos tiros e dos asteroides são desrenderizados
*
*/

module uc_compara_asteroides_com_nave_e_tiros (
        /*input*/
        input clock,
        input reset,
        input iniciar_comparacao_tiros_nave_asteroides,
        input posicao_asteroide_igual_nave,
        input ha_vidas,
        input rco_contador_asteroides,
        input fim_compara_tiros_e_asteroides,
        input loaded_asteroide,
        input destruido_asteroide,
        /*output*/
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
            
            // decrementa_vida:                     proximo_estado = ha_vidas ? destroi_asteroide : fim_comparacao;
            decrementa_vida:                     proximo_estado = destroi_asteroide;
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

        reset_contador_asteroides = (estado_atual == reset_contador    )? 1'b1 : 1'b0;
        enable_decrementador      = (estado_atual == decrementa_vida   )? 1'b1 : 1'b0;
        new_loaded_asteroide      = (estado_atual == destroi_asteroide ||
                                     estado_atual == salva_destruicao  )? 1'b0 : 1'b1;
        new_destruido_asteroide   = (estado_atual == destroi_asteroide ||
                                     estado_atual == salva_destruicao  )? 1'b1 : 1'b0;
        enable_load_asteroide      = (estado_atual == salva_destruicao )? 1'b1 : 1'b0;
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

