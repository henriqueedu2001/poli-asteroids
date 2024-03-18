module asteroide(
    input clock,
    input conta_contador,
    input reset_cont,
    input [1:0] select_mux_pos,
    input select_mux_coor,
    input select_soma_sub,
    input enable_reg_nave,
    input reset_reg_nave,
    input enable_mem_aste,
    input enable_mem_load,

    input new_load,
    input new_destruido,

    output colisao,
    output rco_contador,
    output [1:0] opcode,
    output destruido,
    output loaded,

    output [3:0] db_contador,

    output [4:0]db_wire_saida_som_sub
);
         
    wire [3:0] wire_saida_contador;
    wire [3:0] wire_saida_mux_coor;     
    wire [9:0] wire_saida_memoria_aste;
    wire wire_select_som_sub;
    wire [4:0] wire_saida_som_sub;
    wire wire_saida_comparador_x;
    wire wire_saida_comparador_y;
    wire [9:0] wire_saida_reg_nave;
    wire [1:0] memoria_loaded;
    wire wire_rco_contador;

    assign db_contador = wire_saida_contador;
    assign db_wire_saida_som_sub = wire_saida_som_sub;

    assign loaded = memoria_loaded[1];
    assign destruido = memoria_loaded[0];
    assign opcode = wire_saida_memoria_aste[1:0];
    assign rco_contador = wire_rco_contador;
    assign wire_select_som_sub = select_soma_sub;

contador_m #(16, 4) contador(
    /* inputs */
    .clock   (clock),
    .zera_as (reset_cont),
    .zera_s  (),
    .conta   (conta_contador),
   /* outputs */
    .Q       (wire_saida_contador),
    .fim     (wire_rco_contador),
    .meio    ()
);

mux_pos #(4) mux (
    /* inputs */
    .select_mux_pos (select_mux_pos),
    .resul_soma      (wire_saida_som_sub[3:0]),
    .mem_coor_x      (wire_saida_memoria_aste[9:6]),
    .mem_coor_y      (wire_saida_memoria_aste[5:2]),
    .mem_opcode      (wire_saida_memoria_aste[1:0]),
    .random_x        (),
    .random_y        (),
    .random_opcode   (),
    /* output */
    .saida_mux       (wire_saida_mux_coor)
);

memoria_aster memoria_aster (
    /* inputs */
    .clk  (clock),
    .we   (enable_mem_aste),
    .data (wire_saida_mux_coor),
    .addr (wire_saida_contador),
    /* output */
    .q    (wire_saida_memoria_aste) 
);

mux_coor #(4) mux_coor(
    .select_mux_coor (select_mux_coor),
    .mem_coor_x      (wire_saida_memoria_aste[9:6]),
    .mem_coor_y      (wire_saida_memoria_aste[5:2]),
    /* output */
    .saida_mux       (wire_saida_mux_coor)
);

somador_subtrator #(4) som_sub (
    /* inputs */
    .a(wire_saida_mux_coor),
    .b(4'b0001),
    .select(wire_select_som_sub),
    /* output */
    .resul(wire_saida_som_sub)
);

comparador_85 #(4) comparador_x (
    
    .A    (wire_saida_memoria_aste[9:6]), 
    .B    (wire_saida_reg_nave[9:6]),
    .ALBi (), 
    .AGBi (), 
    .AEBi (),  
    /* outputs */
    .ALBo (), 
    .AGBo (), 
    .AEBo (wire_saida_comparador_x)
);

comparador_85 #(4) comparador_y (
    /* inputs */
    .A    (wire_saida_memoria_aste[5:2]), 
    .B    (wire_saida_reg_nave[5:2]),
    .ALBi (), 
    .AGBi (), 
    .AEBi (),  
    /* outputs */
    .ALBo (), 
    .AGBo (), 
    .AEBo (wire_saida_comparador_y)
);

and (colisao, wire_saida_comparador_x, wire_saida_comparador_y);

