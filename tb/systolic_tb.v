`timescale 1ns / 1ps

module systolic_tb;
    parameter ARRAY_SIZE = 2;
    parameter DATA_WIDTH = 4;

    reg clk, reset, load;
    reg [ARRAY_SIZE * DATA_WIDTH - 1 : 0] weights, activations;
    wire [ARRAY_SIZE * DATA_WIDTH * DATA_WIDTH - 1 : 0] output_row;
    wire [ARRAY_SIZE * (ARRAY_SIZE + 1) * DATA_WIDTH - 1 : 0] act_tb, weight_tb;
    wire [ARRAY_SIZE * (ARRAY_SIZE + 1) * DATA_WIDTH * DATA_WIDTH - 1 : 0] sum_tb;

    systolic #(.ARRAY_SIZE(ARRAY_SIZE), .DATA_WIDTH(DATA_WIDTH)) dut (
        .clk(clk),
        .reset(reset),
        .load(load),
        .weights(weights),
        .activations(activations),
        .output_row(output_row),
        .act_tb(act_tb),
        .weight_tb(weight_tb),
        .sum_tb(sum_tb)
    );

    always #5 clk = ~clk;
initial begin
        clk = 0; reset = 1; weights = 0; activations = 0; load = 0;
        #15 reset = 0; 

        @(negedge clk)
        //loading weights
        load = 1;
        weights = {4'd4, 4'd3};
        @(negedge clk)
        weights = {4'd2, 4'd1};

        @(negedge clk)
        load = 0;
        activations = {4'd0, 4'd1};

        @(negedge clk)
        activations = {4'd2, 4'd3};

        @(negedge clk)
        activations = {4'd4, 4'd0}; 

        @(negedge clk)
        activations = 0; weights = 0;
        #100;
        $finish;
    end

endmodule