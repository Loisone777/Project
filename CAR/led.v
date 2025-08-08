`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/29 09:34:10
// Design Name: 
// Module Name: led
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


module led(
    input clk,
    input rst_n,
    input [7:0]data,
    output reg led
    );
    
always  @(posedge clk or negedge rst_n)begin   
     if(rst_n==1'b0)begin   
       led<=0;
     end
     else if(data==8'h01)begin
     led<=1;
     end
     else if(data==8'h02)begin
     led<=0;
     end
end
endmodule
