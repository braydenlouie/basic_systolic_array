`timescale 1ns / 1ps

module proc_elem#(
    parameter DATA_WIDTH = 4
)(
    input clk, reset,
    input signed [DATA_WIDTH - 1 : 0] in_left, in_top,
    input signed [DATA_WIDTH * DATA_WIDTH - 1 : 0] in_sum,
    output reg signed [DATA_WIDTH - 1 : 0] out_right, out_bot, 
    output reg signed [DATA_WIDTH * DATA_WIDTH - 1 : 0] out_sum
);
    
    wire [DATA_WIDTH * 2 - 1 : 0] product;
    
    assign product = in_left * in_top;
    always @(posedge clk, posedge reset) begin
        if (reset == 1) begin
            out_right <= 0;
            out_bot <= 0;
            sum <= 0;
        end
        else begin
            out_sum <= product + in_sum;
            out_right <= in_left;
            out_bot <= in_top;
        end
    end
            
 
endmodule
