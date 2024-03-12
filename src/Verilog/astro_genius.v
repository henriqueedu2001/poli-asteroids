module astro_genius(
    input clock,
    input iniciar,
    input reset,
    input [5:0] jogada, // 4 primeiros para up, down, left, right, 2 últimos para ataque

    output tiro,
    output colisao,
    output acertou,
    output perdeu,

    // depuração
    output db_up,
    output db_down,
    output db_right,
    output db_left,
    output db_special,
    output db_shot,
    
    output [6:0] db_estado,
    output [6:0] db_num_vidas,
    output [6:0] db_asteroide_x,
    output [6:0] db_asteroide_y
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
wire clear_reg_jogada, enable_reg_jogada;
wire wire_colisao;
wire [3:0] wire_db_vidas;
wire [5:0] wire_db_estado;
wire [3:0] db_asteroide_coor_x;
wire [3:0] db_asteroide_coor_y;

assign colisao = wire_colisao;


fluxo_dados fd (
    // inputs
    .clock                  (clock),
    .jogada                 (jogada),

    // implementa o movimento dos astros
    .clear_reg_asteroide    (clear_reg_asteroide),
    .enable_reg_asteroide_x (enable_reg_asteroide_x),
    .enable_reg_asteroide_y (enable_reg_asteroide_y),
    .clear_reg_jogada       (clear_reg_jogada),
    .enable_reg_jogada      (enable_reg_jogada),
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
    .db_num_vidas           (wire_db_vidas),
    .db_asteroide_coor_x    (db_asteroide_coor_x),
    .db_asteroide_coor_y    (db_asteroide_coor_y)
);

unidade_controle uc (
    //inputs
    .clock(clock),
    .reset(reset),
    
    .iniciar               (iniciar),
    .tiro                  (1'b1),
    .colisao               (wire_colisao),
    .acertou               (1'b0),
    .vidas                 (vidas),
    .clear_reg_asteroide   (clear_reg_asteroide),
    .enable_reg_asteroide_x(enable_reg_asteroide_x),
    .clear_reg_jogada      (clear_reg_jogada),
    .enable_reg_jogada     (enable_reg_jogada),
    .clear_decrementer     (clear_decrementer),
    .ent_decrementer       (ent_decrementer),
    .select_mux_coor       (select_mux_coor),
    .select_mux_incremento (select_mux_incremento),
    .select_sum_sub        (select_sum_sub),
    //db
    .perdeu (perdeu),
    .db_estado(wire_db_estado)
);

// Display para exibir a quantidade de vidas
hexa7seg HEX0 (
    .hexa    (wire_db_vidas),
    .display (db_num_vidas)
);

// Display para exibir os estados
hexa7seg HEX1 (
    .hexa    (wire_db_estado[3:0]),
    .display (db_estado)
);

// Display para exibir as posicoes do asteroide x
hexa7seg HEX2 (
    .hexa    (db_asteroide_coor_x),
    .display (db_asteroide_x)
);

// Display para exibir as posicoes do asteroide y
hexa7seg HEX3 (
    .hexa    (db_asteroide_coor_y),
    .display (db_asteroide_y)
);

endmodule