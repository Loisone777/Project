`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/28 15:24:01
// Design Name: 
// Module Name: uart
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


module uart(
    input clk,
    input rst_n,
    input uart_rxd_r,
    output [7:0]data,
    output rx_done
    );
    
parameter synclk=125_000_000;
parameter bps=9600;
parameter delay=synclk/bps;

reg [31:0]baud_cnt;
reg [3:0]cnt_bit;

reg rx_reg0;
reg rx_reg1;

reg rxd_en;

reg [7:0]data_reg;
reg [2:0]done_cnt;

wire flag;

always@(posedge clk or negedge rst_n)begin
if(!rst_n)begin
    rx_reg0<=0;
    rx_reg1<=0;
end
else begin
    rx_reg0<=uart_rxd_r;
    rx_reg1<=rx_reg0;
end
end

assign flag=(~rx_reg0)&rx_reg1;

always@(posedge clk or negedge rst_n)begin
if(!rst_n)
    rxd_en<=0;
else begin
    if(flag==1)
        rxd_en<=1;
    else if(cnt_bit==9&&baud_cnt==delay/2-1)
        rxd_en<=0;
    end
end

always@(posedge clk or negedge rst_n)begin
if(!rst_n)
    baud_cnt<=0;
else if(rxd_en==1)begin
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
    data_reg<=0;
else if(rxd_en&&cnt_bit>0&&cnt_bit<9&&baud_cnt==delay/2-1)
    data_reg[cnt_bit-1]<=rx_reg1;
else if(rx_done)
    data_reg<=0;
end

assign data=(cnt_bit==9 && baud_cnt==delay/2-1)?data_reg:8'b00000000;
assign rx_done=(cnt_bit==9 && baud_cnt==delay/2-1)?1:0;

endmodule
