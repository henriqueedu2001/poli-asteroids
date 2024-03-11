module comparador_85 #(parameter N = 4)(
                input [N-1:0] A, 
                input [N-1:0] B,
                input       ALBi, 
                input       AGBi, 
                input       AEBi,  
                output      ALBo, 
                output      AGBo, 
                output      AEBo
                );

    wire[N:0]  CSL, CSG;

    assign CSL  = ~A + B + ALBi;
    assign ALBo = ~CSL[N];
    assign CSG  = A + ~B + AGBi;
    assign AGBo = ~CSG[N];
    assign AEBo = ((A == B) && AEBi);

endmodule 