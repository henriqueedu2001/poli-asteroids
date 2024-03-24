
module uc_renderiza (
        input clock                    ,
        input reset                    ,
        input pausar_renderizacao      ,
        input rco_contador_frame       ,
        output reg reset_contador_frame,    
        output reg conta_contador_frame,    
        output reg [3:0] db_estado_uc_renderiza
);

        /* declaração dos estados dessa UC */
        parameter inicial                 = 4'b0000; // 0
        parameter zera_contador           = 4'b0001; // 1
        parameter conta_contador          = 4'b0010; // 2
        parameter pausado                 = 4'b0011; // 3
        // parameter incrementa_contador_tiro = 4'b0100; // 4
        // parameter salva_tiro               = 4'b0101; // 5
        // parameter sinaliza                 = 4'b0110; // 6
        // parameter aux                      = 4'b0111; // 7
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
                inicial:                  proximo_estado = zera_contador;
                zera_contador:            proximo_estado = pausar_renderizacao ? pausado : conta_contador;
                conta_contador:           proximo_estado = pausar_renderizacao ? pausado : 
                                                           (rco_contador_frame && ~pausar_renderizacao)? zera_contador : conta_contador;
                pausado:                  proximo_estado = pausar_renderizacao ? pausado : zera_contador;

                default:                  proximo_estado = erro;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin

        reset_contador_frame   = (estado_atual == zera_contador || estado_atual == inicial) ? 1'b1 : 1'b0;
        conta_contador_frame   = (estado_atual == conta_contador) ? 1'b1 : 1'b0;

        // Saída de depuração (estado)
        case (estado_atual)
                inicial:                 db_estado_uc_renderiza = 4'b0000; // 0
                zera_contador:           db_estado_uc_renderiza = 4'b0001; // 1
                conta_contador:          db_estado_uc_renderiza = 4'b0010; // 2
                pausado:                 db_estado_uc_renderiza = 4'b0011; // 3
                erro:                    db_estado_uc_renderiza = 4'b1111; // F
                default:                 db_estado_uc_renderiza = 4'b0000;
        endcase
    end








endmodule
