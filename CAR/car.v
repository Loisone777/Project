`timescale 1ns / 1ps

module car(
    input clk,
    input rst_n,
    
    input echo,
    output trig,
    
    output [3:0]dig,
    output [7:0]seg,
    
    input [1:0]din,//din[0]×ó£¬din[1]ÓÒ
    output [3:0]en,
    
    input uart_rxd_r,
    
    output led
);

wire [31:0]num;
wire [7:0]data_rx;
wire rx_done;
wire [7:0]data_tx;
/*
chaoshengbo car_chaoshengbo(
    .clk        (clk  ),
    .rst_n      (rst_n),
    .echo       (echo ),
    .trig       (trig ),
    .num        (num  )
);
*/

seg car_seg(
    .clk        (clk  ),
    .rst_n      (rst_n),
    .num        (num  ),
    .seg        (seg  ),//¶ÎÑ¡
    .dig        (dig  ) //Î»Ñ¡
);
/*
route car_route(
    .clk        (clk  ),
    .rst_n      (rst_n),
    .din        (din  ),//din[0]×ó£¬din[1]ÓÒ
    .num        (num  ),
    .en         (en   )
);  
*/  
uart car_uart(
   .clk             (clk       ),
   .rst_n           (rst_n     ),
   .uart_rxd_r      (uart_rxd_r),
   .data            (data_rx      ),
   .rx_done         (rx_done   )
);

bluetooth car_bluetooth(
   .clk             (clk    ),
   .rst_n           (rst_n  ),
   .rx_done         (rx_done),
   .data            (data_rx   ),
   .num             (num    )
);
/*
led car_led(
   .clk          (clk  ),
   .rst_n        (rst_n),
   .data         (data ),
   .led          (led  )
);
*/
tx car_tx(
   .clk         (clk   ),
   .rst_n       (rst_n ),
   .data        (data_tx),
   .start       (start ),
   .tx          (tx    )
    );
endmodule
