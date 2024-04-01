`timescale 1ns / 1ns

module astro_genius_tb();

    // DUT (Device Under Test)
    astro_genius DUT (
        .clock(clock),
        .reset(reset),
        .chaves(chaves),
        .saida_serial(saida_serial),
        .matriz_x(),
        .matriz_y(),
        .db_vidas(db_vidas),
        .db_pontos(db_pontos),
        .db_uc_menu(db_uc_menu)
    );

    // Testbench signals
    reg clock, reset;
    reg [5:0] chaves;
    wire saida_serial;
    wire [14:0] matriz_x;
    wire [3:0] matriz_y;
    wire [6:0] db_vidas;
    wire [6:0] db_pontos;
    wire [4:0] db_uc_menu;
    wire [5:0] wire_saida_reg_jogada;

    parameter clockPeriod = 20; // in ns, f=50MHz

    // Gerador de clock
    always #((clockPeriod / 2)) clock = ~clock;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(5, astro_genius_tb);

        // Initialize Inputs
        clock = 1'b0;
        reset = 1'b0;
        chaves = 6'b000000;
        #(5*clockPeriod)

        reset = 1;
        #(5*clockPeriod)

        chaves = 6'b000001;
        #(1000000*clockPeriod)
        $finish;
    end



endmodule
