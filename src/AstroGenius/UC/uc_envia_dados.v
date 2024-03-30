
module uc_envia_dados (
        input clock,
        input reset,
        input enviar_dados,
        input acabou_transmissao_uart_tx,
        input rco_contador_aste,
        input rco_contador_tiros,
        input rco_contador_byte_opcode,
        input rco_contador_rodape,

        output reg iniciar_transmissao_uart_tx,
        output reg enable_reg_opcode,
        output reg reset_reg_opcode,
        output reg conta_contador_byte_opcode,
        output reg reset_contador_byte_opcode,
        output reg conta_contador_mux_byte_enviar,
        output reg reset_contador_mux_byte_enviar,
        output reg conta_contador_aste,
        output reg reset_contador_aste,
        output reg conta_contador_tiro,
        output reg reset_contador_tiro,
        output reg conta_contador_rodape,
        output reg reset_contador_rodape,

        output reg terminou_de_enviar_dados,
        output reg esta_enviando_pos_asteroides,
        output reg [5:0] db_estado_uc_envia_dados
        );

        /* declaração dos estados dessa UC */
        parameter inicial                                = 6'b000000; // 0
        parameter espera                                 = 6'b000001; // 1
        parameter zera_contadores                        = 6'b000010; // 2
        parameter inicia_envio_de_pontuacao              = 6'b000011; // 3
        parameter espera_envio_de_pontuacao              = 6'b000100; // 4
        parameter envia_opcode_nave                      = 6'b000101; // 5
        parameter inicia_envia_opcode_nave               = 6'b000110; // 6
        parameter espera_envia_opcode_nave               = 6'b000111; // 7
        parameter envia_posicao_aste                     = 6'b001000; // 8
        parameter inicia_envia_posicao_aste              = 6'b001001; // 9
        parameter espera_envia_posicao_aste              = 6'b001010; // 10
        parameter verifica_rco_aste                      = 6'b001011; // 11
        parameter incrementa_contador_asteroides         = 6'b001100; // 12
        parameter espera_mem_aste                        = 6'b001101; // 13
        parameter envia_opcode_aste                      = 6'b001110; // 14
        parameter inicia_envia_opcode_aste               = 6'b001111; // 15
        parameter espera_envia_opcode_aste               = 6'b010000; // 16
        parameter verifica_rco_contador_byte_opcode_aste = 6'b010001; // 17
        parameter incrementa_contador_byte_opcode_aste   = 6'b010010; // 18
        parameter envia_posicao_tiros                    = 6'b010011; // 19
        parameter inicia_envia_posicao_tiros             = 6'b010100; // 20
        parameter espera_envia_posicao_tiros             = 6'b010101; // 21
        parameter verifica_rco_tiros                     = 6'b010110; // 22
        parameter incrementa_contador_tiros              = 6'b010111; // 23
        parameter espera_mem_tiros                       = 6'b011000; // 24
        parameter envia_opcode_tiro                      = 6'b011001; // 25
        parameter inicia_envia_opcode_tiro               = 6'b011010; // 26
        parameter espera_envia_opcode_tiro               = 6'b011011; // 27 
        parameter verifica_rco_contador_byte_opcode_tiro = 6'b011100; // 28
        parameter incrementa_contador_byte_opcode_tiro   = 6'b011101; // 29
        parameter envia_jogada_especial                  = 6'b011110; // 30
        parameter inicia_envia_jogada_especial           = 6'b011111; // 31 
        parameter espera_envia_jogada_especial           = 6'b100000; // 32 
        parameter envia_rodape                           = 6'b100001; // 33
        parameter inicia_envia_rodape                    = 6'b100010; // 34
        parameter espera_envia_rodape                    = 6'b100011; // 35
        parameter verifica_rco_contador_rodape           = 6'b100100; // 36
        parameter incrementa_contador_rodape             = 6'b100101; // 37
        parameter sinaliza                               = 6'b100110; // 38
        parameter erro                                   = 6'b111111; // 64

        // Variáveis de estado
        reg [5:0] estado_atual, proximo_estado;

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
                inicial:                   proximo_estado = espera;
                espera:                    proximo_estado = enviar_dados ? zera_contadores : espera;
                zera_contadores:           proximo_estado = inicia_envio_de_pontuacao;
                
                inicia_envio_de_pontuacao: proximo_estado = espera_envio_de_pontuacao;
                espera_envio_de_pontuacao: proximo_estado = acabou_transmissao_uart_tx ? envia_opcode_nave : espera_envio_de_pontuacao;
                
                envia_opcode_nave:         proximo_estado = inicia_envia_opcode_nave;
                inicia_envia_opcode_nave:  proximo_estado = espera_envia_opcode_nave;
                espera_envia_opcode_nave:  proximo_estado = acabou_transmissao_uart_tx ? envia_posicao_aste : espera_envia_opcode_nave;
                
                envia_posicao_aste:        proximo_estado = inicia_envia_posicao_aste;
                inicia_envia_posicao_aste: proximo_estado = espera_envia_posicao_aste;
                espera_envia_posicao_aste: proximo_estado = acabou_transmissao_uart_tx ? verifica_rco_aste : espera_envia_posicao_aste;
                verifica_rco_aste:         proximo_estado = rco_contador_aste ? envia_opcode_aste : incrementa_contador_asteroides;
                incrementa_contador_asteroides: proximo_estado = espera_mem_aste;
                espera_mem_aste:           proximo_estado = inicia_envia_posicao_aste;
                
                envia_opcode_aste:         proximo_estado = inicia_envia_opcode_aste;
                inicia_envia_opcode_aste:  proximo_estado = espera_envia_opcode_aste;
                espera_envia_opcode_aste:  proximo_estado = acabou_transmissao_uart_tx ? verifica_rco_contador_byte_opcode_aste : espera_envia_opcode_aste;
                verifica_rco_contador_byte_opcode_aste: proximo_estado = rco_contador_byte_opcode ? envia_posicao_tiros : incrementa_contador_byte_opcode_aste;
                incrementa_contador_byte_opcode_aste: proximo_estado = inicia_envia_opcode_aste;
                
                envia_posicao_tiros:        proximo_estado = inicia_envia_posicao_tiros;
                inicia_envia_posicao_tiros: proximo_estado = espera_envia_posicao_tiros;
                espera_envia_posicao_tiros: proximo_estado = acabou_transmissao_uart_tx ? verifica_rco_tiros : espera_envia_posicao_tiros;
                verifica_rco_tiros:         proximo_estado = rco_contador_tiros ? envia_opcode_tiro : incrementa_contador_tiros;
                incrementa_contador_tiros:  proximo_estado = espera_mem_tiros;
                espera_mem_tiros:           proximo_estado = inicia_envia_posicao_tiros;
                
                envia_opcode_tiro:          proximo_estado = inicia_envia_opcode_tiro;
                inicia_envia_opcode_tiro:   proximo_estado = espera_envia_opcode_tiro;
                espera_envia_opcode_tiro:   proximo_estado = acabou_transmissao_uart_tx ? verifica_rco_contador_byte_opcode_tiro : espera_envia_opcode_tiro;
                verifica_rco_contador_byte_opcode_tiro: proximo_estado = rco_contador_byte_opcode ? envia_jogada_especial : incrementa_contador_byte_opcode_tiro;
                incrementa_contador_byte_opcode_tiro: proximo_estado = inicia_envia_opcode_tiro;

                envia_jogada_especial:     proximo_estado = inicia_envia_jogada_especial;
                inicia_envia_jogada_especial: proximo_estado = espera_envia_jogada_especial;
                espera_envia_jogada_especial: proximo_estado = acabou_transmissao_uart_tx ? envia_rodape : espera_envia_jogada_especial;

                envia_rodape:                 proximo_estado = inicia_envia_rodape;
                inicia_envia_rodape:          proximo_estado = espera_envia_rodape;
                espera_envia_rodape:          proximo_estado = acabou_transmissao_uart_tx ? verifica_rco_contador_rodape : espera_envia_rodape;
                verifica_rco_contador_rodape: proximo_estado = rco_contador_rodape ? sinaliza : incrementa_contador_rodape;
                incrementa_contador_rodape:   proximo_estado = inicia_envia_rodape;
                sinaliza:                     proximo_estado = espera;
                default:                      proximo_estado = erro;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin
                iniciar_transmissao_uart_tx = (estado_atual == inicia_envio_de_pontuacao     ||
                                               estado_atual ==  inicia_envia_jogada_especial ||
                                               estado_atual ==  inicia_envia_opcode_aste     ||
                                               estado_atual == inicia_envia_opcode_nave      ||
                                               estado_atual == inicia_envia_opcode_tiro      ||
                                               estado_atual == inicia_envia_posicao_aste     ||
                                               estado_atual == inicia_envia_posicao_tiros    ||
                                               estado_atual == inicia_envia_rodape           ) ? 1'b1 : 1'b0; 
                enable_reg_opcode           = (estado_atual == inicia_envia_posicao_aste     ||
                                               estado_atual == inicia_envia_posicao_tiros    ) ? 1'b1 : 1'b0; 
                reset_reg_opcode            = (estado_atual == zera_contadores)                ? 1'b1 : 1'b0; 
                conta_contador_byte_opcode  = (estado_atual == incrementa_contador_byte_opcode_aste ||
                                               estado_atual == incrementa_contador_byte_opcode_tiro )      ? 1'b1 : 1'b0; 
                reset_contador_byte_opcode  = (estado_atual == zera_contadores || estado_atual == inicial) ? 1'b1 : 1'b0; 

                conta_contador_mux_byte_enviar = (estado_atual ==  envia_jogada_especial ||
                                                  estado_atual ==  envia_opcode_aste     ||
                                                  estado_atual == envia_opcode_nave      ||
                                                  estado_atual == envia_opcode_tiro      ||
                                                  estado_atual == envia_posicao_aste     ||
                                                  estado_atual == envia_posicao_tiros    ||
                                                  estado_atual == envia_rodape           ) ? 1'b1 : 1'b0; 

                reset_contador_mux_byte_enviar = (estado_atual == zera_contadores)                ? 1'b1 : 1'b0; 
                conta_contador_aste            = (estado_atual == incrementa_contador_asteroides) ? 1'b1 : 1'b0; 
                reset_contador_aste            = (estado_atual == zera_contadores)                ? 1'b1 : 1'b0; 
                conta_contador_tiro            = (estado_atual == incrementa_contador_tiros)      ? 1'b1: 1'b0; 
                reset_contador_tiro            = (estado_atual == zera_contadores)                ? 1'b1: 1'b0; 
                conta_contador_rodape          = (estado_atual == incrementa_contador_rodape)     ? 1'b1 : 1'b0; 
                reset_contador_rodape          = (estado_atual == zera_contadores)                ? 1'b1 : 1'b0; 

                esta_enviando_pos_asteroides   = (estado_atual == envia_posicao_tiros        ||  
                                                  estado_atual == inicia_envia_posicao_tiros ||
                                                  estado_atual == espera_envia_posicao_tiros || 
                                                  estado_atual == verifica_rco_tiros         || 
                                                  estado_atual == incrementa_contador_tiros  ||
                                                  estado_atual == espera_mem_tiros           )? 1'b1 : 1'b0;  
                                                  
                terminou_de_enviar_dados = (estado_atual == sinaliza)? 1'b1 : 1'b0;
                // Saída de depuração (estado)

        // Saída de depuração (estado)
        case (estado_atual)
                inicial:                                db_estado_uc_envia_dados = 6'b000000; // 0
                espera:                                 db_estado_uc_envia_dados = 6'b000001; // 1
                zera_contadores:                        db_estado_uc_envia_dados = 6'b000010; // 2
                inicia_envio_de_pontuacao:              db_estado_uc_envia_dados = 6'b000011; // 3
                espera_envio_de_pontuacao:              db_estado_uc_envia_dados = 6'b000100; // 4
                envia_opcode_nave:                      db_estado_uc_envia_dados = 6'b000101; // 5
                inicia_envia_opcode_nave:               db_estado_uc_envia_dados = 6'b000110; // 6
                espera_envia_opcode_nave:               db_estado_uc_envia_dados = 6'b000111; // 7
                envia_posicao_aste:                     db_estado_uc_envia_dados = 6'b001000; // 8
                inicia_envia_posicao_aste:              db_estado_uc_envia_dados = 6'b001001; // 9
                espera_envia_posicao_aste:              db_estado_uc_envia_dados = 6'b001010; // 10
                verifica_rco_aste:                      db_estado_uc_envia_dados = 6'b001011; // 11
                incrementa_contador_asteroides:         db_estado_uc_envia_dados = 6'b001100; // 12
                espera_mem_aste:                        db_estado_uc_envia_dados = 6'b001101; // 13
                envia_opcode_aste:                      db_estado_uc_envia_dados = 6'b001110; // 14
                inicia_envia_opcode_aste:               db_estado_uc_envia_dados = 6'b001111; // 15
                espera_envia_opcode_aste:               db_estado_uc_envia_dados = 6'b010000; // 16
                verifica_rco_contador_byte_opcode_aste: db_estado_uc_envia_dados = 6'b010001; // 17
                incrementa_contador_byte_opcode_aste:   db_estado_uc_envia_dados = 6'b010010; // 18
                envia_posicao_tiros:                    db_estado_uc_envia_dados = 6'b010011; // 19
                inicia_envia_posicao_tiros:             db_estado_uc_envia_dados = 6'b010100; // 20
                espera_envia_posicao_tiros:             db_estado_uc_envia_dados = 6'b010101; // 21
                verifica_rco_tiros:                     db_estado_uc_envia_dados = 6'b010110; // 22
                incrementa_contador_tiros:              db_estado_uc_envia_dados = 6'b010111; // 23
                espera_mem_tiros:                       db_estado_uc_envia_dados = 6'b011000; // 24
                envia_opcode_tiro:                      db_estado_uc_envia_dados = 6'b011001; // 25
                inicia_envia_opcode_tiro:               db_estado_uc_envia_dados = 6'b011010; // 26
                espera_envia_opcode_tiro:               db_estado_uc_envia_dados = 6'b011011; // 27 
                verifica_rco_contador_byte_opcode_tiro: db_estado_uc_envia_dados = 6'b011100; // 28
                incrementa_contador_byte_opcode_tiro:   db_estado_uc_envia_dados = 6'b011101; // 29
                envia_jogada_especial:                  db_estado_uc_envia_dados = 6'b011110; // 30
                inicia_envia_jogada_especial:           db_estado_uc_envia_dados = 6'b011111; // 31 
                espera_envia_jogada_especial:           db_estado_uc_envia_dados = 6'b100000; // 32 
                envia_rodape:                           db_estado_uc_envia_dados = 6'b100001; // 33
                inicia_envia_rodape:                    db_estado_uc_envia_dados = 6'b100010; // 34
                espera_envia_rodape:                    db_estado_uc_envia_dados = 6'b100011; // 35
                verifica_rco_contador_rodape:           db_estado_uc_envia_dados = 6'b100100; // 36
                incrementa_contador_rodape:             db_estado_uc_envia_dados = 6'b100101; // 37
                sinaliza:                               db_estado_uc_envia_dados = 6'b100110; // 38
                default:                                db_estado_uc_envia_dados = 6'b111111;
        endcase
    end








endmodule
