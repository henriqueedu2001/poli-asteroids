module uc_compara_tiros_e_asteroides (
        input clock,
        input reset,
        input compara_tiros_e_asteroides,
        input posicao_tiro_igual_asteroide,
        input rco_contador_asteroides,
        input rco_contador_tiros,

        output reg reset_contador_asteroides,
        output reg reset_contador_tiros,
        output reg enable_mem_tiro,
        output reg enable_mem_asteroide,
        output reg loaded_tiro,
        output reg loaded_asteroide,
        output reg asteroide_destruido,
        output reg conta_contador_asteroides,
        output reg conta_contador_tiros,
        output reg s_fim_comparacao,
        output reg [4:0] db_estado_compara_tiros_e_asteroide
);

    parameter inicio                = 5'b00000; // 0
    parameter espera                = 5'b00001; // 1
    parameter reseta_contador       = 5'b00010; // 2
    parameter compara               = 5'b00011; // 3
    parameter destroi_asteroide     = 5'b00100; // 4
    parameter salva_destruicao      = 5'b00101; // 5
    parameter incrementa_asteroides = 5'b00110; // 6
    parameter incrementa_tiros      = 5'b00111; // 7
    parameter fim_comparacao        = 5'b01000; // 8
    parameter erro                  = 5'b01111; // F


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
            inicio:                proximo_estado = espera;
            espera:                proximo_estado = compara_tiros_e_asteroides ? reseta_contador : espera;
            reseta_contador:       proximo_estado = compara;
            compara:               proximo_estado = posicao_tiro_igual_asteroide ? destroi_asteroide : 
                                                    (~posicao_tiro_igual_asteroide && ~rco_contador_asteroides) ? incrementa_asteroides :
                                                    (~posicao_tiro_igual_asteroide && rco_contador_asteroides && ~rco_contador_tiros) ? incrementa_tiros : 
                                                    (~posicao_tiro_igual_asteroide && rco_contador_asteroides && rco_contador_tiros) ? fim_comparacao : erro;
            destroi_asteroide:     proximo_estado = salva_destruicao;
            salva_destruicao:      proximo_estado = ~rco_contador_asteroides ? incrementa_asteroides :
                                                    (rco_contador_asteroides && ~rco_contador_tiros) ? incrementa_tiros :
                                                    (rco_contador_asteroides && rco_contador_tiros) ? fim_comparacao : erro;
            fim_comparacao:        proximo_estado = espera;
            incrementa_asteroides: proximo_estado = compara;
            incrementa_tiros:      proximo_estado = compara;
            default:               proximo_estado = inicio;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin
        reset_contador_asteroides    =   (estado_atual == reseta_contador ||
                                          estado_atual == incrementa_tiros)      ? 1'b1 : 1'b0;
        reset_contador_tiros         =   (estado_atual == reseta_contador)       ? 1'b1 : 1'b0;
        enable_mem_tiro              =   (estado_atual == salva_destruicao)      ? 1'b1 : 1'b0;
        enable_mem_asteroide         =   (estado_atual == salva_destruicao)      ? 1'b1 : 1'b0;
        loaded_tiro                  =   (estado_atual == destroi_asteroide ||
                                          estado_atual == salva_destruicao  )    ? 1'b0 : 1'b1;
        loaded_asteroide             =   (estado_atual == destroi_asteroide ||
                                          estado_atual == salva_destruicao  )    ? 1'b0 : 1'b1;
        asteroide_destruido          =   (estado_atual == destroi_asteroide)     ? 1'b1 : 1'b0;
        conta_contador_asteroides    =   (estado_atual == incrementa_asteroides) ? 1'b1 : 1'b0;
        conta_contador_tiros         =   (estado_atual == incrementa_tiros)      ? 1'b1 : 1'b0;
        s_fim_comparacao             =   (estado_atual == fim_comparacao)        ? 1'b1 : 1'b0;


        // Saída de depuração (estado)
        case (estado_atual)
            inicio:                db_estado_compara_tiros_e_asteroide = 5'b00000; // 0
            espera:                db_estado_compara_tiros_e_asteroide = 5'b00001; // 1
            reseta_contador:       db_estado_compara_tiros_e_asteroide = 5'b00010; // 2
            compara:               db_estado_compara_tiros_e_asteroide = 5'b00011; // 3
            destroi_asteroide:     db_estado_compara_tiros_e_asteroide = 5'b00100; // 4
            salva_destruicao:      db_estado_compara_tiros_e_asteroide = 5'b00101; // 5
            incrementa_asteroides: db_estado_compara_tiros_e_asteroide = 5'b00110; // 6
            incrementa_tiros:      db_estado_compara_tiros_e_asteroide = 5'b00111; // 7
            fim_comparacao:        db_estado_compara_tiros_e_asteroide = 5'b01000; // 8
            erro:                  db_estado_compara_tiros_e_asteroide = 5'b01111; // F  
            default:               db_estado_compara_tiros_e_asteroide = 5'b00000; 
        endcase
    end
endmodule

