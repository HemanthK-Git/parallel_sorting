`timescale 1ns / 1ps

module sorting_8_tb;

    reg [31:0] a0,a1,a2,a3,a4,a5,a6,a7;
    reg clk, rst, select;
    wire [31:0] b00,b11,b22,b33,b44,b55,b66,b77;

    sorting_8 uut (
        .a0(a0), .a1(a1), .a2(a2), .a3(a3),
        .a4(a4), .a5(a5), .a6(a6), .a7(a7),
        .select(select), .clk(clk), .rst(rst),
        .b00(b00), .b11(b11), .b22(b22), .b33(b33),
        .b44(b44), .b55(b55), .b66(b66), .b77(b77)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        select = 0;
        
        // Sample unsorted inputs
        a0 = 32'd11; a1 = 32'd90; a2 = 32'd43; a3 = 32'd70;
        a4 = 32'd30; a5 = 32'd44; a6 = 32'd40; a7 = 32'd32;

        #10;
        rst = 0; // Deassert reset

        #10;
        select = 1; // Load initial inputs

        #10;
        select = 0; // Use previous outputs as inputs

        // Wait for few more clock cycles to observe outputs
        #50;

        // Display final output
        $display("Sorted Output:");
        $display("%d %d %d %d %d %d %d %d", 
                 b00, b11, b22, b33, b44, b55, b66, b77);

        $finish;
    end

endmodule
