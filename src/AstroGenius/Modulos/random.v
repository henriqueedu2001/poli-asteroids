module random (
    input clock,
    input reset,
    output [3:0] rnd 
);

    wire feedback = random[12] ^ random[3] ^ random[2] ^ random[0]; 

    reg [12:0] random, random_next;
    reg [12:0] count, count_next; // Declare count and count_next as 13-bit registers

    initial begin
        random = 13'hF; // An LFSR cannot have an all 0 state, thus reset to FF
        count = 0;
    end

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            random <= 13'hF;
            count <= 0;
        end else begin
            random <= random_next;
            count <= count_next;
        end
    end

    always @(*) begin
        random_next = random; // Default state stays the same
        count_next = count;

        random_next = {random[11:0], feedback}; // Shift left the XOR'd every posedge clock
        count_next = (count == 13) ? 0 : count + 1; // Increment count only if it's not already 13

        if (count == 13) begin
            random_next = {random[11:0], feedback}; // Assign the random number to output after 13 shifts
        end
    end

    assign rnd = random[12:9]; // Output the most significant 4 bits of random

endmodule