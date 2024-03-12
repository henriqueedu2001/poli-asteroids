`include "astro_genius.v"
`timescale 1ns/1ns

module astro_genius_tb;




reg clock_in;
reg iniciar_in;
reg reset_in;
reg jogada_in; 

wire tiro_out;
wire colisao_out;
wire acertou_out;
wire perdeu_out;

// depuração
wire db_up_out;
wire db_down_out;
wire db_right_out;
wire db_left_out;
wire db_special_out;
wire db_shot_out;

wire db_estado_out;
wire db_num_vidas_out;
wire db_asteroide_x_out;
wire db_asteroide_y_out;

astro_genius UUT(
    .clock         (clock_in),
    .iniciar       (iniciar_in),
    .reset         (reset_in),
    .jogada        (jogada_in), 

    .tiro          (tiro_out),
    .colisao       (colisao_out),
    .acertou       (acertou_out),
    .perdeu        (perdeu_out),

    // depuração
    .db_up         (db_up_out),
    .db_down       (db_down_out),
    .db_right      (db_right_out),
    .db_left       (db_left_out),
    .db_special    (db_special_out),
    .db_shot       (db_shot_out),
    
    .db_estado     (db_estado_out),
    .db_num_vidas  (db_num_vidas_out),
    .db_asteroide_x(db_asteroide_x_out),
    .db_asteroide_y(db_asteroide_y)
);

parameter clockPeriod = 20; // in ns, f=1KHz

// Gerador de clock
always #((clockPeriod / 2)) clock_in = ~clock_in;

initial begin
    // somente incrementar o clock
    // valores iniciais
    clock_in = 1'b0;
    iniciar_in = 1'b0;
    reset_in = 1'b0;
    jogada_in = 1'b0; 
    #(clockPeriod)

    // resetar o circuito
    clock_in = 1'b1;
    #(clockPeriod)
    clock_in = 1'b0;

    // iniciar p circuito
    iniciar_in = 1'b1;
    #(clockPeriod)
    iniciar_in = 1'b0;

    #(30*clockPeriod)


end


endmodule