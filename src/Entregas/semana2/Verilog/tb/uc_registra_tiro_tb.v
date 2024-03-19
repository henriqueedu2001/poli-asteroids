`timescale 1ns / 1ns

module uc_registra_tiro_tb;

    // Signals
    reg clock;
    reg registra_tiro;
    reg reset;
    reg loaded_tiro;
    reg rco_contador_tiro;
    wire enable_mem_tiro;
    wire enable_load_tiro;
    wire new_load;
    wire clear_contador_tiro;
    wire conta_contador_tiro;
    wire [1:0] select_mux_pos;
    wire tiro_registrado;
    wire [3:0] db_estado_registra_tiro;

    // Instantiate the module
    uc_registra_tiro dut (
        .clock(clock),
        .registra_tiro(registra_tiro),
        .reset(reset),
        .loaded_tiro(loaded_tiro),
        .rco_contador_tiro(rco_contador_tiro),
        .enable_mem_tiro(enable_mem_tiro),
        .enable_load_tiro(enable_load_tiro),
        .new_load(new_load),
        .clear_contador_tiro(clear_contador_tiro),
        .conta_contador_tiro(conta_contador_tiro),
        .select_mux_pos(select_mux_pos),
        .tiro_registrado(tiro_registrado),
        .db_estado_registra_tiro(db_estado_registra_tiro)
    );

    parameter clockPeriod = 2; // in ns, f=1KHz

    // Gerador de clock
    always #((clockPeriod / 2)) clock = ~clock;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(5, uc_registra_tiro_tb);
        // valores iniciais
        clock = 1'b0;
        reset = 1'b1;
        registra_tiro = 1'b0;
        loaded_tiro = 1'b0;
        rco_contador_tiro = 1'b0;

        #(2*clockPeriod)

        reset = 1'b0;
        #(2*clockPeriod)

        registra_tiro = 1'b1;
        loaded_tiro = 1'b1;
        rco_contador_tiro = 1'b0;
        #(4*clockPeriod)

        loaded_tiro = 1'b0;
        registra_tiro = 1'b0;
        #(10*clockPeriod)

        $finish;
    end

endmodule