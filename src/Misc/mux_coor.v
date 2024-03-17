
module mux_coor #(parameter N = 4)(
        input [1:0] select_mux_coor,
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

        assign saida_mux = select_mux_coor == posicao_op_random ? {random_x, random_y, random_opcode}      : 
                           select_mux_coor == resul_soma_coor_x ? {resul_soma, mem_coor_y, mem_opcode} :
                           select_mux_coor == resul_soma_coor_y ? {mem_coor_x, resul_soma, mem_opcode} : {mem_coor_x, mem_coor_y, mem_opcode};
endmodule