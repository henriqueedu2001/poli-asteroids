module memoria_load_aste(
    input        clk,
    input        we,
    input        clear,
    input  [1:0] data,
    input  [3:0] addr,
    output [1:0] q
);
    integer i;
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
        if (we && ~clear)
            ram[addr] <= data;
        
        if (clear) begin
            for (i = 0; i < 16; i = i + 1) begin
                ram[i] = 2'b00;
            end
        end

        addr_reg <= addr;
    end

    // Atribuicao continua retorna dado
    assign q = ram[addr_reg];

endmodule