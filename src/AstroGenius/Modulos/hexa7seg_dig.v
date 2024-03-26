
module hexa7seg (hexa, display);
    input      [3:0] hexa;
    output reg [3:0] display;

    /*
     *    ---
     *   | 0 |
     * 5 |   | 1
     *   |   |
     *    ---
     *   | 6 |
     * 4 |   | 2
     *   |   |
     *    ---
     *     3
     */
        
    always @(hexa)
    case (hexa)
        4'h0:    display = 4'h0;
        4'h1:    display = 4'h1;
        4'h2:    display = 4'h2;
        4'h3:    display = 4'h3;
        4'h4:    display = 4'h4;
        4'h5:    display = 4'h5;
        4'h6:    display = 4'h6;
        4'h7:    display = 4'h7;
        4'h8:    display = 4'h8;
        4'h9:    display = 4'h9;
        4'ha:    display = 4'ha;
        4'hb:    display = 4'hb;
        4'hc:    display = 4'hc;
        4'hd:    display = 4'hd;
        4'he:    display = 4'he;
        4'hf:    display = 4'hf;
        default: display = 4'h0;
    endcase
endmodule