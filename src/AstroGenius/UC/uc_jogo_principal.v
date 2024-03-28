/*
*       Unidade de controle responsável pelo jogo principal, essa unidade tem a maior hierarquia
*       entre as unidades de controles. Ela registra a jogada, e inicializa a operação das unidades de controles:
*       coordena_asteroides_tiros.v, uc_registra_tiros.v, e uc_registra_especial.v
*
*/
module uc_jogo_principal (
        input clock,
        input iniciar,
        input reset,
        input vidas,
        input fim_movimentacao_asteroides_e_tiros, 
        input fim_registra_tiros,
        input fim_registra_especial, 
        input ocorreu_tiro,
        input ocorreu_jogada,
        input ocorreu_especial, 
        input tiro,      
        input especial, 
        input rco_intervalo_especial,
        output reg enable_reg_jogada,
        output reg reset_reg_jogada, 
        output reg inicia_registra_tiros,
        output reg inicia_registra_especial, 
        output reg inicia_movimentacao_asteroides_e_tiros, 
        output reg reset_contador_asteroides,
        output reg reset_contador_tiro,
        output reg reset_contador_vidas,
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

/* Variáveis de estado */
        reg [4:0] estado_atual, proximo_estado;

        /* Memória de estado */
        always @(posedge clock or posedge reset) begin
                if (reset)
                        estado_atual <= inicial;
                else
                        estado_atual <= proximo_estado;
        end

        /* Mudança de estados */
        always @* begin
        case (estado_atual)
                inicial:              proximo_estado = iniciar ? inicializa_elementos : inicial;                                 
                inicializa_elementos: proximo_estado = espera_jogada;
                espera_jogada:        proximo_estado = ~vidas ? fim_jogo :  
                                                        (ocorreu_jogada)  ? registra_jogada : espera_jogada;
                registra_jogada:      proximo_estado = espera_salvamento;
                espera_salvamento:    proximo_estado = espera_salvamento2; 
                espera_salvamento2: proximo_estado   = ~vidas ? fim_jogo : 
                                                        (ocorreu_tiro || (ocorreu_especial  && rco_intervalo_especial))  ? termina_movimentacao_asteroides_e_tiros : espera_jogada;
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

    /* Lógica de saída (maquina Moore) */
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
        reset_contador_vidas      = (estado_atual == inicializa_elementos  ||
                                     estado_atual == fim_jogo)             ? 1'b1 : 1'b0;
        enable_reg_jogada         = (estado_atual == registra_jogada)      ? 1'b1 : 1'b0;
        pronto                    = (estado_atual == fim_jogo)             ? 1'b1 : 1'b0;
        inicia_registra_tiros     = (estado_atual == inicia_state_registra_tiros) ? 1'b1 : 1'b0;
        inicia_registra_especial  = (estado_atual == inicia_state_registra_especial) ? 1'b1 : 1'b0;
        termina                   = (estado_atual == termina_movimentacao_asteroides_e_tiros) ? 1'b1 : 1'b0;
        inicia_movimentacao_asteroides_e_tiros = (estado_atual == espera_jogada) ? 1'b1 : 1'b0;

        /* Saída de depuração (estado) */
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