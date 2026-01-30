`timescale 1ns / 1ps

module systolic_tb;
    parameter ARRAY_SIZE = 2;
    parameter DATA_WIDTH = 4;

    reg clk, reset;
    reg [ARRAY_SIZE * DATA_WIDTH - 1 : 0] in_top, in_left;
    wire [ARRAY_SIZE * DATA_WIDTH * DATA_WIDTH - 1 : 0] out_bot;

    systolic #(.ARRAY_SIZE(ARRAY_SIZE), .DATA_WIDTH(DATA_WIDTH)) dut (
        .clk(clk),
        .reset(reset),
        .input_top(in_top),
        .input_left(in_left),
        .output_bot(out_bot)
    );

    always #5 clk = ~clk;
initial begin
        clk = 0; reset = 1; in_top = 0; in_left = 0;
        #15 reset = 0; 

        @(negedge clk)
        // T=20: Row 0 and Col 0 start (The Wavefront begins)
        in_left = {4'd0, 4'd1}; in_top = {4'd0, 4'd1};

        @(negedge clk)
        // T=30: Row 1 and Col 1 start. Row 0 and Col 0 continue.
        in_left = {4'd2, 4'd1}; in_top = {4'd2, 4'd1};

        @(negedge clk)
        // T=30: Row 1 and Col 1 start. Row 0 and Col 0 continue.
        in_left = {4'd2, 4'd0}; in_top = {4'd2, 4'd0};

        @(negedge clk)
        in_left = 0; in_top = 0;
        #100;
        $finish;
    end

endmodule