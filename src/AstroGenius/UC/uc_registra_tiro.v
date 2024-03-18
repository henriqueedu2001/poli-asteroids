
module uc_registra_tiro (
        input clock                    ,
        input registra_tiro            , // entrada que inicia a máquina de estados
        input reset                    ,
        input loaded_tiro              ,
        input rco_contador_tiro        ,
        output reg enable_mem_tiro      , // enable da memoria de tiros
        output reg enable_mem_loaded      , // enable da memoria de tiros
        output reg new_load             ,
        //contador
        output reg clear_contador_tiro  , // clear do contador que aponta para a posição do tiro na memoria
        output reg conta_contador_tiro  , // conta do contador que aponta para a posição do tiro na memoria

        output reg [1:0] select_mux_pos , // mux que seleciona a posição que será salva na memoria (salva a posição da nave e o opcode)
        output reg tiro_registrado      , // saida final que indica o fim da operação registra tiro

        output reg [3:0] db_estado_registra_tiro

);



        /* declaração dos estados dessa UC */
        parameter [3:0] inicial                  = 4'b0000;
        parameter [3:0] espera                   = 4'b0001;
        parameter [3:0] zera_contador            = 4'b0010;
        parameter [3:0] verifica                 = 4'b0011;
        parameter [3:0] incrementa_contador_tiro = 4'b0100;
        parameter [3:0] salva_tiro               = 4'b0101;
        parameter [3:0] sinaliza                 = 4'b0110;
        parameter [3:0] aux                      = 4'b0111;
        // parameter [3:0] inicial = 4'b1000;
        // parameter [3:0] inicial = 4'b1001;
        // parameter [3:0] inicial = 4'b1010;
        // parameter [3:0] inicial = 4'b1011;
        // parameter [3:0] inicial = 4'b1100;
        // parameter [3:0] inicial = 4'b1101;
        // parameter [3:0] inicial = 4'b1110;
        // parameter [3:0] inicial = 4'b1111;

        // Variáveis de estado
        reg [3:0] Eatual, Eprox;


        // Memória de estado
        always @(posedge clock or posedge reset) begin
                if (reset)
                        Eatual <= inicial;
                else
                        Eatual <= Eprox;
        end

        // mudança de estados
        always @* begin
        case (Eatual)
                inicial:        Eprox = espera;
                espera:         Eprox = registra_tiro ? zera_contador : espera;
                zera_contador:  Eprox = verifica;
                verifica:       Eprox = (loaded_tiro && ~rco_contador_tiro) ? incrementa_contador_tiro : 
                                        (loaded_tiro && rco_contador_tiro)  ? sinaliza :
                                        (~loaded_tiro)                      ? salva_tiro :  verifica;
                incrementa_contador_tiro: Eprox = aux;
                aux:            Eprox = verifica;
                salva_tiro:     Eprox = sinaliza;
                sinaliza:       Eprox = espera;
                default:        Eprox = inicial;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin

        // zera_jogada    = (Eatual == inicial              || 
        //                   Eatual == inicializa_elementos || 
        //                   Eatual == inicio_da_rodada     ) ? 1'b1 : 1'b0;

        clear_contador_tiro = (Eatual == zera_contador)    ? 1'b1 : 1'b0;
        new_load            = (Eatual == salva_tiro) ? 1'b1 : 1'b0;
        enable_mem_tiro     = (Eatual == salva_tiro) ? 1'b1 : 1'b0;
        enable_mem_loaded   = (Eatual == salva_tiro) ? 1'b1 : 1'b0;
        select_mux_pos      = (Eatual == salva_tiro)    ? 2'b00 : 2'b11;   
        conta_contador_tiro = (Eatual == incrementa_contador_tiro) ? 1'b1 : 1'b0;
        tiro_registrado     = (Eatual == sinaliza)                 ? 1'b1 : 1'b0;




        // Saída de depuração (estado)
        case (Eatual)
            inicial:                  db_estado_registra_tiro = 4'b0000; // 0
            espera:                   db_estado_registra_tiro = 4'b0001; // 1
            zera_contador:            db_estado_registra_tiro = 4'b0010; // 2
            verifica:                 db_estado_registra_tiro = 4'b0011; // 3
            incrementa_contador_tiro: db_estado_registra_tiro = 4'b0100; // 4
            salva_tiro:               db_estado_registra_tiro = 4'b0101; // 5
            sinaliza:                 db_estado_registra_tiro = 4'b0110; // 6                    
            aux:                      db_estado_registra_tiro = 4'b0111; // 7
        //     ultima_rodada:        db_estado_registra_tiro = 4'b1000; // 8
        //     final_com_acertos:    db_estado_registra_tiro = 4'b1010; // A
        //     final_com_erro:       db_estado_registra_tiro = 4'b1110; // E
	//     final_com_timeout:    db_estado_registra_tiro = 4'b1111; // F
            default:              db_estado_registra_tiro = 4'b1101; // D
        endcase
    end








endmodule
