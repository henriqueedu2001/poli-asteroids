
/* Essa unidade de control é responsável pela lógica de registrar e gerar
   os tiros da jogada especial. A jogada especial gera 4 tiros no tabuleiro,
   um em cada direção. O funcionamento é o seguinte:  é varrida a memória de tiros
   para verificar se a há algum tiro naquela posicão de memória. Se houver um tiro
   ele não sera registrado, então um contador é aumentado para verificar a seguinte posicao de memoria.
   Caso não haja um tiro naquela posição de memoria, o tiro sera registrado naquela posicao e então
   a próxima posição de memória é verificada. Esse processo se repete até todos os 4 tiros 
   serem gerados no jogo e na memória de tiros.*/

   
module uc_registra_especial (
        input clock                    ,
        input reset                    ,
        input registra_tiro_especial   , // entrada que inicia a máquina de estados
        input loaded_tiro              ,
        input rco_contador_tiro        ,
        input rco_opcode               ,
        output reg reset_contador_tiro , // reset do contador que aponta para a posição do tiro na memoria
        output reg reset_contador_especial,
        output reg reset_intervalo_especial,
        output reg enable_mem_tiro     , // enable da memoria de tiros
        output reg [1:0] select_mux_pos, // mux que seleciona a posição que será salva na memoria (salva a posição da nave e o opcode)
        output reg new_load            ,
        output reg enable_load_tiro    , // enable da memoria de tiros
        output reg conta_contador_opcode,
        output reg conta_contador_tiro  , // conta do contador que aponta para a posição do tiro na memoria
        output reg especial_registrado  , // saida final que indica o fim da operação registra tiro
        output reg select_mux_especial_opcode,
        output reg [3:0] db_estado_registra_tiro_especial
);

        /* declaração dos estados dessa UC */
        parameter inicial                    = 4'b0000; // 0
        parameter espera                     = 4'b0001; // 1
        parameter zera_contador              = 4'b0010; // 2
        parameter verifica                   = 4'b0011; // 3
        parameter salva_tiro                 = 4'b0100; // 4
        parameter verifica_rco_opcode        = 4'b0101; // 5
        parameter incrementa_contador_opcode = 4'b0110; // 6
        parameter verifica_rco_tiros         = 4'b0111; // 7
        parameter incrementa_contador_tiro   = 4'b1000; // 8
        parameter aux                        = 4'b1001; // 9
        parameter sinaliza                   = 4'b1010; // A
        parameter erro                       = 4'b1111; // F

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
                inicial:                    proximo_estado = espera;
                espera:                     proximo_estado = registra_tiro_especial ? zera_contador : espera;
                zera_contador:              proximo_estado = verifica;
                verifica:                   proximo_estado = loaded_tiro ? verifica_rco_tiros : salva_tiro; 
                verifica_rco_tiros:         proximo_estado = rco_contador_tiro ? sinaliza : incrementa_contador_tiro;
                incrementa_contador_tiro:   proximo_estado = aux;
                aux:                        proximo_estado = verifica;
                salva_tiro:                 proximo_estado = verifica_rco_opcode;
                verifica_rco_opcode:        proximo_estado = rco_opcode ? sinaliza : incrementa_contador_opcode;
                incrementa_contador_opcode: proximo_estado = verifica;
                sinaliza:                   proximo_estado = espera;
                default:                    proximo_estado = erro;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin
        reset_contador_tiro        = (estado_atual == zera_contador) ? 1'b1 : 1'b0;
        reset_contador_especial    = (estado_atual == zera_contador) ? 1'b1 : 1'b0;
        enable_mem_tiro            = (estado_atual == salva_tiro)    ? 1'b1 : 1'b0;
        new_load                   = (estado_atual == salva_tiro)    ? 1'b1 : 1'b0;
        enable_load_tiro           = (estado_atual == salva_tiro)    ? 1'b1 : 1'b0;
        select_mux_especial_opcode = (estado_atual == salva_tiro)    ? 1'b1 : 1'b0;
        especial_registrado        = (estado_atual == sinaliza)      ? 1'b1 : 1'b0;
        reset_intervalo_especial   = (estado_atual == sinaliza)      ? 1'b1 : 1'b0;
        select_mux_pos             = (estado_atual == salva_tiro)    ? 2'b00 : 2'b00; 
        conta_contador_tiro        = (estado_atual == incrementa_contador_tiro)   ? 1'b1 : 1'b0;
        conta_contador_opcode      = (estado_atual == incrementa_contador_opcode) ? 1'b1 : 1'b0;

        // Saída de depuração (estado)
        case (estado_atual)
            inicial:                    db_estado_registra_tiro_especial = 4'b0000; // 0
            espera:                     db_estado_registra_tiro_especial = 4'b0001; // 1
            zera_contador:              db_estado_registra_tiro_especial = 4'b0010; // 2
            verifica:                   db_estado_registra_tiro_especial = 4'b0011; // 3
            salva_tiro:                 db_estado_registra_tiro_especial = 4'b0100; // 4
            verifica_rco_opcode:        db_estado_registra_tiro_especial = 4'b0101; // 5
            incrementa_contador_opcode: db_estado_registra_tiro_especial = 4'b0110; // 6
            verifica_rco_tiros:         db_estado_registra_tiro_especial = 4'b0111; // 7
            incrementa_contador_tiro:   db_estado_registra_tiro_especial = 4'b1000; // 8
            aux:                        db_estado_registra_tiro_especial = 4'b1001; // 9
            sinaliza:                   db_estado_registra_tiro_especial = 4'b1010; // A
            erro:                       db_estado_registra_tiro_especial = 4'b1111; // F
            default:                    db_estado_registra_tiro_especial = 4'b1111;
        endcase
    end
endmodule
