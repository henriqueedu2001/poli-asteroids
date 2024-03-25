module random_tb;

 // Inputs
 reg clock;
 reg reset;

 // Outputs
 wire [3:0] rnd;

 // Instantiate the Unit Under Test (UUT)
 random uut (
  .clock(clock), 
  .reset(reset), 
  .rnd(rnd)
 );
 
 parameter clockPeriod = 20; // in ns, f=50MHz

    // Gerador de clock
    always #((clockPeriod / 2)) clock = ~clock;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(5, random_tb);
        // valores iniciais
        clock = 1'b0;
        reset = 1'b1;
        #(5*clockPeriod)

        reset = 1'b0;
        #(1000*clockPeriod)


        $finish;
    end
endmodule