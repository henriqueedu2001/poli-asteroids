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
    .colisao                (colisao),
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
            .tiro(tiro),
            .colisao(colisao),
            .acertou(acertou),
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


module fluxo_dados(
    input clock,
    input [5:0] jogada, 
    

    // implementa o movimento dos astros
    input clear_reg_asteroide,
    input enable_reg_asteroide_x,
    input enable_reg_asteroide_y,
    input select_mux_coor,
    input select_mux_incremento,
    input select_sum_sub,

    // implementa o decremento de vidas
    input clear_decrementer,
    input load_decrementer,
    input ent_decrementer,
    

    output tiro, //
    output colisao, 
    output acertou, //
    output vidas,
    
    //depuração
    output db_up,
    output db_down,
    output db_right,
    output db_left,
    output db_special,
    output db_shot,

    output [3:0] db_num_vidas
    



);
         
         
wire [3:0] mux_incremento_out; 

wire [3:0] asteroide_coor_x, asteroide_coor_y;

wire [3:0] demux_coor_out;
wire [4:0] sum_sub_out;

wire [3:0] nave_coor_x, nave_coor_y;

wire [3:0] mux_coordenada_out;

wire wire_x_aste_igual_x_nave, wire_y_aste_igual_y_nave;

wire [3:0] num_vidas;

wire rco_decrementer;

wire [5:0] out_reg_jogada;



or (vidas, num_vidas[3], num_vidas[2], num_vidas[1], num_vidas[0]);

// define a posição da nave
assign nave_coor_x = 4'b0001;
assign nave_coor_y = 4'b0000;

assign db_up = out_reg_jogada[5];
assign db_down = out_reg_jogada[4];
assign db_right = out_reg_jogada[3];
assign db_left = out_reg_jogada[2];
assign db_special = out_reg_jogada[1];
assign db_shot = out_reg_jogada[0];

// assign num_vidas = db_num_vidas


assign colisao = (wire_x_aste_igual_x_nave && wire_y_aste_igual_y_nave) ? 1'b1 : 1'b0;


registrador_n #(6) reg_jogada (
    .clock  (clock),
    .clear  (clear_reg_jogada),
    .enable (enable_reg_jogada),
    .D      (jogada),
    .Q      (out_reg_jogada)
);


registrador_n #(4) reg_x_asteroide (
    .clock  (clock),
    .clear  (clear_reg_asteroide),
    .enable (enable_reg_asteroide_x),
    .D      ({sum_sub_out[3:0]}),
    .Q      (asteroide_coor_x)
);

registrador_n #(4) reg_y_asteroide (
    .clock  (clock),
    .clear  (clear_reg_asteroide),
    .enable (enable_reg_asteroide_y),
    .D      ({sum_sub_out[3:0]}),
    .Q      (asteroide_coor_y)
);

//mux que seleciona a coordenada a ser incrementada/decrementada
assign mux_coordenada_out = select_mux_coor ? asteroide_coor_x : asteroide_coor_y;

//mux que seleciona o incremento/decremento da coordenada
assign mux_incremento_out = select_mux_incremento ? 4'd2 : 4'd1;

somador_subtrator #(4) somador_subtrator(
                    .a      (mux_coordenada_out),
                    .b      (mux_incremento_out),
                    .select (select_sum_sub),
                    .resul  (sum_sub_out)
                    );

comparador_85 #(4) comparador_x (
                    .A    (asteroide_coor_x),
                    .B    (nave_coor_x),
                    .ALBi (),
                    .AGBi (),
                    .AEBi (1'b1),
                    .ALBo (),
                    .AGBo (),
                    .AEBo (wire_x_aste_igual_x_nave)
                    );

comparador_85 #(4) comparador_y (
                    .A    (asteroide_coor_y),
                    .B    (nave_coor_y),
                    .ALBi (),
                    .AGBi (),
                    .AEBi (1'b1),
                    .ALBo (),
                    .AGBo (),
                    .AEBo (wire_y_aste_igual_y_nave)
                    );


