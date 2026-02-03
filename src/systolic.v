`timescale 1ns / 1ps

module systolic#(
    parameter ARRAY_SIZE = 8,
    parameter DATA_WIDTH = 4
)(
    input clk, reset, load,
    input signed [ARRAY_SIZE * DATA_WIDTH - 1 : 0] activations, weights,
    output signed [ARRAY_SIZE * (DATA_WIDTH * DATA_WIDTH) - 1 : 0] output_row
);

    parameter NUM_WIRES = ARRAY_SIZE * (ARRAY_SIZE + 1);
    parameter ROW_COL_WIDTH = ARRAY_SIZE * DATA_WIDTH;
    parameter SUM_DATA_WIDTH = DATA_WIDTH * DATA_WIDTH; // honestly overkill
    parameter BUS_SEGMENTS = ARRAY_SIZE + 1; // 1 extra for output

    // internal buses
    // hor_bus: carrying input data from left to right 
    // ver_bus: carrying input data from top to bottom
    wire [NUM_WIRES * DATA_WIDTH - 1 : 0] act_bus, weight_bus;

    // sum_bus: carrying sum data from top to bottom
    wire [NUM_WIRES * SUM_DATA_WIDTH - 1 : 0] sum_bus;

    // assigning first row/col of horizontal and vertical to inputs
    // assigns first col of sum_bus to 0's

    assign act_tb = act_bus;
    assign weight_tb = weight_bus;
    assign sum_tb = sum_bus;

    // feeding values to activations and weight buses
    assign act_bus[ARRAY_SIZE * DATA_WIDTH - 1 : 0] = activations;
    assign weight_bus[ARRAY_SIZE * DATA_WIDTH - 1 : 0] = weights;

    // feeding 0's into first set of PE's
    assign sum_bus[ARRAY_SIZE * SUM_DATA_WIDTH - 1 : 0] = 0;

    genvar r, c; // used in for loops for row and col
    generate
        for (r = 0; r < ARRAY_SIZE; r = r + 1) begin
            for (c = 0; c < ARRAY_SIZE; c = c + 1) begin
                proc_elem #(.DATA_WIDTH(DATA_WIDTH)) pe (
                    .clk(clk),
                    .reset(reset),
                    .load(load),
                    .in_val(act_bus[(c * ARRAY_SIZE + r) * DATA_WIDTH +: DATA_WIDTH]),
                    .out_val(act_bus[((c + 1) * ARRAY_SIZE + r) * DATA_WIDTH +: DATA_WIDTH]),
                    .in_weight(weight_bus[(r * ARRAY_SIZE + c) * DATA_WIDTH +: DATA_WIDTH]),
                    .out_weight(weight_bus[((r + 1) * ARRAY_SIZE + c) * DATA_WIDTH +: DATA_WIDTH]),
                    .in_sum(sum_bus[(r * ARRAY_SIZE + c) * SUM_DATA_WIDTH +: SUM_DATA_WIDTH]),
                    .out_sum(sum_bus[((r + 1) * ARRAY_SIZE + c) * SUM_DATA_WIDTH +: SUM_DATA_WIDTH])
                );
            end
        end
    endgenerate

    // output row is "last row" in sum
    assign output_row = sum_bus[ARRAY_SIZE * ARRAY_SIZE * SUM_DATA_WIDTH +: ARRAY_SIZE * SUM_DATA_WIDTH];

    
endmodule