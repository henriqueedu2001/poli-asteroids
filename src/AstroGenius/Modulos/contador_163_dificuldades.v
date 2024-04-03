/*
    Modulo de contador desenvolvido pelo grupo onde foi utilizado como base o contador_163 disponibilizado pelo professor.
    Esse contador determina o intervalo de geração dos asteroides, de movimentação dos asteroides e de movimentação dos tiros.
    Para cada intervalo há um valor fixado dos tempos supracitados.
*/
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

    parameter tempo_move_tiro_easy1   = 64'd50000000;
    parameter tempo_move_tiro_easy2   = 64'd40000000;
    parameter tempo_move_tiro_easy3   = 64'd32000000;
    parameter tempo_move_tiro_easy4   = 64'd25600000;
    parameter tempo_move_tiro_medium1 = 64'd20480000;
    parameter tempo_move_tiro_medium2 = 64'd16384000;
    parameter tempo_move_tiro_medium3 = 64'd13107200;
    parameter tempo_move_tiro_medium4 = 64'd10485760;
    parameter tempo_move_tiro_hard1   = 64'd8388608;
    parameter tempo_move_tiro_hard2   = 64'd6710886;
    parameter tempo_move_tiro_hard3   = 64'd5368709;
    parameter tempo_move_tiro_hard4   = 64'd4294967;

    parameter tempo_move_asteroide_easy1   = 64'd250000000;
    parameter tempo_move_asteroide_easy2   = 64'd200000000;
    parameter tempo_move_asteroide_easy3   = 64'd160000000;
    parameter tempo_move_asteroide_easy4   = 64'd128000000;
    parameter tempo_move_asteroide_medium1 = 64'd102400000;
    parameter tempo_move_asteroide_medium2 = 64'd81920000;
    parameter tempo_move_asteroide_medium3 = 64'd65536000;
    parameter tempo_move_asteroide_medium4 = 64'd52428800;
    parameter tempo_move_asteroide_hard1   = 64'd41943040;
    parameter tempo_move_asteroide_hard2   = 64'd33554432;
    parameter tempo_move_asteroide_hard3   = 64'd26843546;
    parameter tempo_move_asteroide_hard4   = 64'd21474837;


    // parameter tempo_move_asteroide_easy1   = 64'd25000000;
    // parameter tempo_move_asteroide_easy2   = 64'd25000000;
    // parameter tempo_move_asteroide_easy3   = 64'd25000000;
    // parameter tempo_move_asteroide_easy4   = 64'd25000000;
    // parameter tempo_move_asteroide_medium1 = 64'd25000000;
    // parameter tempo_move_asteroide_medium2 = 64'd25000000;
    // parameter tempo_move_asteroide_medium3 = 64'd25000000;
    // parameter tempo_move_asteroide_medium4 = 64'd25000000;
    // parameter tempo_move_asteroide_hard1   = 64'd25000000;
    // parameter tempo_move_asteroide_hard2   = 64'd25000000;
    // parameter tempo_move_asteroide_hard3   = 64'd25000000;
    // parameter tempo_move_asteroide_hard4   = 64'd25000000;

    parameter tempo_gera_asteroide_easy1   = 64'd350000000;
    parameter tempo_gera_asteroide_easy2   = 64'd280000000;
    parameter tempo_gera_asteroide_easy3   = 64'd224000000;
    parameter tempo_gera_asteroide_easy4   = 64'd179200000;
    parameter tempo_gera_asteroide_medium1 = 64'd143360000;
    parameter tempo_gera_asteroide_medium2 = 64'd114688000;
    parameter tempo_gera_asteroide_medium3 = 64'd91750400;
    parameter tempo_gera_asteroide_medium4 = 64'd73400320;
    parameter tempo_gera_asteroide_hard1   = 64'd58720256;
    parameter tempo_gera_asteroide_hard2   = 64'd46976205;
    parameter tempo_gera_asteroide_hard3   = 64'd37580964;
    parameter tempo_gera_asteroide_hard4   = 64'd30064771;


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