`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/29 14:53:40
// Design Name: 
// Module Name: bluetooth
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


module bluetooth(
    input clk,
    input rst_n,
    input rx_done,
    input [7:0]data,
    output [31:0]num
    );
    
reg[2:0]done_cnt;   
reg[7:0]data_reg;

reg [3:0]   a;
reg [3:0]   b;
reg [3:0]   c;
reg [3:0]   d;

always@(posedge clk or negedge rst_n)begin
if(!rst_n)
    done_cnt<=0;
else if(rx_done)begin
    if(done_cnt==5-1)
        done_cnt<=1;
    else 
       done_cnt<=done_cnt+1;
    end
end

always@(posedge clk or negedge rst_n)
if(!rst_n)
    data_reg<=0;
else if(rx_done==1)begin
    case(data)
        8'h30:data_reg<=0;
        8'h31:data_reg<=1;
        8'h32:data_reg<=2;
        8'h33:data_reg<=3;
        8'h34:data_reg<=4;
        8'h35:data_reg<=5;
        8'h36:data_reg<=6;
        8'h37:data_reg<=7;
        8'h38:data_reg<=8;
        8'h39:data_reg<=9;
        default:data_reg<=0;
    endcase
end

always@(posedge clk or negedge rst_n)begin
if(!rst_n)begin
    a   <=0;
    b   <=0;
    c   <=0;
    d   <=0;
end
else if(done_cnt==1)
    a<=data_reg;
else if(done_cnt==2)
    b<=data_reg;
else if(done_cnt==3)
    c<=data_reg;
else if(done_cnt==4)
    d<=data_reg;
else begin
   a    <=a;
   b    <=b;
   c    <=c;
   d    <=d;
end
end

assign num=a*1000+b*100+c*10+d;

endmodule
