`timescale 1ns / 1ps

module route(
    input [1:0]din,//din[0]×ó£¬din[1]ÓÒ
    input clk,
    input rst_n,
    input [31:0]num,
    output reg [3:0]en
    );

always@(posedge clk or negedge rst_n)begin
if(!rst_n)
    en<=4'b1111;
else begin
    if(num<10)
        en<=4'b1111;
    else begin
        if(din[1]==din[0])
            en<=4'b1010;
        else if(din[1]==1&&din[0]==0)
            en<=4'b1110;
        else if(din[0]==1&&din[1]==0)
            en<=4'b1011;
    end
end
end 

endmodule