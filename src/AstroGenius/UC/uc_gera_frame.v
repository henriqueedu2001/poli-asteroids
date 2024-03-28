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
