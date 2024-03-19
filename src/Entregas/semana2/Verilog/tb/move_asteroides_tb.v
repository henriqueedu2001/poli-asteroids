`timescale 1ns / 1ns

module move_asteroides_tb;

    // Inputs
    reg clock;
    reg reset;
    reg inicia_move_asteroides;

    // Outputs
    wire movimentacao_concluida_asteroides;
    wire [4:0] db_estado_move_asteroides;

    move_asteroides dut (
        .clock(clock),
        .reset(reset),
        .inicia_move_asteroides(inicia_move_asteroides),
        .movimentacao_concluida_asteroides(movimentacao_concluida_asteroides),
        .db_estado_move_asteroides(db_estado_move_asteroides)
    );

    parameter clockPeriod = 2; // in ns, f=1KHz

    // Gerador de clock
    always #((clockPeriod / 2)) clock = ~clock;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(5, move_asteroides_tb);
        // valores iniciais
        clock = 1'b0;
        reset = 1'b1;
        inicia_move_asteroides = 1'b0;
        #(5*clockPeriod)

        reset = 1'b0;
        inicia_move_asteroides = 1'b1;
        #(1000*clockPeriod)

        $finish;
    end

endmodule