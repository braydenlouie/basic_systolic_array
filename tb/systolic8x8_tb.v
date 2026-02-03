`timescale 1ns / 1ps

module systolic8x8_tb;
    parameter ARRAY_SIZE = 8;
    parameter DATA_WIDTH = 4;

    reg clk, reset, load;
    reg [ARRAY_SIZE * DATA_WIDTH - 1 : 0] weights, activations;
    wire [ARRAY_SIZE * DATA_WIDTH * DATA_WIDTH - 1 : 0] output_row;

    integer i;
    integer t, d;

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
        $dumpfile("mac_sim/systolic8x8.vcd");
        $dumpvars(0, systolic8x8_tb);

        clk = 0; reset = 1; weights = 0; activations = 0; load = 0;
        #15 reset = 0; 

        @(negedge clk)
        load = 1;
        for (i = 0; i < ARRAY_SIZE; i = i + 1) begin 
            @(negedge clk)
            weights = {4'd8, 4'd7, 4'd6, 4'd5, 4'd4, 4'd3, 4'd2, 4'd1};
        end

        @(negedge clk)
        weights = 0;
        load = 0;

        for (t = 1; t <= ARRAY_SIZE; t = t + 1) begin
            @(negedge clk)
            activations = {activations[(ARRAY_SIZE - 1)*DATA_WIDTH - 1 : 0], t[DATA_WIDTH - 1 : 0]};
        end

        for (d = 1; d <= ARRAY_SIZE; d = d + 1) begin
            @(negedge clk)
            activations = activations << DATA_WIDTH;
        end
        
        @(negedge clk)
        activations = 0; weights = 0;

        #200;
        $display("systolic_tb completed successfully");
        $finish();
    end

endmodule