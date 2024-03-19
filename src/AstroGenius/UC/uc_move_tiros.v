
module uc_move_tiros (
        input clock                    ,
        input iniciar                  ,
        input reset                    ,
        input [1:0] opcode_tiro        ,
        input loaded_tiro              ,
        input rco_contador_tiro        ,

        //entradas para verificar se o tiro saiu da tela
        input x_borda_max_tiro         , //true se a coord. X do tiro estiver no MAXIMO da horizontal
        input y_borda_max_tiro         , //true se a coord. Y do tiro estiver no MAXIMO da vetical
        input x_borda_min_tiro         , //true se a coord. Y do tiro estiver no MINIMO da horizontal
        input y_borda_min_tiro         , //true se a coord. Y do tiro estiver no MINIMO da vetical

        //saidas 
        output reg [1:0] select_mux_pos_tiro ,   //seletor do mux da posição 
        output reg select_mux_coor_tiro,  //seletor do mux da posição 
        output reg select_soma_sub     ,  
        output reg reset_contador_tiro ,
        output reg conta_contador_tiro , 
        output reg enable_mem_tiro     , // enable da memoria de tiros
        output reg new_loaded,                 // valor do loaded que será salvo na nossa memoria (é 0 quando tiro sair da tela) 
        output reg movimentacao_concluida_tiro, // sinal que indica o fim da movimentação dos tiros
        output reg [4:0] db_estado_move_tiros

);

    parameter inicio                 = 5'b00000; // 0
    parameter espera                 = 5'b00001; // 1
    parameter reseta_contador        = 5'b00010; // 2
    parameter verifica_loaded        = 5'b00011; // 3
    parameter verifica_saiu_tela     = 5'b00100; // 4
    parameter altera_loaded          = 5'b00101; // 5
    parameter salva_loaded           = 5'b00110; // 6
    parameter incrementa_contador    = 5'b00111; // 7
    parameter verifica_opcode        = 5'b01000; // 8 
    parameter horizontal_crescente   = 5'b01001; // 9 
    parameter horizontal_decrescente = 5'b01010; // A
    parameter vertical_crescente     = 5'b01011; // B
    parameter vertical_decrescente   = 5'b01100; // C
    parameter salva_posicao          = 5'b01101; // D
    parameter sinaliza               = 5'b01110; // E
    parameter erro                   = 5'b01111; // F

// Variáveis de estado
        reg [3:0] estado_atual, proximo_estado;

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
                espera:                proximo_estado = iniciar ? reseta_contador : espera;
                reseta_contador:       proximo_estado = verifica_loaded;
                verifica_loaded:       proximo_estado =   loaded_tiro                        ? verifica_saiu_tela  : 
                                                        (~loaded_tiro && ~rco_contador_tiro) ? conta_contador_tiro : 
                                                        (~loaded_tiro && rco_contador_tiro)  ? movimentacao_concluida_tiro : verifica_loaded;
                verifica_saiu_tela:    proximo_estado = (opcode_tiro == 2'b00 && x_borda_max_tiro  ||
                                                         opcode_tiro == 2'b01 && y_borda_max_tiro  ||
                                                         opcode_tiro == 2'b10 && x_borda_min_tiro  ||
                                                         opcode_tiro == 2'b01 && y_borda_min_tiro  )? altera_loaded : verifica_opcode;
                altera_loaded:          proximo_estado = salva_loaded;
                salva_loaded:           proximo_estado = rco_contador_tiro ? movimentacao_concluida_tiro : conta_contador_tiro;
                conta_contador_tiro:    proximo_estado = verifica_loaded;
                verifica_opcode:        proximo_estado = opcode_tiro == 2'b00 ? horizontal_crescente : 
                                                         opcode_tiro == 2'b01 ? horizontal_decrescente :
                                                         opcode_tiro == 2'b10 ? vertical_crescente : vertical_decrescente;
                horizontal_crescente:   proximo_estado = salva_posicao; 
                horizontal_decrescente: proximo_estado = salva_posicao;
                vertical_crescente:     proximo_estado = salva_posicao;
                vertical_decrescente:   proximo_estado = salva_posicao;
                salva_posicao:          proximo_estado = rco_contador_tiro ? movimentacao_concluida_tiro : incrementa_contador;
                default:                proximo_estado = inicio;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin
        reset_contador_tiro         = (estado_atual == reseta_contador) ? 1'b1 : 1'b0;
        new_loaded                  = (estado_atual == altera_loaded) ? 1'b0 : 1'b1;
        enable_mem_tiro             = (estado_atual == salva_loaded) ? 1'b1 : 1'b0;
        conta_contador_tiro         = (estado_atual == incrementa_contador) ? 1'b1 : 1'b0;
        select_soma_sub             = (estado_atual == horizontal_decrescente ||
                                       estado_atual == vertical_decrescente      )? 1'b1 : 1'b0;
        select_mux_pos_tiro         = (estado_atual == horizontal_crescente ||
                                       estado_atual == horizontal_decrescente) ? 2'b01 :  
                                      (estado_atual == vertical_crescente ||
                                       estado_atual == vertical_decrescente) ? 2'b10 : 2'b00;
        select_mux_coor_tiro        = (estado_atual == vertical_crescente ||
                                       estado_atual == vertical_decrescente) ? 1'b1 : 1'b0;
        movimentacao_concluida_tiro = (estado_atual == sinaliza) ? 1'b1 : 1'b0;

        // Saída de depuração (estado)
        case (estado_atual)
                inicio:                 db_estado_move_tiros = 5'b00000; // 0
                espera:                 db_estado_move_tiros = 5'b00001; // 1
                reseta_contador:        db_estado_move_tiros = 5'b00010; // 2
                verifica_loaded:        db_estado_move_tiros = 5'b00011; // 3
                verifica_saiu_tela:     db_estado_move_tiros = 5'b00100; // 4
                altera_loaded:          db_estado_move_tiros = 5'b00101; // 5
                salva_loaded:           db_estado_move_tiros = 5'b00110; // 6
                incrementa_contador:    db_estado_move_tiros = 5'b00111; // 7
                verifica_opcode:        db_estado_move_tiros = 5'b01000; // 8 
                horizontal_crescente:   db_estado_move_tiros = 5'b01001; // 9 
                horizontal_decrescente: db_estado_move_tiros = 5'b01010; // A
                vertical_crescente:     db_estado_move_tiros = 5'b01011; // B
                vertical_decrescente:   db_estado_move_tiros = 5'b01100; // C
                salva_posicao:          db_estado_move_tiros = 5'b01101; // D
                sinaliza:               db_estado_move_tiros = 5'b01110; // E
                erro:                   db_estado_move_tiros = 5'b01111; // F
                default:                db_estado_move_tiros = 5'b11111; // 
        endcase
    end
endmodule

