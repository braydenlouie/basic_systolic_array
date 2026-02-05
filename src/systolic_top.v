`timescale 1ns/1ps

module systolic_top(
    input CLK100MHZ
);
    parameter SIZE = 8;
    parameter WIDTH = 4;

    // Wires for VIO to Systolic
    wire vio_reset, vio_load;
    wire [SIZE * WIDTH - 1 : 0] vio_activations;
    wire [SIZE * WIDTH - 1 : 0] vio_weights;
    wire [SIZE * WIDTH * WIDTH - 1 : 0] vio_output;

    // Instance of Systolic
    systolic #(.ARRAY_SIZE(SIZE), .DATA_WIDTH(WIDTH)) core (
        .clk(CLK100MHZ),
        .reset(vio_reset),
        .load(vio_load),
        .weights(vio_weights),
        .activations(vio_activations),
        .output_row(vio_output)
    );

    // Instantiation of VIO IP
    vio_0 sys_vio (
        .clk(CLK100MHZ),
        .probe_in0(vio_output),      // Connects to dashboard
        .probe_out0(vio_reset),      // Controlled by dashboard
        .probe_out1(vio_load),
        .probe_out2(vio_weights),
        .probe_out3(vio_activations)
    );

    
    
endmodule