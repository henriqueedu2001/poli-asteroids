`timescale 1ns / 1ps

module astro_genius_tb;

    reg clock;
    reg reset;
    reg iniciar;
    reg [5:0] chaves;

    wire pronto;
    wire [4:0] db_estado_jogo_principal;
    wire [4:0] db_estado_coordena_asteroides_tiros;
    wire [4:0] db_estado_compara_tiros_e_asteroide;
    wire [4:0] db_estado_move_tiros;
    wire [4:0] db_estado_compara_asteroides_com_nave_e_tiros;
    wire [4:0] db_estado_move_asteroides;
    wire [3:0] db_estado_registra_tiro;

    // Instantiate the astro_genius module
    astro_genius dut (
        .clock(clock),
        .reset(reset),
        .iniciar(iniciar),
        .chaves(chaves),
        .pronto(pronto),
        .db_estado_jogo_principal(db_estado_jogo_principal),
        .db_estado_coordena_asteroides_tiros(db_estado_coordena_asteroides_tiros),
        .db_estado_compara_tiros_e_asteroide(db_estado_compara_tiros_e_asteroide),
        .db_estado_move_tiros(db_estado_move_tiros),
        .db_estado_compara_asteroides_com_nave_e_tiros(db_estado_compara_asteroides_com_nave_e_tiros),
        .db_estado_move_asteroides(db_estado_move_asteroides),
        .db_estado_registra_tiro(db_estado_registra_tiro)
    );

   parameter clockPeriod = 20; // in ns, f=50MHz

    // Gerador de clock
    always #((clockPeriod / 2)) clock = ~clock;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(5, astro_genius_tb);
        // valores iniciais
        clock = 1'b0;
        reset = 1'b1;
        iniciar = 1'b0;
        chaves = 6'b000000;
        #(5*clockPeriod)

        reset = 1'b0;
        iniciar = 1'b1;
        #(10*clockPeriod)

        iniciar = 1'b0;
        #(10*clockPeriod)

        chaves = 6'b100001;
        #(10*clockPeriod)
        chaves = 6'b000000;
        #(100000*clockPeriod)

        $finish;
    end

endmodule