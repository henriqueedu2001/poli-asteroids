/* Esse unidade de controle realiza a movimentação dos asteroides de maneira muito similar
   a dos asteroides, onde é verificada cada posição da memoria dos asteroides para verificar
   se o mesmo está em jogo. Caso esteja, a próxima posição da memória é verificada até que todos
   os asteroides sejam verificados. Quando um asteroide está em jogo, o mesmo será movido, verificando
   o seu OPCODE para move-lo na direção correta.*/


module uc_move_asteroides (
        input clock,
        input movimenta_aste,
        input reset,
        input [1:0] opcode_aste,
        input loaded_aste,
        input rco_contador_aste,
        output reg [1:0] select_mux_pos_aste,   //seletor do mux da posição 
        output reg select_mux_coor_aste,  //seletor do mux da posição 
        output reg select_soma_sub,  
        output reg reset_contador_aste,
        output reg conta_contador_aste, 
        output reg reset_contador_movimenta_asteroide,
        output reg enable_mem_aste, // enable da memoria de tiros
        output reg movimentacao_concluida_aste, // sinal que indica o fim da movimentação dos tiros
        output reg [4:0] db_estado_move_aste

);

        parameter inicio                 = 5'b00000; // 0
        parameter espera                 = 5'b00001; // 1
        parameter reseta_contador        = 5'b00010; // 2
        parameter verifica_loaded        = 5'b00011; // 3
        parameter verifica_opcode        = 5'b00100; // 4
        parameter horizontal_crescente   = 5'b00101; // 5 
        parameter horizontal_decrescente = 5'b00110; // 6
        parameter vertical_crescente     = 5'b00111; // 7
        parameter vertical_decrescente   = 5'b01000; // 8
        parameter salva_posicao          = 5'b01001; // 9
        parameter incrementa_contador    = 5'b01010; // 10
        parameter aux                    = 5'b01011; // 11
        parameter sinaliza               = 5'b01110; // 12
        parameter erro                   = 5'b11111; // erro

// Variáveis de estado
        reg [4:0] estado_atual, proximo_estado;

        // Memória de estado
        always @(posedge clock or posedge reset) begin
                if (reset)
                        estado_atual <= inicio;
                else
                        estado_atual <= proximo_estado;
        end

        // mudança de estados
        always @* begin
        case (estado_atual) 
                inicio:                proximo_estado = espera;
                espera:                proximo_estado = movimenta_aste ? reseta_contador : espera;
                reseta_contador:       proximo_estado = verifica_loaded;
                verifica_loaded:       proximo_estado = loaded_aste ? verifica_opcode :
                                                        (~loaded_aste && rco_contador_aste) ? sinaliza :
                                                        (~loaded_aste && ~rco_contador_aste) ? incrementa_contador : erro;
                verifica_opcode:        proximo_estado = opcode_aste == 2'b00 ? horizontal_crescente : 
                                                         opcode_aste == 2'b01 ? horizontal_decrescente :
                                                         opcode_aste == 2'b10 ? vertical_crescente : vertical_decrescente;
                horizontal_crescente:   proximo_estado = salva_posicao; 
                horizontal_decrescente: proximo_estado = salva_posicao;
                vertical_crescente:     proximo_estado = salva_posicao;
                vertical_decrescente:   proximo_estado = salva_posicao;
                salva_posicao:          proximo_estado = rco_contador_aste ? sinaliza : incrementa_contador;
                incrementa_contador:    proximo_estado = aux;
                aux:                    proximo_estado = verifica_loaded;
                sinaliza:               proximo_estado = espera;
                default:                proximo_estado = inicio;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin
        reset_contador_aste         = (estado_atual == reseta_contador)        ? 1'b1 : 1'b0;
        movimentacao_concluida_aste = (estado_atual == sinaliza)               ? 1'b1 : 1'b0;
        conta_contador_aste         = (estado_atual == incrementa_contador)    ? 1'b1 : 1'b0;
        enable_mem_aste             = (estado_atual == horizontal_crescente    || 
                                       estado_atual == horizontal_decrescente  ||
                                       estado_atual == vertical_crescente      ||
                                       estado_atual == vertical_decrescente)   ? 1'b1 : 1'b0;
        select_soma_sub             = (estado_atual == horizontal_decrescente  ||
                                       estado_atual == vertical_decrescente)   ? 1'b1 : 1'b0;
        select_mux_pos_aste         = (estado_atual == horizontal_crescente    ||
                                       estado_atual == horizontal_decrescente) ? 2'b01 :  
                                      (estado_atual == vertical_crescente      ||
                                       estado_atual == vertical_decrescente)   ? 2'b10 : 2'b00;
        select_mux_coor_aste        = (estado_atual == vertical_crescente      ||
                                       estado_atual == vertical_decrescente)   ? 1'b1 : 1'b0;
        reset_contador_movimenta_asteroide = (estado_atual == sinaliza)        ? 1'b1 : 1'b0;

        // Saída de depuração (estado)
        case (estado_atual)
            inicio:                 db_estado_move_aste = 5'b00000; // 0
            espera:                 db_estado_move_aste = 5'b00001; // 1
            reseta_contador:        db_estado_move_aste = 5'b00010; // 2
            verifica_loaded:        db_estado_move_aste = 5'b00011; // 3
            verifica_opcode:        db_estado_move_aste = 5'b00100; // 4
            horizontal_crescente:   db_estado_move_aste = 5'b00101; // 5 
            horizontal_decrescente: db_estado_move_aste = 5'b00110; // 6
            vertical_crescente:     db_estado_move_aste = 5'b00111; // 7
            vertical_decrescente:   db_estado_move_aste = 5'b01000; // 8
            salva_posicao:          db_estado_move_aste = 5'b01001; // 9
            incrementa_contador:    db_estado_move_aste = 5'b01010; // 10
            aux:                    db_estado_move_aste = 5'b01011; // 11
            sinaliza:               db_estado_move_aste = 5'b01110; // 12
            erro:                   db_estado_move_aste = 5'b11111; // erro
            default:                db_estado_move_aste = 5'b11111; // 
        endcase
    end
endmodule

