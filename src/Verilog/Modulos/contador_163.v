module contador_163 #(parameter N = 16, parameter tempo = 2000) ( 
                        input clock, 
                        input clr, 
                        input ld, 
                        input ent, 
                        input enp, 
                        input [N-1:0] D, 
                        output reg [N-1:0] Q, 
                        output reg rco
                    );

    initial begin
        Q = 0;
    end
        
    always @ (posedge clock)
        if (clr)               Q <= 0;
        else if (ld)           Q <= D;
        else if (ent && enp)   Q <= Q + 1;
        else                   Q <= Q;

    always @ (Q or ent)
        if (ent && (Q == tempo))   rco = 1;
        else                       rco = 0;
endmodule