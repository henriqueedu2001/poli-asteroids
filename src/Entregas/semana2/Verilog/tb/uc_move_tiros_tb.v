`timescale 1ns / 1ns

module uc_move_tiros_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns

    // Signals
    reg clock;
    reg movimenta_tiro;
    reg reset;
    reg [1:0] opcode_tiro;
    reg loaded_tiro;
    reg rco_contador_tiro;
    reg x_borda_max_tiro;
    reg y_borda_max_tiro;
    reg x_borda_min_tiro;
    reg y_borda_min_tiro;

    wire [1:0] select_mux_pos_tiro;
    wire select_mux_coor_tiro;
    wire select_soma_sub;
    wire reset_contador_tiro;
    wire conta_contador_tiro;
    wire enable_mem_tiro;
    wire new_loaded;
    wire movimentacao_concluida_tiro;
    wire [4:0] db_estado_move_tiros;
    wire enable_load_tiro;

    // Instantiate the module
    uc_move_tiros dut (
        .clock(clock),
        .movimenta_tiro(movimenta_tiro),
        .reset(reset),
        .opcode_tiro(opcode_tiro),
        .loaded_tiro(loaded_tiro),
        .rco_contador_tiro(rco_contador_tiro),
        .x_borda_max_tiro(x_borda_max_tiro),
        .y_borda_max_tiro(y_borda_max_tiro),
        .x_borda_min_tiro(x_borda_min_tiro),
        .y_borda_min_tiro(y_borda_min_tiro),
        .select_mux_pos_tiro(select_mux_pos_tiro),
        .select_mux_coor_tiro(select_mux_coor_tiro),
        .select_soma_sub(select_soma_sub),
        .reset_contador_tiro(reset_contador_tiro),
        .conta_contador_tiro(conta_contador_tiro),
        .enable_mem_tiro(enable_mem_tiro),
        .new_loaded(new_loaded),
        .movimentacao_concluida_tiro(movimentacao_concluida_tiro),
        .db_estado_move_tiros(db_estado_move_tiros),
        .enable_load_tiro(enable_load_tiro)
    );

    parameter clockPeriod = 2; // in ns, f=1KHz

    // Gerador de clock
    always #((clockPeriod / 2)) clock = ~clock;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(5, uc_move_tiros_tb);
        // valores iniciais
        clock = 1'b0;
        reset = 1'b1;
        movimenta_tiro = 1'b0;
        loaded_tiro = 1'b0;
        rco_contador_tiro = 1'b0;
        x_borda_min_tiro = 1'b0;
        y_borda_min_tiro = 1'b0;
        x_borda_max_tiro = 1'b0;
        y_borda_max_tiro = 1'b0;
        opcode_tiro = 2'b00;
        #(2*clockPeriod)

        reset = 1'b0;
        #(2*clockPeriod)

        movimenta_tiro = 1'b1;
        rco_contador_tiro = 1'b1;
        #(4*clockPeriod)

        loaded_tiro = 1'b1;
        opcode_tiro = 2'b00;
        x_borda_max_tiro = 1'b1;
        rco_contador_tiro = 1'b0;
        #(6*clockPeriod)

        loaded_tiro = 1'b1;
        #(clockPeriod)

        opcode_tiro = 2'b01;
        #(2*clockPeriod)

        opcode_tiro = 2'b00;
        x_borda_min_tiro = 1'b0;
        rco_contador_tiro = 1'b1;
        movimenta_tiro = 1'b0;
        #(10*clockPeriod)

        $finish;
    end

endmodule