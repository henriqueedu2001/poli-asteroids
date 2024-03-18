`timescale 1ns / 1ns

module uc_compara_asteroides_com_nave_e_tiros_tb;

    // Inputs
    reg clock;
    reg reset;
    reg iniciar_comparacao_tiros_nave_asteroides;
    reg posicao_asteroide_igual_nave;
    reg ha_vidas;
    reg rco_contador_asteroides;
    reg fim_compara_tiros_e_asteroides;

    // Outputs
    wire enable_decrementador;
    wire new_loaded_asteroide;
    wire new_destruido_asteroide;
    wire new_loaded_tiro;
    wire fim_compara_asteroides_com_tiros_e_nave;
    wire enable_mem_tiro;
    wire enable_mem_destruido;
    wire conta_contador_asteroides;
    wire sinal_compara_tiros_e_asteroide;
    wire [4:0] db_estado_compara_asteroides_com_nave_e_tiros;


    uc_compara_asteroides_com_nave_e_tiros dut (
        .clock(clock),
        .reset(reset),
        .iniciar_comparacao_tiros_nave_asteroides(iniciar_comparacao_tiros_nave_asteroides),
        .posicao_asteroide_igual_nave(posicao_asteroide_igual_nave),
        .ha_vidas(ha_vidas),
        .rco_contador_asteroides(rco_contador_asteroides),
        .fim_compara_tiros_e_asteroides(fim_compara_tiros_e_asteroides),
        .enable_decrementador(enable_decrementador),
        .new_loaded_asteroide(new_loaded_asteroide),
        .new_destruido_asteroide(new_destruido_asteroide),
        .new_loaded_tiro(new_loaded_tiro),
        .fim_compara_asteroides_com_tiros_e_nave(fim_compara_asteroides_com_tiros_e_nave),
        .enable_mem_tiro(enable_mem_tiro),
        .enable_mem_destruido(enable_mem_destruido),
        .conta_contador_asteroides(conta_contador_asteroides),
        .sinal_compara_tiros_e_asteroide(sinal_compara_tiros_e_asteroide),
        .db_estado_compara_asteroides_com_nave_e_tiros(db_estado_compara_asteroides_com_nave_e_tiros)
    );

    parameter clockPeriod = 2; // in ns, f=1KHz

    // Gerador de clock
    always #((clockPeriod / 2)) clock = ~clock;

     initial begin
        $dumpfile("wave.vcd");
        $dumpvars(5, uc_compara_asteroides_com_nave_e_tiros_tb);
        // valores iniciais
        clock = 1'b0;
        reset = 1'b1;
        iniciar_comparacao_tiros_nave_asteroides = 1'b0;
        posicao_asteroide_igual_nave = 1'b0;
        ha_vidas = 1'b0;
        rco_contador_asteroides = 1'b0;
        fim_compara_tiros_e_asteroides = 1'b0;
        #(2*clockPeriod)

        reset = 1'b0;
        #(2*clockPeriod)

        iniciar_comparacao_tiros_nave_asteroides = 1'b1;
        posicao_asteroide_igual_nave = 1'b0;
        #(2*clockPeriod)

        iniciar_comparacao_tiros_nave_asteroides = 1'b0;
        posicao_asteroide_igual_nave = 1'b1;
        ha_vidas = 1'b1;
        rco_contador_asteroides = 1'b1;
        fim_compara_tiros_e_asteroides = 1'b0;
        #(10*clockPeriod)

        fim_compara_tiros_e_asteroides = 1'b1;
        #(10*clockPeriod)


        $finish;
    end

endmodule