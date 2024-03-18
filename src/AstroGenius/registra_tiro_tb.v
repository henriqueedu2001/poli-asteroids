`timescale 1ns/1ns

module registra_tiro_tb;


    reg clock;
    reg in_registra_tiro;
    reg reset;
    wire tiro_registrado;
    wire [3:0] db_estado;


    parameter clockPeriod = 20; // in ns, f=1KHz

    // Gerador de clock
    always #((clockPeriod / 2)) clock = ~clock;


registra_tiro uut(
        .clock( clock ),
        .registra_tiro( in_registra_tiro ),
        .reset( reset ),
        .tiro_registrado( tiro_registrado ),
        .db_estado( db_estado )
);

initial begin
    // Add test stimulus here
    $dumpfile("wave.vcd");
    $dumpvars(5, registra_tiro_tb);
    // valores iniciais
    clock = 1'b0;
    #(clockPeriod)
    clock = 1'b0;
    in_registra_tiro = 1'b0;
    reset = 1'b0;

    // reset na máquina
    reset = 1'b1;
    #(clockPeriod)

    reset = 1'b0;
    in_registra_tiro = 1'b1;

    #(60*clockPeriod)
    $finish;



end
        


endmodule
