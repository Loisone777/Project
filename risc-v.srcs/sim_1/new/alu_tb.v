`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/14 15:22:11
// Design Name: 
// Module Name: alu_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps
module alu_tb;

    reg [31:0] a,b;
    reg [3:0] alu_ctrl;
    wire [31:0] result;
    wire zero;
    
    alu uut(
        .a(a), .b(b),     
        .alu_ctrl   (alu_ctrl),
        .result     (result  ),  
        .zero       (zero    )         
    );
    
    initial begin
        a=10;b=20;
        #10;
        alu_ctrl=4'b0010;
        #10;
        alu_ctrl=4'b0110;
        #10;
        alu_ctrl=4'b0000;
        #10;
        alu_ctrl=4'b0001;
        #10;
        alu_ctrl=4'b0111;
        #10;
        alu_ctrl=4'b1100;
        #20;
        $finish;
    end
endmodule
