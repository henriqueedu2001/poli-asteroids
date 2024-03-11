// modulo que decrementa em 1 a cada boda de subida caso ent, enp sejam HIGH

module decrementer  ( input clock       , 
                      input clr         , 
                      input ld          , 
                      input ent         , 
                      input enp         , 
                      input [3:0] D     , 
                      output reg [3:0]Q , 
                      output reg rco
                    );

	 initial begin
		Q = 4'd3;
    end

    always @ (posedge clock)
        if (clr)                Q <= 4'd3;
        else if (ld)            Q <= D;
        else if (ent && enp && Q != 4'b0)    Q <= Q - 1;
        else                    Q <= Q;
 
    always @ (Q or ent)
        if (ent && (Q == 4'd0))       rco = 1;
        else                          rco = 0;

endmodule