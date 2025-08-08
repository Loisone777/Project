`timescale 1ns / 1ps
module seg(
input clk,
input rst_n,
input [31:0]num,
output [7:0] seg,//段选
output  [3:0] dig //位选
);

reg [3:0] dig_reg;//位选的寄存
reg [3:0] num_in;
reg [31:0] cnt;
wire [7:0] num_out;

parameter mode=0;//共阴；1共阳
parameter delay=50_0000;//5ms

wire [3:0] ge;
wire [3:0] shi;
wire [3:0] bai;
wire [3:0] qian;

assign ge=num%10;
assign shi=num/10%10;
assign bai=num/100%10;
assign qian=num/1000;

parameter s0  =4'b0001,
            s1=4'b0010,
            s2=4'b0100,
            s3=4'b1000;
reg [3:0] cur_state,next_state;

always@(posedge clk)
if(!rst_n)
    cur_state<=s0;
else
    cur_state<=next_state;
////
always@(*)
case(cur_state)
      s0:begin
        if(cnt==delay-1)
            next_state=s1;
        else
            next_state=s0;
        end
      s1:begin
        if(cnt==delay-1)
            next_state=s2;
        else
            next_state=s1;
        end
      s2:begin
        if(cnt==delay-1)
            next_state=s3;
        else
            next_state=s2;
        end
      s3:begin
        if(cnt==delay-1)
            next_state=s0;
        else
            next_state=s3;
        end
      default:next_state=s0;
endcase
//
always@(posedge clk)
if(!rst_n)begin
    dig_reg <=4'b0000;
    num_in  <=0;
    cnt     <=0;
end
else
    case(cur_state)
        s0:begin
            num_in<=ge;
            dig_reg<=4'b1110;
            if(cnt==delay-1)
                cnt<=0;
            else
                cnt<=cnt+1;
            end
        s1:begin
            num_in<=shi;
            dig_reg<=4'b1101;
            if(cnt==delay-1)
                cnt<=0;
            else
                cnt<=cnt+1;
            end
        s2:begin
            num_in<=bai;
            dig_reg<=4'b1011;
            if(cnt==delay-1)
                cnt<=0;
            else
                cnt<=cnt+1;
            end
        s3:begin
            num_in<=qian;
            dig_reg<=4'b0111;
            if(cnt==delay-1)
                cnt<=0;
            else
                cnt<=cnt+1;
            end
        default:begin
                dig_reg <=4'b0000;
                num_in  <=0;
                cnt     <=0;
            end
    endcase
    
show show_u(
    .num_in  (num_in ) ,//0--9
    .num_out (num_out)    //
);
    
assign dig =(mode==0)?dig_reg:~dig_reg;  
assign seg =(mode==0)?num_out:~num_out;

endmodule