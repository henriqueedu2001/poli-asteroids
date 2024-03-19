`timescale 1ns / 1ns

module uc_coordena_asteroides_tiros_tb();

    // Inputs
    reg clock;
    reg reset;
    reg move_tiro_e_asteroides;
    reg rco_contador_tiro;
    reg rco_contador_asteroides;
    reg fim_move_tiros;
    reg fim_move_asteroides;
    reg fim_comparacao_asteroides_com_a_nave_e_tiros;
    reg fim_comparacao_tiros_e_asteroides;

    // Outputs
    wire movimenta_tiro;
    wire sinal_movimenta_asteroides;
    wire sinal_compara_tiros_e_asteroids;
    wire sinal_compara_asteroides_com_a_nave_e_tiro;
    wire conta_contador_tiro;
    wire reset_contador_tiro;
    wire conta_contador_asteroides;
    wire reset_contador_asteroides;
    wire fim_move_tiro_e_asteroides;
    wire [4:0] db_estado_coordena_asteroides_tiros;

    // Instantiate the DUT
    uc_coordena_asteroides_tiros uut (
        .clock(clock),
        .reset(reset),
        .move_tiro_e_asteroides(move_tiro_e_asteroides),
        .rco_contador_tiro(rco_contador_tiro),
        .rco_contador_asteroides(rco_contador_asteroides),
        .fim_move_tiros(fim_move_tiros),
        .fim_move_asteroides(fim_move_asteroides),
        .fim_comparacao_asteroides_com_a_nave_e_tiros(fim_comparacao_asteroides_com_a_nave_e_tiros),
        .fim_comparacao_tiros_e_asteroides(fim_comparacao_tiros_e_asteroides),
        .movimenta_tiro(movimenta_tiro),
        .sinal_movimenta_asteroides(sinal_movimenta_asteroides),
        .sinal_compara_tiros_e_asteroides(sinal_compara_tiros_e_asteroides),
        .sinal_compara_asteroides_com_a_nave_e_tiro(sinal_compara_asteroides_com_a_nave_e_tiro),
        .conta_contador_tiro(conta_contador_tiro),
        .reset_contador_tiro(reset_contador_tiro),
        .conta_contador_asteroides(conta_contador_asteroides),
        .reset_contador_asteroides(reset_contador_asteroides),
        .fim_move_tiro_e_asteroides(fim_move_tiro_e_asteroides),
        .db_estado_coordena_asteroides_tiros(db_estado_coordena_asteroides_tiros)
    );

    parameter clockPeriod = 2; // in ns, f=1KHz

    // Gerador de clock
    always #((clockPeriod / 2)) clock = ~clock;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(5, uc_coordena_asteroides_tiros_tb);
        // valores iniciais
        clock = 1'b0;
        reset = 1'b1;
        move_tiro_e_asteroides = 1'b0;
        fim_comparacao_tiros_e_asteroides = 1'b0;
        rco_contador_tiro = 1'b0;
        fim_move_tiros = 1'b0;
        fim_comparacao_asteroides_com_a_nave_e_tiros = 1'b0;
        rco_contador_asteroides = 1'b0;
        fim_move_asteroides = 1'b0;
        #(2*clockPeriod)

        reset = 1'b0;
        #(2*clockPeriod)

        move_tiro_e_asteroides = 1'b1;
        #(5*clockPeriod)

        move_tiro_e_asteroides = 1'b0;
        fim_comparacao_tiros_e_asteroides = 1'b1;
        #(5*clockPeriod)

        fim_move_tiros = 1'b1;
        rco_contador_tiro = 1'b1;
        #(7*clockPeriod)

        fim_comparacao_asteroides_com_a_nave_e_tiros = 1'b1;
        #(5*clockPeriod)

        fim_move_asteroides = 1'b1;
        rco_contador_asteroides = 1'b1;
        #(10*clockPeriod)

        $finish;
    end

endmodule