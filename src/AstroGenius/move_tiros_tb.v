`timescale 1ns/1ns

module move_tiros_tb;


    reg clock;
    reg iniciar;
    reg reset;
    wire movimentacao_concluida_tiro;
    wire [4:0] db_estado;



    parameter clockPeriod = 20; // in ns, f=1KHz

    // Gerador de clock
    always #((clockPeriod / 2)) clock = ~clock;


move_tiros uut(
        .clock( clock ),
        .reset( reset ),
        .iniciar( iniciar ),
        .movimentacao_concluida_tiro( movimentacao_concluida_tiro ),
        .db_estado( db_estado )
);

initial begin
    // Add test stimulus here
    $dumpfile("wave.vcd");
    $dumpvars(5, move_tiros_tb);
    // valores iniciais
    clock = 1'b0;
    #(clockPeriod)
    clock = 1'b0;
    iniciar = 1'b0;
    reset = 1'b0;

    // reset na máquina
    reset = 1'b1;
    #(clockPeriod)

    reset = 1'b0;
    iniciar = 1'b1;

    #(60*clockPeriod)
    $finish;



end
        


endmodule
