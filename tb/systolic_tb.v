`timescale 1ns / 1ps

module systolic_tb;
    parameter ARRAY_SIZE = 4;
    parameter DATA_WIDTH = 4;

    reg clk, reset;
    reg [ARRAY_SIZE * DATA_WIDTH - 1 : 0] in_top, in_left;
    wire [ARRAY_SIZE * DATA_WIDTH - 1 : 0] out_bot;

    systolic #(.ARRAY_SIZE(ARRAY_SIZE), .DATA_WIDTH(DATA_WIDTH)) dut (
        .clk(clk),
        .reset(reset),
        .in_top(in_top),
        .in_left(in_left),
        .out_bot(out_bot)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        in_top, in_left = 0;

        // test array
        // in_left: rows of 1's, 2's, 3's, 4's
        // in_top: columns of 1's, 2's, 3's, 4's
        
        #10 reset = 0;
        in_left = {4'd0, 4'd0, 4'd0, 4'd1};
        in_top = {4'd0, 4'd0, 4'd0, 4'd1};
        
        #10
        in_left = {4'd0, 4'd0, 4'd2, 4'd1};
        in_top = {4'd0, 4'd0, 4'd2, 4'd1};
        
        #10
        in_left = {4'd0, 4'd3, 4'd2, 4'd1};
        in_top = {4'd0, 4'd3, 4'd2, 4'd1};

        #10
        in_left = {4'd4, 4'd3, 4'd2, 4'd1};
        in_top = {4'd4, 4'd3, 4'd2, 4'd1};
        
        #10
        in_left = {4'd4, 4'd3, 4'd2, 4'd0};
        in_top = {4'd4, 4'd3, 4'd2, 4'd0};
        
        #10
        in_left = {4'd4, 4'd3, 4'd0, 4'd0};
        in_top = {4'd4, 4'd3, 4'd0, 4'd0};
        
        #10
        in_left = {4'd4, 4'd0, 4'd0, 4'd0};
        in_top = {4'd4, 4'd0, 4'd0, 4'd0};
        
        #10
        in_left = {4'd0, 4'd0, 4'd0, 4'd0};
        in_top = {4'd0, 4'd0, 4'd0, 4'd0};
        
        #80 reset = 0;

        #20
        
     end
endmodule