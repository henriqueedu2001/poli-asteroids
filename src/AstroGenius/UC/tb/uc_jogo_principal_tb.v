
`timescale 1ns / 1ns

module uc_jogo_principal_tb;

    // Inputs
    reg clock;
    reg iniciar;
    reg reset;
    reg vidas;
    reg fim_movimentacao_asteroides_e_tiros;
    reg fim_registra_tiros;
    reg ocorreu_tiro;
    reg ocorreu_jogada;

    // Outputs
    wire enable_reg_jogada;
    wire reset_reg_jogada; 
    wire inicia_registra_tiros;
    wire inicia_movimentacao_asteroides_e_tiros;
    wire reset_contador_asteroides;
    wire reset_move_tiros;
    wire pronto;
    wire [4:0] db_estado_jogo_principal;

    // Instantiate the module
    uc_registra_tiro dut (
        .clock(clock),
        .iniciar(iniciar),
        .reset(reset),
        .vidas(vidas),
        .fim_movimentacao_asteroides_e_tiros(fim_movimentacao_asteroides_e_tiros),
        .fim_registra_tiros(fim_registra_tiros),
        .ocorreu_tiro(ocorreu_tiro),
        .ocorreu_jogada(ocorreu_jogada),
        .enable_reg_jogada(enable_reg_jogada),
        .reset_reg_jogada(reset_reg_jogada),
        .inicia_registra_tiros(inicia_registra_tiros),
        .inicia_movimentacao_asteroides_e_tiros(inicia_movimentacao_asteroides_e_tiros),
        .reset_contador_asteroides(reset_contador_asteroides),
        .reset_move_tiros(reset_move_tiros),
        .pronto(pronto),
        .db_estado_jogo_principal(db_estado_jogo_principal)
    );

    // Add clock generation

    parameter clockPeriod = 2; // in ns, f=1KHz

    // Gerador de clock
    always #((clockPeriod / 2)) clock = ~clock;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(5, uc_jogo_principal_tb);
        // valores iniciais
        clock = 1'b0;
        reset = 1'b1;
        iniciar = 1'b0;
        vidas = 1'b1;
        ocorreu_jogada = 1'b0;
        ocorreu_tiro = 1'b0;
        fim_movimentacao_asteroides_e_tiros = 1'b0;
        fim_registra_tiros = 1'b0;
        #(2*clockPeriod)

        reset = 1'b0;
        #(2*clockPeriod)

        iniciar = 1'b1;
        #(5*clockPeriod)

        ocorreu_jogada = 1'b1;
        iniciar = 1'b0;
        #(5*clockPeriod)
        
        ocorreu_tiro = 1'b1;
        #(5*clockPeriod)

        fim_movimentacao_asteroides_e_tiros = 1'b1;
        #(5*clockPeriod)

        fim_registra_tiros = 1'b1;
        fim_movimentacao_asteroides_e_tiros = 1'b0;
        #(5*clockPeriod)

        vidas = 1'b0;
        #(5*clockPeriod)

        fim_movimentacao_asteroides_e_tiros = 1'b1;
        #(5*clockPeriod)
        

        $finish;
    end
endmodule