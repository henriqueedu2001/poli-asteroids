`timescale 1ns / 1ns

module uc_move_asteroides_tb;

    // Inputs
    reg clock;
    reg movimenta_aste;
    reg reset;
    reg [1:0] opcode_aste;
    reg loaded_aste;
    reg rco_contador_aste;

    // Outputs
    wire [1:0] select_mux_pos_aste;
    wire select_mux_coor_aste;
    wire select_soma_sub;
    wire reset_contador_aste;
    wire conta_contador_aste;
    wire enable_mem_aste;
    wire movimentacao_concluida_aste;
    wire [4:0] db_estado_move_aste;

    // Instantiate the module
    uc_move_asteroides dut (
        .clock(clock),
        .movimenta_aste(movimenta_aste),
        .reset(reset),
        .opcode_aste(opcode_aste),
        .loaded_aste(loaded_aste),
        .rco_contador_aste(rco_contador_aste),
        .select_mux_pos_aste(select_mux_pos_aste),
        .select_mux_coor_aste(select_mux_coor_aste),
        .select_soma_sub(select_soma_sub),
        .reset_contador_aste(reset_contador_aste),
        .conta_contador_aste(conta_contador_aste),
        .enable_mem_aste(enable_mem_aste),
        .movimentacao_concluida_aste(movimentacao_concluida_aste),
        .db_estado_move_aste(db_estado_move_aste)
    );

    parameter clockPeriod = 2; // in ns, f=1KHz

    // Gerador de clock
    always #((clockPeriod / 2)) clock = ~clock;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(5, uc_move_asteroides_tb);
        // valores iniciais
        clock = 1'b0;
        reset = 1'b1;
        movimenta_aste = 1'b0;
        loaded_aste = 1'b0;
        rco_contador_aste = 1'b0;
        opcode_aste = 2'b00;
        #(2*clockPeriod)

        reset = 1'b0;
        #(2*clockPeriod)

        movimenta_aste = 1'b1;
        #(4*clockPeriod)

        movimenta_aste = 1'b0;
        loaded_aste = 1'b1;
        opcode_aste = 2'b10;
        rco_contador_aste = 1'b1;
        #(10*clockPeriod)

        $finish;
    end

endmodule