// modulo que implementa o somador/subtrator, caso select seja um então ocorre a soma
// caso seja 0 então ocorre a subtração

module somador_subtrator  ( input [3:0] a,
                            input [3:0]  b,
                            input select,
                            output [4:0] resul
                    );

  assign resul = select ? a + b : a - b;


endmodule