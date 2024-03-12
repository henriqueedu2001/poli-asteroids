module astro_genius(
    input clock,
    input iniciar,
    input reset,
    input [5:0] jogada, // 4 primeiros para up, down, left, right, 2 últimos para ataque


    input clear_asteroide,

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
    
    output [3:0] db_estado,
    output [3:0] db_num_vidas,
    output [3:0] db_asteroide_x,
    output [3:0] db_asteroide_y
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
    .db_asteroide_coor_y    (db_asteroide_coor_y),

    .clear_asteroide (clear_asteroide)
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


module fluxo_dados(
    input clock,
    input [5:0] jogada, 
    

    input clear_asteroide,

    // implementa o movimento dos astros
    input clear_reg_asteroide,
    input enable_reg_asteroide_x,
    input enable_reg_asteroide_y,
    input clear_reg_jogada,
    input enable_reg_jogada,

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

    output [3:0] db_asteroide_coor_x,
    output [3:0] db_asteroide_coor_y,

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
assign nave_coor_x = 4'b0100;
assign nave_coor_y = 4'b0000;

assign db_up = out_reg_jogada[5];
assign db_down = out_reg_jogada[4];
assign db_right = out_reg_jogada[3];
assign db_left = out_reg_jogada[2];
assign db_special = out_reg_jogada[1];
assign db_shot = out_reg_jogada[0];
assign db_num_vidas = num_vidas;
assign colisao = (wire_x_aste_igual_x_nave && wire_y_aste_igual_y_nave) ? 1'b1 : 1'b0;

assign db_asteroide_coor_x = asteroide_coor_x;
assign db_asteroide_coor_y = asteroide_coor_y;

registrador_n #(6) reg_jogada (
    .clock  (clock),
    .clear  (clear_reg_jogada),
    .enable (enable_reg_jogada),
    .D      (jogada),
    .Q      (out_reg_jogada)
);

wire wire_clear_asteroide;
or (wire_clear_asteroide, clear_asteroide, clear_reg_asteroide);

registrador_n #(4) reg_x_asteroide (
    .clock  (clock),
    .clear  (wire_clear_asteroide ),
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
assign mux_coordenada_out = select_mux_coor ? asteroide_coor_y : asteroide_coor_x;

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

    output reg clear_reg_jogada,
    output reg enable_reg_jogada,

    output reg clear_decrementer,
    output reg ent_decrementer,
    output reg select_mux_coor,
    output reg select_mux_incremento,
    output reg select_sum_sub,

    //db
    output reg perdeu,
    output reg [5:0] db_estado
);
    
    /* declaração dos estados dessa UC */
    parameter inicio                = 6'b000000; // 0
    parameter inicializa_elementos  = 6'b000001; // 1
    parameter gera_asteroide        = 6'b000010; // 2
    parameter espera_jogada         = 6'b000011; // 3
    parameter registra_jogada       = 6'b000100; // 4
    parameter compara_jogada        = 6'b000101; // 5
    // parameter destroi_asteroide     = 6'b000110; // 6
    parameter proxima_jogada        = 6'b000111; // 7
    parameter perde_vida            = 6'b001000; // 8
    parameter compara_vidas         = 6'b001001; // 9
    parameter game_over             = 6'b001010; // 10


    // Variáveis de estado
    reg [3:0] estado_atual, proximo_estado;

    // Memória de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            estado_atual <= inicio;
        else
            estado_atual <= proximo_estado;
    end

    // Lógica de transição de estados
    always @* begin
        case (estado_atual)
            inicio:               proximo_estado = iniciar ? inicializa_elementos : inicio;
            inicializa_elementos: proximo_estado = gera_asteroide; 
            gera_asteroide:       proximo_estado = espera_jogada;

            espera_jogada:        proximo_estado = colisao ? perde_vida : registra_jogada;
            registra_jogada:      proximo_estado = colisao ? perde_vida : compara_jogada;
            compara_jogada:       proximo_estado = colisao ? perde_vida : proxima_jogada;
            proxima_jogada:       proximo_estado = colisao ? perde_vida : espera_jogada;

            perde_vida:		      proximo_estado = compara_vidas; 
            compara_vidas:		  proximo_estado = vidas ? gera_asteroide : game_over;
            game_over:            proximo_estado = iniciar ? inicializa_elementos : game_over;
            default:              proximo_estado = inicio;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin
        clear_reg_asteroide    =   (estado_atual == inicio               ||
                                    estado_atual == inicializa_elementos ||
                                    estado_atual == perde_vida           )? 1'b1 : 1'b0;

        enable_reg_asteroide_x =   (estado_atual == espera_jogada         ||
                                    estado_atual == registra_jogada       ||
                                    estado_atual == compara_jogada        ||
                                    estado_atual == proxima_jogada        )? 1'b1 : 1'b0;

        clear_reg_jogada       =   (estado_atual == inicio               ||
                                    estado_atual == inicializa_elementos  ) ? 1'b1 : 1'b0;

        enable_reg_jogada      =   (estado_atual == registra_jogada) ? 1'b1 : 1'b0;


        clear_decrementer      =   (estado_atual == inicio               ||
                                    estado_atual == inicializa_elementos ) ? 1'b1 : 1'b0;
        
        ent_decrementer        =   (estado_atual == perde_vida           ) ? 1'b1 : 1'b0;

        select_mux_coor        =   (estado_atual == espera_jogada         ||
                                    estado_atual == registra_jogada       ||
                                    estado_atual == compara_jogada        ||
                                    estado_atual == proxima_jogada        )? 1'b0 : 1'b1;


        // select_mux_coor        =    1'b0;
        // select_mux_incremento  =    1'b0;
        // select_sum_sub         =    1'b0;
        
        select_mux_incremento  =   (estado_atual == espera_jogada         ||
                                    estado_atual == registra_jogada       ||
                                    estado_atual == compara_jogada        ||
                                    estado_atual == proxima_jogada        )? 1'b0 : 1'b1;


        select_sum_sub         = (estado_atual == espera_jogada           ||
                                    estado_atual == registra_jogada       ||
                                    estado_atual == compara_jogada        ||
                                    estado_atual == proxima_jogada        )? 1'b0 : 1'b1;


        perdeu                 =   (estado_atual == game_over               ) ? 1'b1 : 1'b0;

        // Saída de depuração (estado)
        case (estado_atual)
            inicio:                db_estado = 6'b000000; // 0
            inicializa_elementos:  db_estado = 6'b000001; // 1
            gera_asteroide:        db_estado = 6'b000010; // 2
            espera_jogada:         db_estado = 6'b000011; // 3
            registra_jogada:       db_estado = 6'b000100; // 4
            compara_jogada:        db_estado = 6'b000101; // 5
            // destroi_asteroide:     db_estado = 6'b000110; // 6
            proxima_jogada:        db_estado = 6'b000111; // 7
            perde_vida:            db_estado = 6'b001000; // 8
			compara_vidas:         db_estado = 6'b001001; // 9
            game_over:             db_estado = 6'b001010; // 10
            default:               db_estado = 6'b000000; 
        endcase
    end

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


