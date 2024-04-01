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

    parameter tempo_move_tiro_easy1   = 64'd20000000;
    parameter tempo_move_tiro_easy2   = 64'd20000000;
    parameter tempo_move_tiro_easy3   = 64'd20000000;
    parameter tempo_move_tiro_easy4   = 64'd20000000;
    parameter tempo_move_tiro_medium1 = 64'd20000000;
    parameter tempo_move_tiro_medium2 = 64'd20000000;
    parameter tempo_move_tiro_medium3 = 64'd20000000;
    parameter tempo_move_tiro_medium4 = 64'd20000000;
    parameter tempo_move_tiro_hard1   = 64'd20000000;
    parameter tempo_move_tiro_hard2   = 64'd20000000;
    parameter tempo_move_tiro_hard3   = 64'd20000000;
    parameter tempo_move_tiro_hard4   = 64'd20000000;

    parameter tempo_move_asteroide_easy1   = 64'd200000000;
    parameter tempo_move_asteroide_easy2   = 64'd200000000;
    parameter tempo_move_asteroide_easy3   = 64'd200000000;
    parameter tempo_move_asteroide_easy4   = 64'd200000000;
    parameter tempo_move_asteroide_medium1 = 64'd200000000;
    parameter tempo_move_asteroide_medium2 = 64'd200000000;
    parameter tempo_move_asteroide_medium3 = 64'd200000000;
    parameter tempo_move_asteroide_medium4 = 64'd200000000;
    parameter tempo_move_asteroide_hard1   = 64'd200000000;
    parameter tempo_move_asteroide_hard2   = 64'd200000000;
    parameter tempo_move_asteroide_hard3   = 64'd200000000;
    parameter tempo_move_asteroide_hard4   = 64'd200000000;

    parameter tempo_gera_asteroide_easy1   = 64'd350000000;
    parameter tempo_gera_asteroide_easy2   = 64'd350000000;
    parameter tempo_gera_asteroide_easy3   = 64'd350000000;
    parameter tempo_gera_asteroide_easy4   = 64'd350000000;
    parameter tempo_gera_asteroide_medium1 = 64'd350000000;
    parameter tempo_gera_asteroide_medium2 = 64'd350000000;
    parameter tempo_gera_asteroide_medium3 = 64'd350000000;
    parameter tempo_gera_asteroide_medium4 = 64'd350000000;
    parameter tempo_gera_asteroide_hard1   = 64'd350000000;
    parameter tempo_gera_asteroide_hard2   = 64'd350000000;
    parameter tempo_gera_asteroide_hard3   = 64'd350000000;
    parameter tempo_gera_asteroide_hard4   = 64'd350000000;


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