`timescale 1ns/1ps

module systolic_top(
    input clk_pin
);
    parameter SIZE = 8;
    parameter WIDTH = 4;

    // Wires for VIO to Systolic
    wire vio_reset, vio_load;
    wire [SIZE * WIDTH - 1 : 0] vio_activations;
    wire [SIZE * WIDTH - 1 : 0] vio_weights;
    wire [SIZE * WIDTH * WIDTH - 1 : 0] vio_output;

    // Instance of Systolic
    systolic #(.ARRAY_SIZE(SIZE), .DATA_WIDTH(WIDTH)) core {
        .clk(clk_pin),
        .reset(vio_reset),
        .load(vio_load),
        .weights(vio_weights),
        .activations(vio_activations),
        .output_row(.vio_output)
    }

    // Instantiation of VIO IP

    
    
endmodule