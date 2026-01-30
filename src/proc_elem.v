`timescale 1ns / 1ps

module proc_elem#(
    parameter DATA_WIDTH = 4
)(
    input clk, reset, load,
    input signed [DATA_WIDTH - 1 : 0] in_val, in_weight,
    input signed [DATA_WIDTH * DATA_WIDTH - 1 : 0] in_sum,
    output reg signed [DATA_WIDTH - 1 : 0] out_val, out_weight, 
    output reg signed [DATA_WIDTH * DATA_WIDTH - 1 : 0] out_sum
);
    
    wire [DATA_WIDTH * 2 - 1 : 0] product;
    reg [DATA_WIDTH * 2 - 1 : 0] weight;
    
    assign product = in_val * weight;
    always @(posedge clk, posedge reset) begin
        if (reset == 1) begin
            weight <= 0;
            out_weight <= 0;
            out_sum <= 0;
        end
        else if (load == 1) begin
            weight <= in_weight;
            out_weight <= weight;
        end
        else begin
            out_sum <= product + in_sum;
        end
    end
            
 
endmodule
