
module uc_registra_tiro (

        input clock                    ,
        input iniciar            , // entrada que inicia a máquina de estados
        input reset                    ,


        input fim_movimentacao_asteroides_e_tiros, // indica o fim da uc_coordena_asteroides_tiros.v
        input ocorreu_tiro,
        input ocorreu_jogada,

        // sinais do registrador
        output reg enable_reg_jogada,
        output reg reset_reg_jogada, 
        output reg acabou_vidas,
        output reg inicia_movimentacao_asteroides_e_tiros, // saída para o inicio da máquina de estados uc_coordena_asteroides_tiros.v
        
        // resets de outras máquinas de estados
        output reg reset_contador_asteroides,
        output reg reset_move_tiros,
        output reg reset_registra_tiros,

        output reg pronto


);




 /* declaração dos estados dessa UC */
        parameter [4:0] inicial                                 = 5'b00000;
        parameter [4:0] inicializa_elementos                    = 5'b00001;
        parameter [4:0] espera_jogada                           = 5'b00010;
        parameter [4:0] registra_jogada                         = 5'b00011;
        parameter [4:0] termina_movimentacao_asteroides_e_tiros = 5'b00100;
        parameter [4:0] registra_tiros                          = 5'b00101;
        parameter [4:0] fim_jogo                                = 5'b00110;



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
                inicial:              Eprox = inicializa_elementos;                                 
                inicializa_elementos: Eprox = espera_jogada;
                espera_jogada:   Eprox = ocorreu_jogada ? registra_jogada : espera_jogada;
                registra_jogada: Eprox = acabou_vidas ? fim_jogo : 
                                        ~acabou_vidas && ocorreu_tiro ? termina_movimentacao_asteroides_tiros :
                                        ~acabou_vidas && ~ocorreu_tiro ? espera_jogada : registra_jogada;
                



                
                                         
                termina_movimentacao_asteroides_e_tiros: Eprox =  
                registra_tiros:                           Eprox =                           
                fim_jogo: Eprox =                                 

        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin

        // zera_jogada    = (Eatual == inicial              || 
        //                   Eatual == inicializa_elementos || 
        //                   Eatual == inicio_da_rodada     ) ? 1'b1 : 1'b0;





        // Saída de depuração (estado)
        case (Eatual)
                inicial                                 : db_estado_registra_tiro = 5'b00000;
                inicializa_elementos                    : db_estado_registra_tiro = 5'b00001;
                espera_jogada                           : db_estado_registra_tiro = 5'b00010;
                registra_jogada                         : db_estado_registra_tiro = 5'b00011;
                termina_movimentacao_asteroides_e_tiros : db_estado_registra_tiro = 5'b00100;
                registra_tiros                          : db_estado_registra_tiro = 5'b00101;
                fim_jogo                                : db_estado_registra_tiro = 5'b00110;
                default:              db_estado_registra_tiro = 4'b1101; // D
        endcase
    end

endmodule