`timescale 1ns/1ns
`include "../somador_subtrator.v"
module somador_subtrator_tb;

//entradas
reg [3:0]  a_in     ;
reg [3:0]  b_in     ;
reg        select_in;

//saidas
wire [4:0]  resul_out;

integer errors = 0;


task Check(
            input [9:0] esperado
            );
        if (esperado[9:5] != esperado[4:0]) begin
            $display("Resultado %d \nEsperava %d\n", esperado[9:5], esperado[4:0]);
            errors = errors + 1;
        end
        else $display("passou!");
  endtask

somador_subtrator #(4) DUT (
  .a      (a_in)     ,
  .b      (b_in)     ,
  .select (select_in),
  .resul  (resul_out)
);


initial begin
  $dumpfile("somador_subtrator_tb.vcd");
  $dumpvars(1, somador_subtrator_tb);

  a_in = 4'b0;
  b_in = 4'b0;
  select_in = 1'b1; // 0 + 0
  Check({5'd0, resul_out});
  #10

  a_in = 4'b1;
  b_in = 4'b0;
  select_in = 1'b1; // 1 + 0
  #10
  Check({resul_out, 5'd1});
  #10


  a_in = 4'b1;
  b_in = 4'd2;
  select_in = 1'b1; // 1 + 2
  #10
  Check({5'd3, resul_out});
  #10

  a_in = 4'd3;
  b_in = 4'b1;
  select_in = 1'b1; // 3 + 1
  #10
  Check({5'd4, resul_out});
  #10

  a_in = 4'd3;
  b_in = 4'b1;
  select_in = 1'b0; // 3 - 1
  #10
  Check({5'd2, resul_out});
  #10

  a_in = 4'b1;
  b_in = 4'b1;
  select_in = 1'b0; // 1 - 1
    #10
  Check({5'd0, resul_out});
  #10

  a_in = 4'd4;
  b_in = 4'b1;
  select_in = 1'b0; // 1 - 1
    #10
  Check({5'd3, resul_out});
  #10

  $display("Terminou a simulacao e tem %d", errors);
  #10
  $stop;
end

 

endmodule