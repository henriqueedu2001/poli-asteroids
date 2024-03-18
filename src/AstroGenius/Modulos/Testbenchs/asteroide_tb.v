`timescale 1ns/1ns

module asteroide_tb;
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

    reg new_load;
    reg new_destruido;


    wire colisao;
    wire rco_contador;
    wire [1:0] opcode;
    wire destruido;
    wire loaded;

    //saidas que podem ser retiradas
    wire [3:0] db_contador;
    wire [4:0] db_wire_saida_som_sub;

asteroide uut(
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

    .new_load(new_load),
    .new_destruido(new_destruido),

    .colisao(colisao),
    .rco_contador(rco_contador),
    .opcode(opcode),
    .destruido(destruido),
    .loaded(loaded),

    .db_contador(db_contador),

    .db_wire_saida_som_sub(db_wire_saida_som_sub)
);

    initial begin
        // Add test stimulus here
        $dumpfile("asteroide_tb.vcd");
        $dumpvars(5, asteroide_tb);

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
    new_load = 1'b0;
    new_destruido = 1'b0;

    #100
    // incrementa o y

    //reseta o contador
    reset_cont = 1'b1;
    clock = 1'b1;

    #100
    reset_cont = 1'b0;
    clock = 1'b0;

    // seleciona os muxs

    select_mux_pos = 2'b10;
    select_mux_coor = 1'b1;
    enable_mem_aste = 1'b0;
    enable_reg_nave = 1'b1;

    #100
    clock = ~clock;

    #100
    enable_mem_aste = 1'b1;
    clock = ~clock;


    #100
    clock = ~clock;

    #100
    clock = ~clock;

    #100
    clock = ~clock;


    #100
    clock = ~clock;


    #100
    clock = ~clock;


    #100
    clock = ~clock;


    #100
    clock = ~clock;

    #100
    clock = ~clock;

    #100
    clock = ~clock;

    #100
    clock = ~clock;

    #100
    clock = ~clock;


    #100
    clock = ~clock;


    #100
    clock = ~clock;


    #100
    clock = ~clock;


    #100
    clock = ~clock;


    #100
    clock = ~clock;


    #100
    clock = ~clock;


    #100
    clock = ~clock;


    #100
    clock = ~clock;


    #100
    clock = ~clock;




    $finish;



    end

endmodule
