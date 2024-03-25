
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
