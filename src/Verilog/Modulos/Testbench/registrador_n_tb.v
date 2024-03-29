`include "../registrador_n.v"
`timescale 1ns/1ns

module registrador_n_tb;

    // Entradas
    reg [31:0] in_data;
    reg load, clk;

    wire [31:0] out_data;

    registrador_n #(.N(32)) UUT (.clock(clk), .clear(1'b0), .enable(load), .D(in_data), .Q(out_data));

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        $monitor ("[%t] clk = %d in_data = %d out_data = %d load = %d", 
                  $time, clk, in_data, out_data, load);

        // Inicializar os inputs 
        load <= 0; 
        in_data <= 32'd0;  
        #100

        // Teste 1: 5
        load <= 1;
        in_data <= 32'd5;       

        // Teste 2: 11
        in_data <= 32'd11;        
        #20

        // Teste 3: 111
        in_data <= 32'd111;
        #20

        // Teste 4: 53
        in_data <= 32'd53;
        #20

        $finish;
    end
endmodule

