`timescale 1ns/1ns

module tiro_tb;
    reg clock;
    reg conta_contador;
    reg reset_cont;
    reg [1:0] select_mux_pos;
    reg select_mux_coor;
    reg select_soma_sub;
    reg enable_reg_nave;
    reg reset_reg_nave;
    reg enable_mem_aste;
    reg enable_mem_load;

    reg [3:0] aste_coor_x;
    reg [3:0] aste_coor_y;

    wire x_borda_min;
    wire y_borda_min;
    wire x_borda_max;
    wire y_borda_max;

    reg new_load;
    reg new_destruido;

    wire colisao;
    wire rco_contador;
    wire [1:0] opcode;
    // output destruido;
    wire loaded;

    wire [3:0] db_contador;
    wire [4:0] db_wire_saida_som_sub;

    parameter clockPeriod = 20; // in ns, f=1KHz

    // Gerador de clock
    always #((clockPeriod / 2)) clock = ~clock;






    tiro tiro(
        .clock(clock),
        .conta_contador(conta_contador),
        .reset_cont(reset_cont),
        .select_mux_pos(select_mux_pos),
        .select_mux_coor(select_mux_coor),
        .select_soma_sub(select_soma_sub),
        .enable_reg_nave(enable_reg_nave),
        .reset_reg_nave(reset_reg_nave),
        .enable_mem_aste(enable_mem_aste),
        .enable_mem_load(enable_mem_load),

        .aste_coor_x(aste_coor_x),
        .aste_coor_y(aste_coor_y),

        .x_borda_min(x_borda_min),
        .y_borda_min(y_borda_min),
        .x_borda_max(x_borda_max),
        .y_borda_max(y_borda_max),

        .new_load(new_load),
        .new_destruido(new_destruido),

        .colisao(colisao),
        .rco_contador(rco_contador),
        .opcode(opcode),
        
        .loaded(loaded),

        .db_contador(db_contador),
        .db_wire_saida_som_sub(db_wire_saida_som_sub)

    );

    initial begin

        // Add test stimulus here
        $dumpfile("tiro_tb.vcd");
        $dumpvars(5, tiro_tb);

        // valores iniciais
        clock = 1'b0;
        conta_contador = 1'b0;
        reset_cont = 1'b0;
        select_mux_pos = 2'b00;
        select_mux_coor = 1'b0;
        select_soma_sub = 1'b0;
        enable_reg_nave = 1'b0;
        reset_reg_nave = 1'b0;
        enable_mem_aste = 1'b0;
        enable_mem_load = 1'b0;

        aste_coor_x = 4'b0000;
        aste_coor_y = 4'b0000;



        new_load = 1'b0;
        new_destruido = 1'b0;

        // reset no contador
        #(clockPeriod)
        aste_coor_x = 4'b0111;
        aste_coor_y = 4'b0000;
        reset_cont = 1'b1;

        // salva o tiro
        #(clockPeriod)
        reset_cont = 1'b0;
        select_mux_pos = 2'b00;
        enable_mem_aste = 1'b1;

        #(clockPeriod)

        $finish;



    end


endmodule