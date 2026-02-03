`timescale 1ns / 1ps

module pe_tb;
    reg clk, reset, load;
    reg [2:0] in_val, in_weight;
    reg [8:0] in_sum;

    wire [2:0] out_val, out_weight;
    wire [8:0] out_sum;

    proc_elem #(3) pe (
        .clk(clk),
        .reset(reset),
        .load(load),
        .in_val(in_val),
        .in_sum(in_sum),
        .in_weight(in_weight),
        .out_val(out_val),
        .out_sum(out_sum),
        .out_weight(out_weight)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("mac_sim/pe.vcd");
        $dumpvars(0, pe_tb);

        clk = 0; reset = 1; load = 0;
        in_val = 0; in_sum = 0; in_weight = 0;

        #20 reset = 0;

        @(negedge clk) 
        load = 1;
        in_weight = 3'd3;

        @(negedge clk)
        load = 0;
        in_val = 3'd4;
        in_sum = 5'd10;

        @(negedge clk)
        in_val = 3'd2;
        in_sum = 5'd4;

        #20

        $display("pe testbench complete");
        $finish();

    end



endmodule