module contador_163 #(parameter N = 16, parameter tempo = 2000) ( 
                        input clock, 
                        input clr, 
                        input ld, 
                        input ent, 
                        input enp, 
                        input [N-1:0] D, 
                        output reg [N-1:0] Q, 
                        output reg rco
                    );

    initial begin
        Q = 0;
    end
        
    always @ (posedge clock)
        if (clr)               Q <= 0;
        else if (ld)           Q <= D;
        else if (ent && enp)   Q <= Q + 1;
        else                   Q <= Q;

    always @ (Q or ent)
        if (ent && (Q == tempo))   rco = 1;
        else                       rco = 0;
endmodule


module contador_m #(parameter M=16, N=4)
  (
   input  wire          clock,
   input  wire          zera_as,
   input  wire          zera_s,
   input  wire          conta,
   output reg  [N-1:0]  Q,
   output reg           fim,
   output reg           meio
  );

  always @(posedge clock or posedge zera_as) begin
    if (zera_as) begin
      Q <= 0;
    end else if (clock) begin
      if (zera_s) begin
        Q <= 0;
      end else if (conta) begin
        if (Q == M-1) begin
          Q <= 0;
        end else begin
          Q <= Q + 1;
        end
      end
    end
  end

  // Saidas
  always @ (Q)
      if (Q == M-1)   fim = 1;
      else            fim = 0;

  always @ (Q)
      if (Q == M/2-1) meio = 1;
      else            meio = 0;

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



module hexa7seg (hexa, display);
    input      [3:0] hexa;
    output reg [3:0] display;

    /*
     *    ---
     *   | 0 |
     * 5 |   | 1
     *   |   |
     *    ---
     *   | 6 |
     * 4 |   | 2
     *   |   |
     *    ---
     *     3
     */
        
    always @(hexa)
    case (hexa)
        4'h0:    display = 4'h0;
        4'h1:    display = 4'h1;
        4'h2:    display = 4'h2;
        4'h3:    display = 4'h3;
        4'h4:    display = 4'h4;
        4'h5:    display = 4'h5;
        4'h6:    display = 4'h6;
        4'h7:    display = 4'h7;
        4'h8:    display = 4'h8;
        4'h9:    display = 4'h9;
        4'ha:    display = 4'ha;
        4'hb:    display = 4'hb;
        4'hc:    display = 4'hc;
        4'hd:    display = 4'hd;
        4'he:    display = 4'he;
        4'hf:    display = 4'hf;
        default: display = 4'h0;
    endcase
endmodule


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
