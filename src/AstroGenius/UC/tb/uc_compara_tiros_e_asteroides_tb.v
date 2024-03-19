`timescale 1ns / 1ns

module uc_compara_tiros_e_asteroides_tb;

    // Inputs
    reg clock;
    reg reset;
    reg compara_tiros_e_asteroides;
    reg posicao_tiro_igual_asteroide;
    reg rco_contador_asteroides;
    reg rco_contador_tiros;

    // Outputs
    wire reset_contador_asteroides;
    wire reset_contador_tiros;
    wire enable_mem_tiro;
    wire enable_mem_asteroide;
    wire loaded_tiro;
    wire loaded_asteroide;
    wire asteroide_destruido;
    wire conta_contador_asteroides;
    wire conta_contador_tiros;
    wire s_fim_comparacao;
    wire [4:0] db_estado;

    // Instantiate the module
    uc_compara_tiros_e_asteroides dut (
        .clock(clock),
        .reset(reset),
        .compara_tiros_e_asteroides(compara_tiros_e_asteroides),
        .posicao_tiro_igual_asteroide(posicao_tiro_igual_asteroide),
        .rco_contador_asteroides(rco_contador_asteroides),
        .rco_contador_tiros(rco_contador_tiros),
        .reset_contador_asteroides(reset_contador_asteroides),
        .reset_contador_tiros(reset_contador_tiros),
        .enable_mem_tiro(enable_mem_tiro),
        .enable_mem_asteroide(enable_mem_asteroide),
        .loaded_tiro(loaded_tiro),
        .loaded_asteroide(loaded_asteroide),
        .asteroide_destruido(asteroide_destruido),
        .conta_contador_asteroides(conta_contador_asteroides),
        .conta_contador_tiros(conta_contador_tiros),
        .s_fim_comparacao(s_fim_comparacao),
        .db_estado(db_estado)
    );

    parameter clockPeriod = 2; // in ns, f=1KHz

    // Gerador de clock
    always #((clockPeriod / 2)) clock = ~clock;


    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(5, uc_compara_tiros_e_asteroides_tb);
        // valores iniciais
        clock = 1'b0;
        reset = 1'b1;
        compara_tiros_e_asteroides = 1'b0;
        posicao_tiro_igual_asteroide = 1'b0;
        rco_contador_asteroides = 1'b0;
        rco_contador_tiros = 1'b0;
        #(5*clockPeriod)

        reset = 1'b0;
        #(2*clockPeriod)

        compara_tiros_e_asteroides = 1'b1;
        posicao_tiro_igual_asteroide = 1'b1;
        rco_contador_asteroides = 1'b0;
        #(6*clockPeriod)

        compara_tiros_e_asteroides = 1'b0;
        rco_contador_asteroides = 1'b1;
        posicao_tiro_igual_asteroide = 1'b0;
        rco_contador_tiros = 1'b1;

        #(5*clockPeriod)

        $finish;
    end

endmodule