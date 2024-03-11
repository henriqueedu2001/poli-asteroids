module unidade_controle (
    input clock,
    input reset,
    
    input iniciar,
    input tiro,
    input colisao,
    input acertou,
    input vidas,
    output reg clear_reg_asteroide,
    output reg enable_reg_asteroide_x,
    output reg clear_decrementer,
    output reg ent_decrementer,
    output reg select_mux_coor,
    output reg select_mux_incremento,
    output reg select_sum_sub,

    //db
    output reg db_estado
);
    
    /* declaração dos estados dessa UC */
    parameter inicio                = 6'b000000; // 0
    parameter inicializa_elementos  = 6'b000001; // 1
    parameter gera_asteroide        = 6'b000010; // 2
    parameter espera_jogada         = 6'b000011; // 3
    parameter registra_jogada       = 6'b000100; // 4
    parameter compara_jogada        = 6'b000101; // 5
    parameter destroi_asteroide     = 6'b000110; // 6
    parameter proxima_jogada        = 6'b000111; // 7
    parameter perde_vida            = 6'b001000; // 8
    parameter compara_vidas         = 6'b001001; // 9
    parameter fim_do_jogo           = 6'b001010; // 10


    // Variáveis de estado
    reg [3:0] estado_atual, proximo_estado;

    // Memória de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            estado_atual <= inicio;
        else
            estado_atual <= proximo_estado;
    end

    always @* begin
        case (estado_atual)
            inicio:               proximo_estado = iniciar ? inicializa_elementos : inicio;
            inicializa_elementos: proximo_estado = gera_asteroide; 
            gera_asteroide:       proximo_estado = espera_jogada;
            espera_jogada:        proximo_estado = tiro ? registra_jogada : colisao ? perde_vida : espera_jogada;
            registra_jogada:      proximo_estado = compara_jogada;
            compara_jogada:       proximo_estado = acertou ? destroi_asteroide : proxima_jogada;
            destroi_asteroide:    proximo_estado = gera_asteroide;
            proxima_jogada:       proximo_estado = espera_jogada;
            perde_vida:		      proximo_estado = compara_vidas; 
            compara_vidas:		  proximo_estado = vidas ? gera_asteroide : fim_do_jogo;
            fim_do_jogo:          proximo_estado = iniciar ? inicializa_elementos : fim_do_jogo;
            default:              proximo_estado = inicio;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin
	 
		
        clear_reg_asteroide    =   (estado_atual == inicio               ||
                                    estado_atual == inicializa_elementos ||
                                    estado_atual == perde_vida           ) ? 1'b1 : 1'b0;

        enable_reg_asteroide_x =   (estado_atual == gera_asteroide       ||
                                    estado_atual == espera_jogada        ||
                                    estado_atual == registra_jogada      ) ? 1'b1 : 1'b0;

        clear_decrementer      =   (estado_atual == inicio               ||
                                    estado_atual == inicializa_elementos ) ? 1'b1 : 1'b0;
        
        ent_decrementer        =   (estado_atual == perde_vida           ) ? 1'b1 : 1'b0;

        select_mux_coor        =   (estado_atual == inicio               ||
                                    estado_atual == inicializa_elementos ||
                                    estado_atual == gera_asteroide       ||
                                    estado_atual == espera_jogada        ||
                                    estado_atual == registra_jogada      ) ? 1'b0 : 1'b1;
        
        select_mux_incremento  =   (estado_atual == inicio               ||
                                    estado_atual == inicializa_elementos ||
                                    estado_atual == gera_asteroide       ||
                                    estado_atual == espera_jogada        ||
                                    estado_atual == registra_jogada      ) ? 1'b0 : 1'b1;

        select_sum_sub         =   (estado_atual == inicio               ||
                                    estado_atual == inicializa_elementos ||
                                    estado_atual == gera_asteroide       ||
                                    estado_atual == espera_jogada        ||
                                    estado_atual == registra_jogada      ) ? 1'b0 : 1'b1;

        // Saída de depuração (estado)
        case (estado_atual)

            inicio:                db_estado = 6'b000000; // 0
            inicializa_elementos:  db_estado = 6'b000001; // 1
            gera_asteroide:        db_estado = 6'b000010; // 2
            espera_jogada:         db_estado = 6'b000011; // 3
            registra_jogada:       db_estado = 6'b000100; // 4
            compara_jogada:        db_estado = 6'b000101; // 5
            destroi_asteroide:     db_estado = 6'b000110; // 6
            proxima_jogada:        db_estado = 6'b000111; // 7
            perde_vida:            db_estado = 6'b001000; // 8
			compara_vidas:         db_estado = 6'b001001; // 9
            fim_do_jogo:           db_estado = 6'b001010; // 10
            default:               db_estado = 6'b000000; 
        endcase
    end

endmodule