/*
    Modulo do contador_163 disponibilizado pelos professores que foi adaptado pelo grupo,
    esse contador tem seu valor máximo variável, sendo este a entrada Max. Esse contador é utilizado para a
    seleção de dificuldade 

*/

module contador_163 #(parameter N = 16) ( 
                        input clock, 
                        input clr, 
                        input ld, 
                        input ent, 
                        input enp, 
                        input [N-1:0] D,
                        input [N-1:0] Max,
                        output reg [N-1:0] Q, 
                        output reg rco
                    );

    initial begin
        Q = 0;
    end
        
    always @ (posedge clock)
        if (clr)               Q <= 0;
        else if (ld)           Q <= D;
        else if (ent && enp && Q <= Max)   Q <= Q + 1;
        else                   Q <= Q;

    always @ (Q or ent)
        if (ent && (Q >= Max))     rco = 1;
        else                       rco = 0;
endmodule