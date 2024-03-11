module astro_genius(
    input clock,
    input iniciar,
    input reset,
    input [5:0] jogada,

    output tiro,
    output colisao,
    output acertou,
    output vidas,
    output db_up,
    output db_down,
    output db_right,
    output db_left,
    output db_special,
    output db_shot,
    output [3:0]db_num_vidas
);

wire clear_reg_asteroide;
wire enable_reg_asteroide_x;
wire enable_reg_asteroide_y;
wire select_mux_coor;
wire select_mux_incremento;
wire select_sum_sub;
wire clear_decrementer;
wire load_decrementer;
wire ent_decrementer;

wire wire_colisao;

assign colisao = wire_colisao;



fluxo_dados fd (
    // inputs
    .clock                  (clock),
    .jogada                 (jogada),

    // implementa o movimento dos astros
    .clear_reg_asteroide    (clear_reg_asteroide),
    .enable_reg_asteroide_x (enable_reg_asteroide_x),
    .enable_reg_asteroide_y (enable_reg_asteroide_y),
    .select_mux_coor        (select_mux_coor),
    .select_mux_incremento  (select_mux_incremento),
    .select_sum_sub         (select_sum_sub),

    // implementa o decremento de vidas
    .clear_decrementer      (clear_decrementer),
    .load_decrementer       (load_decrementer),
    .ent_decrementer        (ent_decrementer),

    // outputs
    .tiro                   (tiro),
    .colisao                (wire_colisao),
    .acertou                (acertou),
    .vidas                  (vidas),
    .db_up                  (db_up),
    .db_down                (db_down),
    .db_right               (db_right),
    .db_left                (db_left),
    .db_special             (db_special),
    .db_shot                (db_shot),
    .db_num_vidas           (db_num_vidas)
);

unidade_controle uc (
            //inputs
            .clock(clock),
            .reset(reset),
            
            .iniciar(iniciar),
            .tiro(1'b0),
            .colisao(wire_colisao),
            .acertou(1'b0),
            .vidas(vidas),
            .clear_reg_asteroide(clear_reg_asteroide),
            .enable_reg_asteroide_x(enable_reg_asteroide_x),
            .clear_decrementer(clear_decrementer),
            .ent_decrementer(ent_decrementer),
            .select_mux_coor(select_mux_coor),
            .select_mux_incremento(select_mux_incremento),
            .select_sum_sub(select_sum_sub),

            //db
            .db_estado(db_estado)
        );

endmodule