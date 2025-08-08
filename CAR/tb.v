`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/29 11:47:54
// Design Name: 
// Module Name: tb
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


module tb();

uart car_uart(
   .clk             (clk       ),
   .rst_n           (rst_n     ),
   .uart_rxd_r      (uart_rxd_r),
   .data            (data      ),
   .rx_done         (rx_done   ),
   .num             (num       )
);

seg car_seg(
    .clk        (clk  ),
    .rst_n      (rst_n),
    .num        (num  ),
    .seg        (seg  ),//段选
    .dig        (dig  ) //位选
);

reg clk;
reg rst_n;
reg uart_rxd_r;
wire [7:0]data;
wire rx_done;
wire [31:0]num;

    
wire [7:0] seg;//段选 
wire [3:0] dig; //位选

initial begin
    clk=0;
    forever #4 clk=~clk;
end

initial begin
    rst_n=0;
    #20
    rst_n=1;
end

initial begin
    uart_rxd_r=0;
    #30
    uart_rxd_r=0;
    #30
    uart_rxd_r=0;
    #30
    uart_rxd_r=1;
    #30
    uart_rxd_r=1;
    #30
    uart_rxd_r=0;
    #30
    uart_rxd_r=0;
    #30
    uart_rxd_r=0;
    #30
    uart_rxd_r=1;
    
    #30
    uart_rxd_r=0;
    #300
    uart_rxd_r=0;
    #30
    uart_rxd_r=0;
    #30
    uart_rxd_r=1;
    #30
    uart_rxd_r=1;
    #30
    uart_rxd_r=0;
    #30
    uart_rxd_r=0;
    #30
    uart_rxd_r=1;
    #30
    uart_rxd_r=0;
 
    #30
    uart_rxd_r=0;   
    #300
    uart_rxd_r=0;
    #30
    uart_rxd_r=0;
    #30
    uart_rxd_r=1;
    #30
    uart_rxd_r=1;
    #30
    uart_rxd_r=0;
    #30
    uart_rxd_r=0;
    #30
    uart_rxd_r=1;
    #30
    uart_rxd_r=1;

    #30
    uart_rxd_r=0;    
    #300
    uart_rxd_r=0;
    #30
    uart_rxd_r=0;
    #30
    uart_rxd_r=1;
    #30
    uart_rxd_r=1;
    #30
    uart_rxd_r=0;
    #30
    uart_rxd_r=1;
    #30
    uart_rxd_r=0;
    #30
    uart_rxd_r=0;
end

endmodule
