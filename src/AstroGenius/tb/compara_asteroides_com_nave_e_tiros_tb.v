`timescale 1ns / 1ps

module compara_asteroides_com_nave_e_tiros_tb;

    // Inputs
    reg clock;
    reg reset;
    reg compara_tiros_nave_asteroides;

    // Outputs
    wire sinal_fim_comparacao;
    wire [1:0] num_vidas;
    wire [4:0] db_estado_compara_asteroides_com_nave_e_tiros;
    wire [4:0] db_estado_compara_tiros_e_asteroide;

    // Instantiate the module
    compara_asteroides_com_nave_e_tiros dut (
        .clock(clock),
        .reset(reset),
        .compara_tiros_nave_asteroides(compara_tiros_nave_asteroides),
        .num_vidas(num_vidas),
        .sinal_fim_comparacao(sinal_fim_comparacao),
        .db_estado_compara_asteroides_com_nave_e_tiros(db_estado_compara_asteroides_com_nave_e_tiros),
        .db_estado_compara_tiros_e_asteroide(db_estado_compara_tiros_e_asteroide)
    );

    parameter clockPeriod = 2; // in ns, f=1KHz

    // Gerador de clock
    always #((clockPeriod / 2)) clock = ~clock;


    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(5, compara_asteroides_com_nave_e_tiros_tb);
        // valores iniciais
        clock = 1'b0;
        reset = 1'b1;
        compara_tiros_nave_asteroides = 1'b0;
        #(5*clockPeriod)

        reset = 1'b0;
        #(5*clockPeriod)

        compara_tiros_nave_asteroides = 1'b1;
        #(2000*clockPeriod)

        

        $finish;
    end

endmodule