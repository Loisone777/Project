`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/29 16:30:42
// Design Name: 
// Module Name: tx
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


module tx(
    input clk,
    input rst_n,
    input [7:0]data,
    input start,
    output tx
    );

parameter synclk=125_000_000;
parameter bps=9600;
parameter delay=synclk/bps;

reg [31:0]baud_cnt;
reg [3:0]cnt_bit;

reg en;

reg tx_reg;

always@(posedge clk or negedge rst_n)begin
if(!rst_n)
    en<=0;
else begin
    if(start==1)
        en<=1;
    else if(cnt_bit==9&&baud_cnt==delay/2-1)
        en<=0;
    end
end

always@(posedge clk or negedge rst_n)begin
if(!rst_n)
    baud_cnt<=0;
else if(en==1)begin
    if(baud_cnt==delay-1)
        baud_cnt<=0;
    else 
        baud_cnt<=baud_cnt+1;
    end
end

always@(posedge clk or negedge rst_n)begin
if(!rst_n)
    cnt_bit<=0;
else if(baud_cnt==delay-1)begin
    if(cnt_bit==10-1)
        cnt_bit<=0;
    else 
        cnt_bit<=cnt_bit+1;
    end
end

always@(posedge clk or negedge rst_n)begin
if(!rst_n)
    tx_reg<=1;
else if(en==1&&cnt_bit==0)
    tx_reg<=0;
else if(en==1&&cnt_bit==9)
    tx_reg<=1;
else if(en==1&&cnt_bit>0&&cnt_bit<9)
    tx_reg<=data[cnt_bit-1];
else
    tx_reg<=1;
end

assign tx=tx_reg;

endmodule
