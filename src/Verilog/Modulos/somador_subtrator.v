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