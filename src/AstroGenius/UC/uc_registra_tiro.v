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

