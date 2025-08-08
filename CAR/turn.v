`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/27 14:18:57
// Design Name: 
// Module Name: turn
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


module turn(
   input clk,
   input rst_n,
   input [31:0]num,
   output [3:0]en
    );
/*    
always@(posedge clk or negedge rst_n)begin
if(!rst_n)
    en<=4'b1111;
else if(num<10)
    en<=4'b1011;
else
    en<=4'b1010;
end
*/

assign en=(num<10)?4'b1011:4'b1010;


endmodule
