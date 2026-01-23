`timescale 1ns / 1ps

module pe#(parameter DATA_WIDTH = 4) (
    input clk, reset,
    input[DATA_WIDTH - 1 : 0] in_left, in_top,
    output reg [DATA_WIDTH - 1 : 0] out_right, out_bot, 
    output reg [DATA_WIDTH * 2 - 1 : 0] sum);
    
    wire [DATA_WIDTH * 2 - 1 : 0] product;
    
    assign product = in_left * in_top;
    always @(posedge clk, posedge reset) begin
        if (reset == 1) begin
            out_right = 0;
            out_bot = 0;
            sum = 0;
        end
        else begin
            sum <= product + sum;
            out_right <= in_left;
            out_bot <= in_top;
        end
    end
            
 
endmodule
