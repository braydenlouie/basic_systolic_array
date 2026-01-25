`timescale 1ns / 1ps

module systolic#(
    parameter ARRAY_SIZE = 4,
    parameter DATA_WIDTH = 4
)(
    input clk, reset,
    input [ARRAY_SIZE * DATA_WIDTH - 1 : 0] input_left, input_top,
    output [ARRAY_SIZE * (DATA_WIDTH * DATA_WIDTH) - 1 : 0] output_bot,
    output done
);

    parameter NUM_WIRES = ARRAY_SIZE * (ARRAY_SIZE + 1);
    parameter ROW_COL_WIDTH = ARRAY_SIZE * DATA_WIDTH;
    parameter SUM_DATA_WIDTH = DATA_WIDTH * DATA_WIDTH;
    parameter SEGMENTS_PER_LINE = ARRAY_SIZE + 1;

    // internal buses
    // hor_bus: carrying input data from left to right 
    // ver_bus: carrying input data from top to bottom
    wire [NUM_WIRES * DATA_WIDTH - 1 : 0] hor_bus, ver_bus;

    // sum_bus: carrying sum data from top to bottom
    wire [NUM_WIRES * SUM_DATA_WIDTH - 1 : 0] sum_bus;

    // assigning first row/col of horizontal and vertical to inputs
    // assigns first col of sum_bus to 0's
    genvar b;
    generate
        for (b = 0; b < ARRAY_SIZE; b = b + 1) begin : boundary
            assign hor_bus[(b * SEGMENTS_PER_LINE) * DATA_WIDTH +: DATA_WIDTH] = input_left[b * DATA_WIDTH +: DATA_WIDTH];
            assign ver_bus[(b * SEGMENTS_PER_LINE) * DATA_WIDTH +: DATA_WIDTH] = input_top[b * DATA_WIDTH +: DATA_WIDTH];
            assign sum_bus[(b * SEGMENTS_PER_LINE) * SUM_DATA_WIDTH +: SUM_DATA_WIDTH] = {SUM_DATA_WIDTH{1'b0}};
        end
    endgenerate

    genvar r, c; // used in for loops for row and col
    generate
        for (r = 0; r < ARRAY_SIZE; r = r + 1) begin : rows
            for (c = 0; c < ARRAY_SIZE; c = c + 1) begin : cols
                proc_elem #(DATA_WIDTH) pe (
                    .clk(clk),
                    .reset(reset),
                    // horizontal input/output
                    .in_left(hor_bus[((r * SEGMENTS_PER_LINE) + c) * DATA_WIDTH +: DATA_WIDTH]),
                    .out_right(hor_bus[((r * SEGMENTS_PER_LINE) + (c + 1)) * DATA_WIDTH +: DATA_WIDTH]),
                    // vertical input/output
                    .in_top(ver_bus[((c * SEGMENTS_PER_LINE) + r) * DATA_WIDTH +: DATA_WIDTH]),
                    .out_bot(ver_bus[((c * SEGMENTS_PER_LINE) + (r + 1)) * DATA_WIDTH +: DATA_WIDTH]),
                    // sum input/output
                    .in_sum(sum_bus[((c * SEGMENTS_PER_LINE) + r) * SUM_DATA_WIDTH +: SUM_DATA_WIDTH]),
                    .out_sum(sum_bus[((c * SEGMENTS_PER_LINE) + (r + 1)) * SUM_DATA_WIDTH +: SUM_DATA_WIDTH])
                );
            end
        end
    endgenerate

    genvar i; // used in for loop for assigning output
    generate
        for (i = 0; i < ARRAY_SIZE; i = i + 1) begin : output_gen
            // assign output which is extra row at the bottom
            assign output_bot[i * SUM_DATA_WIDTH +: SUM_DATA_WIDTH] = 
                sum_bus[((i * SEGMENTS_PER_LINE) + ARRAY_SIZE) * SUM_DATA_WIDTH +: SUM_DATA_WIDTH];
        end
    endgenerate
    
endmodule