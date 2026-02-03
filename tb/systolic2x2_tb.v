`timescale 1ns / 1ps

module systolic2x2_tb;
    parameter ARRAY_SIZE = 2;
    parameter DATA_WIDTH = 4;

    reg clk, reset, load;
    reg [ARRAY_SIZE * DATA_WIDTH - 1 : 0] weights, activations;
    wire [ARRAY_SIZE * DATA_WIDTH * DATA_WIDTH - 1 : 0] output_row;

    systolic #(.ARRAY_SIZE(ARRAY_SIZE), .DATA_WIDTH(DATA_WIDTH)) dut (
        .clk(clk),
        .reset(reset),
        .load(load),
        .weights(weights),
        .activations(activations),
        .output_row(output_row)
    );

    always #5 clk = ~clk;
initial begin
        $dumpfile("mac_sim/systolic2x2.vcd");
        $dumpvars(0, systolic2x2_tb);

        clk = 0; reset = 1; weights = 0; activations = 0; load = 0;
        #15 reset = 0; 

        @(negedge clk)
        //loading weights
        load = 1;
        weights = {4'd4, 4'd3};
        @(negedge clk)
        weights = {4'd2, 4'd1};

        @(negedge clk)
        weights = 0;
        load = 0;

        @(negedge clk)
        activations = {4'd0, 4'd1};

        @(negedge clk)
        activations = {4'd2, 4'd3};

        @(negedge clk)
        activations = {4'd4, 4'd0}; 

        @(negedge clk)
        activations = 0; weights = 0;
        #100;
        $display("systolic_tb completed successfully");
        $finish();
    end

endmodule