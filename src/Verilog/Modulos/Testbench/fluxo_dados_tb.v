module fluxo_dados_tb;
    reg clock;
    reg [5:0] jogada; 

    // implementa o movimento dos astros
    reg clear_reg_asteroide;
    reg enable_reg_asteroide_x;
    reg enable_reg_asteroide_y;
    reg select_mux_coor;
    reg select_mux_incremento;
    reg select_sum_sub;

    // implementa o decremento de vidas
    reg clear_decrementer;
    reg load_decrementer;
    reg ent_decrementer;

    wire tiro; //
    wire colisao; 
    wire acertou; //
    wire vidas;
    
    //depuração
    wire db_up;
    wire db_down;
    wire db_right;
    wire db_left;
    wire db_special;
    wire db_shot;

    wire [3:0] db_num_vidas;

    parameter clockPeriod = 20; // in ns, f=1KHz

    // Gerador de clock
    always #((clockPeriod / 2)) clock = ~clock;

    fluxo_dados UUT (
        .clock(clock),
        .jogada(jogada), 
        
        // implementa o movimento dos astros
        .clear_reg_asteroide(clear_reg_asteroide),
        .enable_reg_asteroide_x(enable_reg_asteroide_x),
        .enable_reg_asteroide_y(enable_reg_asteroide_y),
        .select_mux_coor(select_mux_coor),
        .select_mux_incremento(select_mux_incremento),
        .select_sum_sub(select_sum_sub),

        // implementa o decremento de vidas
        .clear_decrementer(clear_decrementer),
        .load_decrementer(load_decrementer),
        .ent_decrementer(ent_decrementer),
        

        .tiro(tiro), //
        .colisao(colisao), 
        .acertou(acertou), //
        .vidas(vidas),
        
        //depuração
        .db_up(db_up),
        .db_down(db_down),
        .db_right(db_right),
        .db_left(db_left),
        .db_special(db_special),
        .db_shot(db_shot),
        .db_num_vidas(db_num_vidas)
        
    );

    initial begin
        $dumpfile("fluxo_dados_tb.vcd");
        $dumpvars(5, fluxo_dados_tb);

        $monitor("colisao = %d", colisao);

        clock = 0;

        // teste para o movimento dos astros

        // valores iniciais
        clear_reg_asteroide = 1'b0;
        enable_reg_asteroide_x = 1'b0;
        enable_reg_asteroide_y = 1'b0;
        clear_decrementer = 1'b0;
        load_decrementer = 1'b0;
        ent_decrementer = 1'b0;
        select_mux_coor = 1'b0;
        select_mux_incremento = 1'b0;
        select_sum_sub = 1'b0;
        #(clockPeriod)

        //inicializa elementos
        clear_reg_asteroide = 1'b1;
        enable_reg_asteroide_x = 1'b0;
        enable_reg_asteroide_y = 1'b0;
        clear_decrementer = 1'b0;
        load_decrementer = 1'b0;
        ent_decrementer = 1'b0;
        select_mux_coor = 1'b0;
        select_mux_incremento = 1'b0;
        select_sum_sub = 1'b0;
        #(clockPeriod)
        clear_reg_asteroide = 1'b0;

        //realiza o calculo x do asteroide em 1
        select_mux_coor = 1'b0;       //seleciona a coordenada X
        select_mux_incremento = 1'b0; //seleciona o incremento 1
        select_sum_sub = 1'b0;        //seleciona a opção de somar
        #(clockPeriod)

        //realiza o salvamento do calculo na coordenada x
        enable_reg_asteroide_x = 1'b1;
        #(clockPeriod)
        enable_reg_asteroide_x = 1'b0;

        ent_decrementer = 1'b1;        //realiza o decremento de vidas
        #(clockPeriod)
        ent_decrementer = 1'b0;

        clear_reg_asteroide = 1'b1; //reseta o reg do asteroide
        #(clockPeriod)
        clear_reg_asteroide = 1'b0;

        select_mux_coor = 1'b0;       //seleciona a coordenada X
        select_mux_incremento = 1'b0; //seleciona o incremento 1
        select_sum_sub = 1'b0;        //seleciona a opção de somar
        #(clockPeriod)

        //realiza o salvamento do calculo na coordenada x
        enable_reg_asteroide_x = 1'b1;
        #(clockPeriod)
        enable_reg_asteroide_x = 1'b0;

        ent_decrementer = 1'b1;        //realiza o decremento de vidas
        #(clockPeriod)
        ent_decrementer = 1'b0;

        clear_reg_asteroide = 1'b1; //reseta o reg do asteroide
        #(clockPeriod)
        clear_reg_asteroide = 1'b0;
        
        select_mux_coor = 1'b0;       //seleciona a coordenada X
        select_mux_incremento = 1'b0; //seleciona o incremento 1
        select_sum_sub = 1'b0;        //seleciona a opção de somar
        #(clockPeriod)

        //realiza o salvamento do calculo na coordenada x
        enable_reg_asteroide_x = 1'b1;
        #(clockPeriod)
        enable_reg_asteroide_x = 1'b0;

        ent_decrementer = 1'b1;        //realiza o decremento de vidas
        #(clockPeriod)
        ent_decrementer = 1'b0;

        clear_reg_asteroide = 1'b1; //reseta o reg do asteroide
        #(clockPeriod)
        clear_reg_asteroide = 1'b0;

        $finish;

    end
endmodule