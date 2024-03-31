module memoria_tiro(
    input        clk,
    input        we,
    input  [9:0] data,
    input  [3:0] addr,
    output [9:0] q
);

    // Variavel RAM (armazena dados)
    reg [9:0] ram[15:0];

    // Registra endereco de acesso
    reg [3:0] addr_reg;

    // Especifica conteudo inicial da RAM
    // a partir da leitura de arquivo usando $readmemb
    initial begin
        ram[4'b0] =  10'b0000_0000_00;
        ram[4'd1] =  10'b0000_0000_11;
        ram[4'd2] =  10'b0000_0000_10;
        ram[4'd3] =  10'b0000_0000_01;
        ram[4'd4] =  10'b0000_0000_11;
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