registrador_n #(10) reg_nave (
    /* inputs */
    .clock  (clock)                 ,
    .clear  (reset_reg_nave)        ,
    .enable (enable_reg_nave | 1'b1),
    .D      (10'b0111_0111_00)      ,
    /* output */
    .Q      (wire_saida_reg_nave)
);

memoria_load memoria_load (
    /* inputs */
    .clk  (clock),
    .we   (enable_mem_load),
    .data ({new_load, new_destruido}),
    .addr (wire_saida_contador),
    /* output */
    .q    (memoria_loaded) 
);


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


module memoria_aster(
    input        clk,
    input        we,
    input  [3:0] data,
    input  [3:0] addr,
    output [9:0] q
);

    // Variavel RAM (armazena dados)
    reg [9:0] ram[15:0];

    // Registra endereco de acesso
    reg [3:0] addr_reg;

    // Especifica conteudo inicial da RAM
    // a partir da leitura de arquivo usando $readmemb
    initial 
    begin : INICIA_RAM
        ram[4'b0] =  10'b0111_0000_01;
        ram[4'd1] =  10'b0000_0000_00;
        ram[4'd2] =  10'b0000_0000_00;
        ram[4'd3] =  10'b0000_0000_00;
        ram[4'd4] =  10'b0000_0000_00;
        ram[4'd5] =  10'b0000_0000_00;
        ram[4'd6] =  10'b0000_0000_00;
        ram[4'd7] =  10'b0000_0000_00;
        ram[4'd8] =  10'b0000_0000_00;
        ram[4'd9] =  10'b0000_0000_00;
        ram[4'd10] = 10'b0000_0000_00;
        ram[4'd11] = 10'b0000_0000_00;
        ram[4'd12] = 10'b0000_0000_00;
        ram[4'd13] = 10'b0000_0000_00;
        ram[4'd14] = 10'b0000_0000_00;
        ram[4'd15] = 10'b0000_0000_00;
    end 

    always @ (posedge clk)
    begin
        // Escrita da memoria
        if (we)
            ram[addr] <= data;

        addr_reg <= addr;
    end

    // Atribuicao continua retorna dado
    assign q = ram[addr_reg];

endmodule


module memoria_load(
    input        clk,
    input        we,
    input  [1:0] data,
    input  [3:0] addr,
    output [1:0] q
);

    // Variavel RAM (armazena dados)
    reg [1:0] ram[15:0];

    // Registra endereco de acesso
    reg [3:0] addr_reg;

    // Especifica conteudo inicial da RAM
    // a partir da leitura de arquivo usando $readmemb
    initial 
    begin : INICIA_RAM
        ram[4'b0] =  2'b00;
        ram[4'd1] =  2'b00;
        ram[4'd2] =  2'b00;
        ram[4'd3] =  2'b00;
        ram[4'd4] =  2'b00;
        ram[4'd5] =  2'b00;
        ram[4'd6] =  2'b00;
        ram[4'd7] =  2'b00;
        ram[4'd8] =  2'b00;
        ram[4'd9] =  2'b00;
        ram[4'd10] = 2'b00;
        ram[4'd11] = 2'b00;
        ram[4'd12] = 2'b00;
        ram[4'd13] = 2'b00;
        ram[4'd14] = 2'b00;
        ram[4'd15] = 2'b00;
    end 

    always @ (posedge clk)
    begin
        // Escrita da memoria
        if (we)
            ram[addr] <= data;

        addr_reg <= addr;
    end

    // Atribuicao continua retorna dado
    assign q = ram[addr_reg];

endmodule


module mux_coor #(parameter N = 4)(
        input select_mux_coor,
        input [N-1:0] mem_coor_x,
        input [N-1:0] mem_coor_y,
        output [N-1:0] saida_mux
        );

        parameter select_mem_coor_x = 1'b0;

        assign saida_mux = select_mux_coor == select_mem_coor_x ? mem_coor_x : mem_coor_y;
endmodule


module mux_pos #(parameter N = pos)(
        input [1:0] select_mux_pos,
        input [N-1:0] resul_soma,
        input [N-1:0] mem_coor_x,
        input [N-1:0] mem_coor_y,
        input [1:0]   mem_opcode,
        input [N-1:0] random_x,
        input [N-1:0] random_y,
        input [1:0] random_opcode,
        output [N-1:0] saida_mux
        );

        parameter posicao_op_random = 2'b00;
        parameter resul_soma_coor_x = 2'b01;
        parameter resul_soma_coor_y = 2'b10;

        // 00 - seleciona a posição e opcode randomicos
        // 01 - seleciona o resultado da soma na coordenada X e opcode da memoria (Y da memoria)
        // 10 - seleciona o resultado da soma na coordenada Y e opcode da memoria (X da memoria)

        assign saida_mux = select_mux_pos == posicao_op_random ? {random_x, random_y, random_opcode}  :
                           select_mux_pos == resul_soma_coor_x ? {resul_soma, mem_coor_y, mem_opcode} :
                           select_mux_pos == resul_soma_coor_y ? {mem_coor_x, resul_soma, mem_opcode} : {mem_coor_x, mem_coor_y, mem_opcode};
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





