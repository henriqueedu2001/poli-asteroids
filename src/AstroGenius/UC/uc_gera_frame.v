
module uc_registra_tiro (
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

        output reg db_estado_uc_registra_tiro
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
        parameter incrementa_tiro            = 4'b1011; // 10
        parameter sinaliza                   = 4'b1100; // 11
        parameter verifica_rco_tiro          = 4'b1101; // 12



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
                verifica_rco_asteroide:   proximo_estado = rco_contador_asteroides ? verifica_loaded_tiro : incrementa_asteroides;
                incrementa_asteroides:    proximo_estado = verifica_loaded_asteroide;

                salva_aste:               proximo_estado = verifica_rco_asteroide;

                verifica_loaded_tiro:     proximo_estado = loaded_tiro ? salva_tiro : verifica_rco_tiro;
                verifica_rco_tiro:        proximo_estado = rco_contador_tiro ? sinaliza : incrementa_tiro;
                default:                  proximo_estado = inicial;
        endcase 
    end

    // Lógica de saída (maquina Moore)
    always @* begin
        reset_contador_tiro = (estado_atual == reseta_contador) ? 1'b1 : 1'b0;
        reset_contador_asteroide = (estado_atual == reseta_contador) ? 1'b1 : 1'b0;
        clear_mem_frame = (estado_atual == verifica_loaded_asteroide) ? 1'b1 : 1'b0;
        enable_mem_aste = (estado_atual == salva_aste) ? 1'b1 : 1'b0;
        salva_tiro = (estado_atual == salva_tiro) ? 1'b1 : 1'b0;
        conta_contador_tiro = (estado_atual == incrementa_tiro) ? 1'b1 : 1'b0;
        conta_contador_aste = (estado_atual -- incrementa_asteroides) ? 1'b1 : 1'b0;
        fim_gera_frame = (estado_atual == sinaliza) ? 1'b1 : 1'b0;


        // Saída de depuração (estado)
        case (estado_atual)
        inicial:                      db_estado_uc_registra_tiro  = 4'b0000; // 0
        espera:                       db_estado_uc_registra_tiro = 4'b0001; // 1
        reseta_contadores:            db_estado_uc_registra_tiro = 4'b0010; // 2
        verifica_loaded_asteroide:    db_estado_uc_registra_tiro = 4'b0011; // 3
        salva_aste:                   db_estado_uc_registra_tiro = 4'b0100; // 4
        verifica_rco_asteroide:       db_estado_uc_registra_tiro = 4'b0101; // 5
        incrementa_asteroides:        db_estado_uc_registra_tiro = 4'b0110; // 6
        verifica_loaded_tiro:         db_estado_uc_registra_tiro = 4'b0111; // 7
        salva_tiro:                   db_estado_uc_registra_tiro = 4'b1000; // 8
        incrementa_tiro:              db_estado_uc_registra_tiro = 4'b1011; // 10
        sinaliza:                     db_estado_uc_registra_tiro = 4'b1100; // 11
        verifica_rco_tiro:            db_estado_uc_registra_tiro = 4'b1101; // 12
            default:                  db_estado_uc_registra_tiro = 4'b1111;
        endcase
    end








endmodule
