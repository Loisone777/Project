`timescale 1ns / 1ps
module show(
input [3:0]             num_in  ,//0--9
output reg [7:0]        num_out     //
    );
always@(*)
case(num_in)
    0:num_out=8'b0011_1111;//dp,gfedcba
    1:num_out=8'b0000_0110;
    2:num_out=8'b0101_1011;
    3:num_out=8'b0100_1111;
    4:num_out=8'b0110_0110;
    5:num_out=8'b0110_1101;
    6:num_out=8'b0111_1101;
    7:num_out=8'b0000_0111;
    8:num_out=8'b0111_1111;
    9:num_out=8'b0110_1111;
    default:num_out=8'b0011_1111;
endcase
endmodule

