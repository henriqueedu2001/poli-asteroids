
module uc_renderiza (
        
);

        /* declaração dos estados dessa UC */
        parameter inicial                 = 5'b00000; // 0
        parameter menu_principal          = 5'b00001; // 1
        parameter registrar_iniciar_jogo  = 5'b00010; // 2
        parameter envia_dados_iniciar     = 5'b00011; // 3
        parameter espera_envia_iniciar    = 5'b00100; // 4
        parameter inica_jogo              = 5'b00101; // 5
        parameter espera_jogo             = 5'b00110; // 6
        parameter tela_final              = 5'b00111; // 7
        
        parameter erro                     = 5'b11111; // F


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
                inicial:                  proximo_estado = zera_contador;
                

                default:                  proximo_estado = erro;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin

        
        // Saída de depuração (estado)
        case (estado_atual)
                
                default:                 db_estado_uc_renderiza = 4'b0000;
        endcase
    end








endmodule
