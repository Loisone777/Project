`timescale 1ns / 1ps

module chaoshengbo(
    input clk,
    input rst_n,
    input echo,
    output trig,
    output [31:0]num
    );

trig top_trig(
    .clk        (clk  ),
    .rst_n      (rst_n),
    .trig       (trig )
);

echo top_echo(
    .clk        (clk  ),
    .rst_n      (rst_n),
    .echo       (echo ),
    .num        (num  )
);
   
endmodule