decrementer #(4) decrementer (
                .clock(clock), 
                .clr  (clear_decrementer), 
                .ld   (load_decrementer), 
                .ent  (ent_decrementer), 
                .enp  (1'b1 && ~rco_decrementer), 
                .D    (4'd3), 
                .Q    (num_vidas), 
                .rco  (rco_decrementer)
                );

endmodule


module unidade_controle (
    input clock,
    input reset,
    
    input iniciar,
    input tiro,
    input colisao,
    input acertou,
    input vidas,
    output reg clear_reg_asteroide,
    output reg enable_reg_asteroide_x,
    output reg clear_decrementer,
    output reg ent_decrementer,
    output reg select_mux_coor,
    output reg select_mux_incremento,
    output reg select_sum_sub,

    //db
    output reg db_estado
);
    
    /* declaração dos estados dessa UC */
    parameter inicio                = 6'b000000; // 0
    parameter inicializa_elementos  = 6'b000001; // 1
    parameter gera_asteroide        = 6'b000010; // 2
    parameter espera_jogada         = 6'b000011; // 3
    parameter registra_jogada       = 6'b000100; // 4
    parameter compara_jogada        = 6'b000101; // 5
    parameter destroi_asteroide     = 6'b000110; // 6
    parameter proxima_jogada        = 6'b000111; // 7
    parameter perde_vida            = 6'b001000; // 8
    parameter compara_vidas         = 6'b001001; // 9
    parameter fim_do_jogo           = 6'b001010; // 10


    // Variáveis de estado
    reg [3:0] estado_atual, proximo_estado;

    // Memória de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            estado_atual <= inicio;
        else
            estado_atual <= proximo_estado;
    end

    always @* begin
        case (estado_atual)
            inicio:               proximo_estado = iniciar ? inicializa_elementos : inicio;
            inicializa_elementos: proximo_estado = gera_asteroide; 
            gera_asteroide:       proximo_estado = espera_jogada;
            espera_jogada:        proximo_estado = tiro ? registra_jogada : colisao ? perde_vida : espera_jogada;
            registra_jogada:      proximo_estado = compara_jogada;
            compara_jogada:       proximo_estado = acertou ? destroi_asteroide : proxima_jogada;
            destroi_asteroide:    proximo_estado = gera_asteroide;
            proxima_jogada:       proximo_estado = espera_jogada;
            perde_vida:		      proximo_estado = compara_vidas; 
            compara_vidas:		  proximo_estado = vidas ? gera_asteroide : fim_do_jogo;
            fim_do_jogo:          proximo_estado = iniciar ? inicializa_elementos : fim_do_jogo;
            default:              proximo_estado = inicio;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin
	 
		
        clear_reg_asteroide    =   (estado_atual == inicio               ||
                                    estado_atual == inicializa_elementos ) ? 1'b1 : 1'b0;

        enable_reg_asteroide_x =   (estado_atual == gera_asteroide       ||
                                    estado_atual == espera_jogada        ||
                                    estado_atual == registra_jogada      ) ? 1'b1 : 1'b0;

        clear_decrementer      =   (estado_atual == inicio               ||
                                    estado_atual == inicializa_elementos ) ? 1'b1 : 1'b0;
        
        ent_decrementer        =   (estado_atual == perde_vida           ) ? 1'b1 : 1'b0;

        select_mux_coor        =   (estado_atual == inicio               ||
                                    estado_atual == inicializa_elementos ||
                                    estado_atual == gera_asteroide       ||
                                    estado_atual == espera_jogada        ||
                                    estado_atual == registra_jogada      ) ? 1'b0 : 1'b1;
        
        select_mux_incremento  =   (estado_atual == inicio               ||
                                    estado_atual == inicializa_elementos ||
                                    estado_atual == gera_asteroide       ||
                                    estado_atual == espera_jogada        ||
                                    estado_atual == registra_jogada      ) ? 1'b0 : 1'b1;

        select_sum_sub         =   (estado_atual == inicio               ||
                                    estado_atual == inicializa_elementos ||
                                    estado_atual == gera_asteroide       ||
                                    estado_atual == espera_jogada        ||
                                    estado_atual == registra_jogada      ) ? 1'b0 : 1'b1;

        // Saída de depuração (estado)
        case (estado_atual)

            inicio:                db_estado = 6'b000000; // 0
            inicializa_elementos:  db_estado = 6'b000001; // 1
            gera_asteroide:        db_estado = 6'b000010; // 2
            espera_jogada:         db_estado = 6'b000011; // 3
            registra_jogada:       db_estado = 6'b000100; // 4
            compara_jogada:        db_estado = 6'b000101; // 5
            destroi_asteroide:     db_estado = 6'b000110; // 6
            proxima_jogada:        db_estado = 6'b000111; // 7
            perde_vida:            db_estado = 6'b001000; // 8
			compara_vidas:         db_estado = 6'b001001; // 9
            fim_do_jogo:           db_estado = 6'b001010; // 10
            default:               db_estado = 6'b000000; 
        endcase
    end

endmodule


// modulo que decrementa em 1 a cada boda de subida caso ent, enp sejam HIGH

module decrementer #(parameter N=4) ( 
                      input clock       , 
                      input clr         , 
                      input ld          , 
                      input ent         , 
                      input enp         , 
                      input [N-1:0] D     , 
                      output reg [N-1:0] Q , 
                      output reg rco
                    );

	 initial begin
		Q = 3;
    end
    

    always @ (posedge clock)
        if (clr)                           Q <= 3;
        else if (ld)                       Q <= D;
        else if (ent && enp &&  Q != 0)    Q <= Q - 1;
        else                               Q <= Q;
 
    always @ (Q or ent)
        if (ent && (Q == 0))       rco = 1;
        else                       rco = 0;

endmodule


//registrador_n #(N = 5)(

// )
module registrador_n #(parameter N = 4)(
    input        clock ,
    input        clear ,
    input        enable,
    input  [N-1:0] D     ,
    output [N-1:0] Q
);

    reg [N-1:0] IQ;

    always @(posedge clock or posedge clear) begin
        if (clear)
            IQ <= 0;
        else if (enable)
            IQ <= D;
    end

    assign Q = IQ;

endmodule

module comparador_85 #(parameter N = 4)(
                input [N-1:0] A, 
                input [N-1:0] B,
                input       ALBi, 
                input       AGBi, 
                input       AEBi,  
                output      ALBo, 
                output      AGBo, 
                output      AEBo
                );

    wire[N:0]  CSL, CSG;

    assign CSL  = ~A + B + ALBi;
    assign ALBo = ~CSL[N];
    assign CSG  = A + ~B + AGBi;
    assign AGBo = ~CSG[N];
    assign AEBo = ((A == B) && AEBi);

endmodule 


// modulo que implementa o somador/subtrator, caso select seja um então ocorre a soma
// caso seja 0 então ocorre a subtração

module somador_subtrator #(parameter N=4) ( 
                          input [N-1:0] a,
                          input [N-1:0] b,
                          input select,
                          output [N:0] resul
                    );

  reg [N:0] res;


  always@(*) begin
    if(~select) res = a + b;
    else res = a-b;
  end

  assign resul = res;


  // assign resul = select ? a + b : a - b;

endmodule