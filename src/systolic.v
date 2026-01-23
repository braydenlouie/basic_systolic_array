`timescale 1ns / 1ps

module systolic#(parameter ARRAY_SIZE = 4,
                 parameter DATA_SIZE = 4)(
    input clk, reset, load,
    input [ARRAY_SIZE * ARRAY_SIZE * DATA_SIZE - 1 : 0] matrix_a, matrix_b,
    output reg [ARRAY_SIZE * ARRAY_SIZE * DATA_SIZE - 1 : 0] out_matrix);
    
    reg [DATA_SIZE * 2 - 1 : 0] flattened_index;
    
    reg unsigned[DATA_SIZE - 1 : 0] data_matrix_2d [0:ARRAY_SIZE - 1] [0:ARRAY_SIZE - 1];
    reg unsigned[DATA_SIZE - 1 : 0] weight_matrix_2d [0:ARRAY_SIZE - 1] [0:ARRAY_SIZE - 1];
    integer i, j;
    
    always @(posedge clk) begin
        if (load) begin
            for (i = 0; i < ARRAY_SIZE; i = i + 1) begin
                for (j = 0; j < ARRAY_SIZE; j = j + 1) begin
                    flattened_index = i * DATA_SIZE + j * DATA_SIZE;
                    data_matrix_2d[i][j] <= matrix_a[flattened_index +: DATA_SIZE];
                    weight_matrix_2d[i][j] <= matrix_b[flattened_index +: DATA_SIZE];
                end
            end
        end
        else begin
            
        end
        
    end
    
endmodule
