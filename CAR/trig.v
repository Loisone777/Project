`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/26 15:44:51
// Design Name: 
// Module Name: trig
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


module trig(
    input clk,
    input rst_n,
    output trig
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
assign end_cnt=add_cnt&&cnt==125000*70-1;

assign trig=(cnt>0&&cnt<1500)?1:0;

endmodule
