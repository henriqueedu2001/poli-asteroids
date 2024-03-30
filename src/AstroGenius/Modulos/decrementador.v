/*
  Modulo desenvolvido pelo grupo para a decrementação de vidas. O valor inicial deste modulo é 3 e quando seu ent e enp estão
  em HIGH a sua saida é decrementada a cada borda de subida de clock. Assim que sua saida se torna zero, o rco é ativado e não é
  realizado mais decrementações.
*/
module decrementador #(parameter N=4) ( 
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