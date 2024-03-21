
module uc_registra_tiro (
        

);

        /* declaração dos estados dessa UC */
        parameter inicial                  = 4'b0000; // 0
        parameter espera                   = 4'b0001; // 1
        parameter zera_contadores          = 4'b0010; // 2
        parameter verifica_loaded_tiro     = 4'b0011; // 3
        parameter salva                    = 4'b0100; // 4


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

                default:                  proximo_estado = inicial;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin

        // Saída de depuração (estado)
        case (estado_atual)
            inicial:                  db_estado_registra_tiro = 4'b0000; // 0
            default:                  db_estado_registra_tiro = 4'b0000;
        endcase
    end








endmodule
