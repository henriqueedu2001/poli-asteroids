`timescale 1ns / 1ns

module cordena_asteroide_tiro_tb;

    reg clock;
    reg reset;
    reg cordena_asteroide_tiro;

    wire fim_cordena_asteroide_tiro;
    wire [4:0] db_estado_coordena_asteroide_tiro;

    // Instantiate the module under test
    cordena_asteroide_tiro dut (
        .clock(clock),
        .reset(reset),
        .cordena_asteroide_tiro(cordena_asteroide_tiro),
        .fim_cordena_asteroide_tiro(fim_cordena_asteroide_tiro),
        .db_estado_coordena_asteroide_tiro(db_estado_coordena_asteroide_tiro)
    );

    parameter clockPeriod = 2; // in ns, f=1KHz

    // Gerador de clock
    always #((clockPeriod / 2)) clock = ~clock;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(5, cordena_asteroide_tiro_tb);
        // valores iniciais
        clock = 1'b0;
        reset = 1'b1;
        cordena_asteroide_tiro = 1'b0;
        #(5*clockPeriod)

        reset = 1'b0;
        cordena_asteroide_tiro = 1'b1;
        #(5000*clockPeriod)

        $finish;
    end

endmodule