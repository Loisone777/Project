`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/26 10:23:40
// Design Name: 
// Module Name: shumaguan
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


module shumaguan(
input clk,rst_n,
output reg[7:0]seg,
output reg[3:0]dig
    );

reg [31:0]cnt;
wire add_cnt;
wire end_cnt;

always@(posedge clk or negedge rst_n)begin
if(!rst_n)
    cnt<=0;
else if(add_cnt)begin
    if(end_cnt)
        cnt<=0;
    else
        cnt<=cnt+1;
end
end

assign add_cnt=1;
assign end_cnt=add_cnt&&cnt==125000-1;

always@(posedge clk or negedge rst_n)begin
if(!rst_n)
    dig<=4'b1110;
else if(end_cnt)
    dig<={dig[2:0],dig[3]};
end

always@(*)begin
case(dig)
    4'b1110:seg<=8'b0000_0110;
    4'b1101:seg<=8'b0101_1011;
    4'b1011:seg<=8'b0100_1111;
    4'b0111:seg<=8'b0110_0110;
    default:seg<=8'b1111_1111;
endcase
end
    
endmodule
