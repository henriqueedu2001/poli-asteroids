module uc_coordena_asteroides_tiros (
        input clock                    ,
        input reset                    ,
        input move_tiro_e_asteroides   , // sinal que inicia a máquina de estado
        input rco_contador_tiro        , // rco do contador (contador que conta quantas vezes as posições dos tiros serão incrementados)
        input rco_contador_asteroides  , 
        input fim_move_tiros           , // entrada que indica o fim da movimentação dos tiros
        input fim_move_asteroides      , // entrada que indica o fim da movimentação dos asteroides
        input fim_comparacao_asteroides_com_a_nave_e_tiros, // entrada que indica o fim da comparação dos tiros tiros, nave e asteroide
        input fim_comparacao_tiros_e_asteroides           , // entrada que indica o fim da comparação dos tiros tiros e asteroides
        // saidas para outras máquinas de estados de hierarquia menor 
        output reg movimenta_tiro                       , // saída que inicia a movimentação dos tiros
        output reg sinal_movimenta_asteroides                 , // saída que inicia a movimentação dos asteroides
        output reg sinal_compara_tiros_e_asteroides            , // saída que inicia a comparação dos tiros e asteroids
        output reg sinal_compara_asteroides_com_a_nave_e_tiro , // saída que inicia a comparação dos asteroids com tiros e nave
        //contadores 
        output reg conta_contador_tiro                  , // conta o contador de quantas vezes o tiro vai ser incrementado
        output reg reset_contador_tiro                  , // reset do contador de quantas vezes o tiro vai ser incrementado
        output reg conta_contador_asteroides            , // conta o contador de quantas vezes o asteroide vai ser incrementado
        output reg reset_contador_asteroides            , // reset do contador de quantas vezes o asteroide vai ser incrementado
        // saida para a máquina de estados principal
        output reg fim_move_tiro_e_asteroides,             // sinal que indica o fim da incrementação dos tiros e asteroides
        output reg [4:0] db_estado_coordena_asteroides_tiros
);

    parameter inicio                               = 5'b00000; // 0
    parameter espera                               = 5'b00001; // 1
    parameter reset_contadores                     = 5'b00010; // 2
    parameter compara_tiros_e_asteroides           = 5'b00011; // 3
    parameter move_tiros                           = 5'b00100; // 4
    parameter incrementa_contador_tiros            = 5'b00101; // 5
    parameter compara_asteroides_com_a_nave_e_tiro = 5'b00110; // 6
    parameter movimenta_asteroides                 = 5'b00111; // 7
    parameter incrementa_contador_asteroides       = 5'b01000; // 8
    parameter fim_movimentacao                     = 5'b01001; // 9
    parameter erro                                 = 5'b01111; // F


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
            inicio:                               proximo_estado = espera;
            espera:                               proximo_estado = move_tiro_e_asteroides ? reset_contadores : espera;
            reset_contadores:                     proximo_estado = compara_tiros_e_asteroides;
            compara_tiros_e_asteroides:           proximo_estado = (fim_comparacao_tiros_e_asteroides && rco_contador_tiro) ? compara_asteroides_com_a_nave_e_tiro :
                                                                   (fim_comparacao_tiros_e_asteroides && ~rco_contador_tiro) ? move_tiros : compara_tiros_e_asteroides;
            move_tiros:                           proximo_estado = fim_move_tiros ? incrementa_contador_tiros : move_tiros;
            incrementa_contador_tiros:            proximo_estado = compara_tiros_e_asteroides;
            compara_asteroides_com_a_nave_e_tiro: proximo_estado = (fim_comparacao_asteroides_com_a_nave_e_tiros && rco_contador_asteroides) ? fim_movimentacao :
                                                                   (fim_comparacao_asteroides_com_a_nave_e_tiros && ~rco_contador_asteroides) ? movimenta_asteroides :
                                                                   compara_asteroides_com_a_nave_e_tiro;
            movimenta_asteroides:                 proximo_estado = fim_move_asteroides ? incrementa_contador_asteroides : movimenta_asteroides;
            incrementa_contador_asteroides:       proximo_estado = compara_asteroides_com_a_nave_e_tiro;
            fim_movimentacao:                     proximo_estado = espera;
            default:               proximo_estado = inicio;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin
        reset_contador_tiro             =   (estado_atual == reset_contadores)               ? 1'b1 : 1'b0;
        reset_contador_asteroides       =   (estado_atual == reset_contadores)               ? 1'b1 : 1'b0;
        sinal_compara_tiros_e_asteroides=   (estado_atual == compara_tiros_e_asteroides)     ? 1'b1 : 1'b0;
        movimenta_tiro                  =   (estado_atual == move_tiros)                     ? 1'b1 : 1'b0;
        conta_contador_tiro             =   (estado_atual == incrementa_contador_tiros)      ? 1'b1 : 1'b0;
        sinal_movimenta_asteroides      =   (estado_atual == movimenta_asteroides)           ? 1'b1 : 1'b0;
        conta_contador_asteroides       =   (estado_atual == incrementa_contador_asteroides) ? 1'b1 : 1'b0;
        fim_move_tiro_e_asteroides      =   (estado_atual == fim_movimentacao)               ? 1'b1 : 1'b0;
        sinal_compara_asteroides_com_a_nave_e_tiro = (estado_atual == compara_asteroides_com_a_nave_e_tiro) ? 1'b1 : 1'b0;


        // Saída de depuração (estado)
        case (estado_atual)
            inicio:                               db_estado_coordena_asteroides_tiros = 5'b00000; // 0
            espera:                               db_estado_coordena_asteroides_tiros = 5'b00001; // 1
            reset_contadores:                     db_estado_coordena_asteroides_tiros = 5'b00010; // 2
            compara_tiros_e_asteroides:           db_estado_coordena_asteroides_tiros = 5'b00011; // 3
            move_tiros:                           db_estado_coordena_asteroides_tiros = 5'b00100; // 4
            incrementa_contador_tiros:            db_estado_coordena_asteroides_tiros = 5'b00101; // 5
            compara_asteroides_com_a_nave_e_tiro: db_estado_coordena_asteroides_tiros = 5'b00110; // 6
            movimenta_asteroides:                 db_estado_coordena_asteroides_tiros = 5'b00111; // 7
            incrementa_contador_asteroides:       db_estado_coordena_asteroides_tiros = 5'b01000; // 8
            fim_movimentacao:                     db_estado_coordena_asteroides_tiros = 5'b01001; // 9
            erro:                                 db_estado_coordena_asteroides_tiros = 5'b01111; // F  
            default:                              db_estado_coordena_asteroides_tiros = 5'b00000; 
        endcase
    end

endmodule




