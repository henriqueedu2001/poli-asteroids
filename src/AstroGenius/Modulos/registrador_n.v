//registrador_n #(N = 5)(

// )
module registrador_n #(parameter N = 4)(
    input        clock ,
    input        clear ,
    input        enable,
    input  [N-1:0] D     ,
    output [N-1:0] Q
);

    reg [N-1:0] IQ;

    always @(posedge clock or posedge clear) begin
        if (clear)
            IQ <= 0;
        else if (enable)
            IQ <= D;
    end

    assign Q = IQ;

endmodule