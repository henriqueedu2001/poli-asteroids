module param_ram #(parameter addr_width = 4, 
                   parameter data_width = 8, 
                   parameter depth = 16) 
    (
    input clk,
    input we,
    input [data_width-1:0] data,
    input [addr_width-1:0] addr,
    output reg [data_width-1:0] q
);

reg [data_width-1:0] ram [depth-1:0];
reg [addr_width-1:0] addr_reg;

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