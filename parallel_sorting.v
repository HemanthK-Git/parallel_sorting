`timescale 1ns / 1ps

module sorting_8(
    input [31:0] a0,a1,a2,a3,a4,a5,a6,a7,
    input select,clk,rst,
    output [31:0] b00,b11,b22,b33,b44,b55,b66,b77
    );
    
    wire [31:0] a00,a11,a22,a33,a44,a55,a66,a77;
    wire [31:0] b0, b1, b2, b3, b4, b5, b6, b7;
    
    d_ff d1(.clk(clk), .rst(rst), .d(b0), .q(b00));
    d_ff d2(.clk(clk), .rst(rst), .d(b1), .q(b11));
    d_ff d3(.clk(clk), .rst(rst), .d(b2), .q(b22));
    d_ff d4(.clk(clk), .rst(rst), .d(b3), .q(b33));
    d_ff d5(.clk(clk), .rst(rst), .d(b4), .q(b44));
    d_ff d6(.clk(clk), .rst(rst), .d(b5), .q(b55));
    d_ff d7(.clk(clk), .rst(rst), .d(b6), .q(b66));
    d_ff d8(.clk(clk), .rst(rst), .d(b7), .q(b77));

    muxes m0(.sel(select),.A(a0),.B(b00),.Y(a00));
    muxes m1(.sel(select),.A(a1),.B(b11),.Y(a11));
    muxes m2(.sel(select),.A(a2),.B(b22),.Y(a22));
    muxes m3(.sel(select),.A(a3),.B(b33),.Y(a33));
    muxes m4(.sel(select),.A(a4),.B(b44),.Y(a44));
    muxes m5(.sel(select),.A(a5),.B(b55),.Y(a55));
    muxes m6(.sel(select),.A(a6),.B(b66),.Y(a66));
    muxes m7(.sel(select),.A(a7),.B(b77),.Y(a77));
    
    Sub_block sb (
            .x1(a00), .x2(a11), .x3(a22), .x4(a33),
            .x5(a44), .x6(a55), .x7(a66), .x8(a77),
            .y1(b0), .y2(b1), .y3(b2), .y4(b3),
            .y5(b4), .y6(b5), .y7(b6), .y8(b7)
        );

endmodule

module d_ff (
    input clk,rst,
    input [31:0] d,
    output reg [31:0] q
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 32'b0;
        else
            q <= d;
    end

endmodule


module muxes (
    input sel,
    input [31:0] A, B,
    output [31:0] Y
);
    assign Y = sel ? A : B;
endmodule



module Sub_block(
    input [31:0] x1, x2, x3, x4, x5, x6, x7, x8,
    output [31:0] y1, y2, y3, y4, y5, y6, y7, y8
);

    wire [31:0] b12, b21, b22, b31, b32, b41;

    BN_Blocking b1 (.a(x1), .b(x2), .max(y1), .min(b12));
    BN_Blocking b2 (.a(x3), .b(x4), .max(b21), .min(b22));
    BN_Blocking b3 (.a(x5), .b(x6), .max(b31), .min(b32));
    BN_Blocking b4 (.a(x7), .b(x8), .max(b41), .min(y8));
    
    BN_Blocking b5 (.a(b12), .b(b21), .max(y2), .min(y3));
    BN_Blocking b6 (.a(b22), .b(b31), .max(y4), .min(y5));
    BN_Blocking b7 (.a(b32), .b(b41), .max(y6), .min(y7));

endmodule

module BN_Blocking(
    input [31:0] a, b,
    output [31:0] max, min
);
    wire lt;
    assign lt = (a < b); // Less-than comparison

    muxes minn(.sel(lt), .A(a), .B(b), .Y(min)); // Min output
    muxes maxx(.sel(lt), .A(b), .B(a), .Y(max)); // Max output
endmodule
