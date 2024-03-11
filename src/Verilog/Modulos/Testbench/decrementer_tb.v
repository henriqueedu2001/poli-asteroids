`include "decrementer.v"
`timescale 1ns/1ns

module decrementer_tb;

//Entradas
reg clock_in  ;
reg clr_in    ;
reg ld_in     ;
reg ent_in    ;
reg enp_in    ;
reg [3:0] D_in;

//Saidas
wire [3:0] Q_out;
wire rco_out    ;

// Identificacao do caso de teste
    reg [31:0] caso = 0;

integer errors = 0;
decrementer  DUT (
                  .clock(clock_in), 
                  .clr  (clr_in), 
                  .ld   (ld_in ), 
                  .ent  (ent_in), 
                  .enp  (enp_in && ~rco_out), 
                  .D    (D_in  ), 
                  .Q    (Q_out ), 
                  .rco  (rco_out)
                  );

parameter clockPeriod = 20; // in ns, f=1KHz

// Gerador de clock
always #((clockPeriod / 2)) clock_in = ~clock_in;

 task Check(
            input [7:0] esperado
            );
        if (esperado[7:4] != esperado[3:0]) begin
            $display("AAResultado %d \nEsperava %d", esperado[7:4], esperado[3:0]);
            errors = errors + 1;
        end
  endtask

initial begin
  $dumpfile("decrementer_tb.vcd");
  $dumpvars(1, decrementer_tb);

  $display("Inicio da simulacao");
  clock_in   = 1;

  //Valores iniciais
  caso = 1;
  clr_in = 1'b0;
  ld_in = 1'b0;
  ent_in = 1'b0;
  enp_in = 1'b0;
  D_in = 4'd0;
  #(clockPeriod)

  //'Zera' com o valor 3
  caso = 2;
  clr_in = 1'b1;
  ld_in = 1'b0;
  ent_in = 1'b0;
  enp_in = 1'b0;
  D_in = 4'd0;
  #(clockPeriod)

  // Decrementa 3 vezes
  caso = 3;
  clr_in = 1'b0;
  ld_in = 1'b0;
  ent_in = 1'b1;
  enp_in = 1'b1;
  D_in = 4'd0;
  #(4*clockPeriod)
  Check ({Q_out, 4'b0});
  Check ({3'b0, rco_out, 3'b0, 1'b1});

  // Espera
  caso = 99;
  #(5*clockPeriod)
  Check ({Q_out, 4'b0});
  Check ({3'b0, rco_out, 3'b0, 1'b1});

  $display("Fim da simulacao e tem %d erros", errors);
  $stop;

end
endmodule