module contador_163_dificuldades #(parameter N = 16, parameter tempo = 10000) ( 
    input clock, 
    input clr, 
    input ld, 
    input ent, 
    input enp, 
    input [N-1:0] D,
    output reg [N-1:0] Q, 
    output reg rco,
    output reg [63:0] tempo_gera_aste,
    output reg [63:0] tempo_move_aste,
    output reg [63:0] tempo_move_tiro
);

    parameter tempo_move_tiro_easy1   = 64'd10000;
    parameter tempo_move_tiro_easy2   = 64'd8000;
    parameter tempo_move_tiro_easy3   = 64'd8000;
    parameter tempo_move_tiro_easy4   = 64'd5120;
    parameter tempo_move_tiro_medium1 = 64'd4100;
    parameter tempo_move_tiro_medium2 = 64'd3280;
    parameter tempo_move_tiro_medium3 = 64'd2620;
    parameter tempo_move_tiro_medium4 = 64'd2100;
    parameter tempo_move_tiro_hard1   = 64'd1680;
    parameter tempo_move_tiro_hard2   = 64'd1340;
    parameter tempo_move_tiro_hard3   = 64'd1070;
    parameter tempo_move_tiro_hard4   = 64'd860;

    parameter tempo_move_asteroide_easy1   = 64'd50000;
    parameter tempo_move_asteroide_easy2   = 64'd40000;
    parameter tempo_move_asteroide_easy3   = 64'd32000;
    parameter tempo_move_asteroide_easy4   = 64'd25600;
    parameter tempo_move_asteroide_medium1 = 64'd20480;
    parameter tempo_move_asteroide_medium2 = 64'd16380;
    parameter tempo_move_asteroide_medium3 = 64'd13100;
    parameter tempo_move_asteroide_medium4 = 64'd10480;
    parameter tempo_move_asteroide_hard1   = 64'd8380;
    parameter tempo_move_asteroide_hard2   = 64'd70000;
    parameter tempo_move_asteroide_hard3   = 64'd60000;
    parameter tempo_move_asteroide_hard4   = 64'd5000;

    parameter tempo_gera_asteroide_easy1   = 64'd100000;
    parameter tempo_gera_asteroide_easy2   = 64'd80000;
    parameter tempo_gera_asteroide_easy3   = 64'd64000;
    parameter tempo_gera_asteroide_easy4   = 64'd51200;
    parameter tempo_gera_asteroide_medium1 = 64'd40960;
    parameter tempo_gera_asteroide_medium2 = 64'd32770;
    parameter tempo_gera_asteroide_medium3 = 64'd26220;
    parameter tempo_gera_asteroide_medium4 = 64'd20980;
    parameter tempo_gera_asteroide_hard1   = 64'd16780;
    parameter tempo_gera_asteroide_hard2   = 64'd13420;
    parameter tempo_gera_asteroide_hard3   = 64'd10740;
    parameter tempo_gera_asteroide_hard4   = 64'd8590;


    initial begin
        Q = 0;
    end
        
    always @ (posedge clock)
        if (clr)               Q <= 0;
        else if (ld)           Q <= D;
        else if (ent && enp && Q <= 12*tempo)   Q <= Q + 1;
        else                   Q <= Q;

    always @ (Q or ent)
        if (ent && (Q >= 12*tempo))     rco = 1;
        else                       rco = 0;

    always @ (posedge clock)
        if (Q < 1*tempo) begin
            tempo_gera_aste = tempo_gera_asteroide_easy1;
            tempo_move_aste = tempo_move_asteroide_easy1;
            tempo_move_tiro = tempo_move_tiro_easy1;
        end
        else if (Q > 1*tempo && Q < 2*tempo) begin
            tempo_gera_aste = tempo_gera_asteroide_easy2;
            tempo_move_aste = tempo_move_asteroide_easy2;
            tempo_move_tiro = tempo_move_tiro_easy2;
        end
        else if (Q > 2*tempo && Q < 3*tempo) begin
            tempo_gera_aste = tempo_gera_asteroide_easy3;
            tempo_move_aste = tempo_move_asteroide_easy3;
            tempo_move_tiro = tempo_move_tiro_easy3;
        end
        else if (Q > 3*tempo && Q < 4*tempo) begin
            tempo_gera_aste = tempo_gera_asteroide_easy4;
            tempo_move_aste = tempo_move_asteroide_easy4;
            tempo_move_tiro = tempo_move_tiro_easy4;
        end
        else if (Q > 4*tempo && Q < 5*tempo) begin
            tempo_gera_aste = tempo_gera_asteroide_medium1;
            tempo_move_aste = tempo_move_asteroide_medium1;
            tempo_move_tiro = tempo_move_tiro_medium1;
        end
        else if (Q > 5*tempo && Q < 6*tempo) begin
            tempo_gera_aste = tempo_gera_asteroide_medium2;
            tempo_move_aste = tempo_move_asteroide_medium2;
            tempo_move_tiro = tempo_move_tiro_medium2;
        end
        else if (Q > 6*tempo && Q < 7*tempo) begin
            tempo_gera_aste = tempo_gera_asteroide_medium3;
            tempo_move_aste = tempo_move_asteroide_medium3;
            tempo_move_tiro = tempo_move_tiro_medium3;
        end
        else if (Q > 7*tempo && Q < 8*tempo) begin
            tempo_gera_aste = tempo_gera_asteroide_medium4;
            tempo_move_aste = tempo_move_asteroide_medium4;
            tempo_move_tiro = tempo_move_tiro_medium4;
        end
        else if (Q > 8*tempo && Q < 9*tempo) begin
            tempo_gera_aste = tempo_gera_asteroide_hard1;
            tempo_move_aste = tempo_move_asteroide_hard1;
            tempo_move_tiro = tempo_move_tiro_hard1;
        end
        else if (Q > 9*tempo && Q < 10*tempo) begin
            tempo_gera_aste = tempo_gera_asteroide_hard2;
            tempo_move_aste = tempo_move_asteroide_hard2;
            tempo_move_tiro = tempo_move_tiro_hard2;
        end
        else if (Q > 10*tempo && Q < 11*tempo) begin
            tempo_gera_aste = tempo_gera_asteroide_hard3;
            tempo_move_aste = tempo_move_asteroide_hard3;
            tempo_move_tiro = tempo_move_tiro_hard3;
        end
        else begin
            tempo_gera_aste = tempo_gera_asteroide_hard4;
            tempo_move_aste = tempo_move_asteroide_hard4;
            tempo_move_tiro = tempo_move_tiro_hard4;
        end
endmodule