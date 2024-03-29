
module uc_renderiza (
        input clock,
        input reset,
        input enviar_dados,
        input 
        );

        /* declaração dos estados dessa UC */
        parameter inicial                         = 6'b000000; // 0
        parameter espera                          = 6'b000001; // 1
        parameter zera_contadores                 = 6'b000010; // 2
        parameter inicia_envio_de_pontuacao       = 6'b000011; // 3
        parameter espera_envio_de_pontuacao       = 6'b000100; // 4
        parameter envio_opcode_nave               = 6'b000101; // 5
        parameter inicia_envio_opcode_nave        = 6'b000110; // 6
        parameter espera_envio_opcode_nave        = 6'b000111; // 7
        parameter envia_posicao_aste              = 6'b001000; // 8
        parameter inicia_envia_posicao_aste       = 6'b001001; // 9
        parameter espera_envia_posicao_aste       = 6'b001010; // 10
        parameter verifica_rco_aste               = 6'b001011; // 11
        parameter incrementa_contador_asteroides  = 6'b001100; // 12
        parameter espera_mem_aste                 = 6'b001101; // 13
        parameter envia_opcode_aste               = 6'b001110; // 14
        parameter inicia_envia_opcode_aste        = 6'b001111; // 15
        parameter espera_envia_opcode_aste        = 6'b010000; // 16
        parameter verifica_rco_contador_byte_opcode_aste = 6'b010001; // 17
        parameter incrementa_contador_byte_opcode_aste = 6'b010010; // 18
        parameter envia_posicao_tiros             = 6'b010011; // 19
        parameter inicia_envia_posicao_tiros      = 6'b010100; // 20
        parameter espera_envia_posicao_tiros      = 6'b010101; // 21
        parameter verifica_rco_tiro               = 6'b010110; // 22
        parameter incrementa_contador_tiros       = 6'b010111; // 23
        parameter espera_mem_tiros                = 6'b011000; // 24
        parameter envia_opcode_tiro               = 6'b011001; // 25
        parameter inicia_envia_opcode_tiro        = 6'b011010; // 26
        parameter espera_envia_opcode_tiro        = 6'b011011; // 27 
        parameter verifica_rco_contador_byte_opcde_tiro = 6'b011100; // 28
        parameter incrementa_contador_byte_opcode_tiro = 6'b011101; // 29
        parameter envia_jogada_especial            = 6'b011110; // 30
        parameter inicia_envia_jogada_especial     = 6'b011111; // 31 
        parameter espera_envia_jogada_especial     = 6'b100000; // 32 
        parameter inicia_envio_de_rodape           = 6'b100001; // 33
        parameter espera_envio_de_rodape           = 6'b100010; // 34
        parameter verifica_rco_contador_rodape     = 6'b100011; // 35
        parameter incrementa_contador_rodape       = 6'b100100; // 36
        parameter sinaliza                         = 6'b100101; // 37
        parameter erro                             = 6'b111111; // 64

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
                espera:                   proximo_estado = iniciar_envio_de_dados ? zera_contadores : espera;
                zera_contadores:          proximo_estado = inicia_envio_de_pontuacao;
                inicia_envio_de_pontuacao: proximo_estado = espera_envio_de_pontuacao;
                espera_envio_de_pontuacao: proximo_estado = fim_envio_de_pontuacao ? envio_opcode_nave : espera_envio_de_pontuacao;
                envio_opcode_nave:      proximo_estado = inicia_envio_opcode_nave;
                inicio_envio_opcode_nave: proximo_estado = espera_envio_opcode_nave;
                espera_envio_opcode_nave: proximo_estado = fim_envio_opcode_nave ? envia_posicao_nave : espera_envio_opcode_nave;
                envia_posicao_nave:       proximo_estado = inicia_envio_posicao_nave;
                inicia_envio_posicao_nave: proximo_estado = espera_envio_posicao_nave;
                espera_envio_posicao_nave: proximo_estado = fim_envio_posicao_nave ? envia_posicao_aste : espera_envio_posicao_nave;
                envia_posicao_aste:       proximo_estado = inicia_envia_posicao_aste;
                espera_envia_posicao_aste: proximo_estado = espera_envia_posicao_aste;
                espera_envia_posicao_aste: proximo_estado = fim_envia_posicao_aste ? verifica_rco_aste : espera_envia_posicao_aste;
                verifica_rco_aste:        proximo_estado = rco_contador_aste ? incrementa_contador_asteroides;
                incrementa_contador_asteroides: proximo_estado = espera_mem_aste;
                espera_mem_aste


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
                default:                 db_estado_uc_renderiza = 4'b0000;
        endcase
    end








endmodule
