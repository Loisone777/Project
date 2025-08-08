`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/26 15:06:26
// Design Name: 
// Module Name: echo
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


module echo(
    input clk,
    input rst_n,
    input echo,
    output [31:0]num
    );
    
parameter s0=4'b0001;
parameter s1=4'b0010;
parameter s2=4'b0100;
parameter s3=4'b1000;

reg [3:0]cur_state,next_state;

reg [31:0]cnt,cnt_reg;

always@(posedge clk or negedge rst_n)begin
if(!rst_n)
    cur_state<=s0;
else
    cur_state<=next_state;
end 

always@(*)begin
case(cur_state)
    s0:begin
        if(echo==1)
            next_state=s1;
        else
            next_state=s0;
        end
    s1:begin
        if(echo==0)
            next_state=s2;
        else
            next_state=s1;
        end    
    s2:next_state=s3;
    s3:next_state=s0;
    default:next_state=s0;
endcase
end

always@(posedge clk or negedge rst_n)begin
if(!rst_n)begin
    cnt<=0;
    cnt_reg<=0;
end
else
    case(cur_state)
        s0:begin
            cnt<=0;
            cnt_reg<=cnt_reg;
            end
        s1:begin
            cnt<=cnt+1;
            cnt_reg<=cnt_reg;
            end
        s2:begin
            cnt<=0;
            cnt_reg<=cnt;
            end
        s3:begin
            cnt<=cnt;
            cnt_reg<=cnt_reg;
            end
        default:begin
            cnt<=0;
            cnt_reg<=cnt;
            end
    endcase
end 

assign num=(cnt_reg)*8/58/1000;

endmodule
