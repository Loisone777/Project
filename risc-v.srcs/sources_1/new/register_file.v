`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/14 13:36:08
// Design Name: 
// Module Name: register_file
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


module register_file(
    input wire          clk,
    input wire          we,         //write enable
    input wire [4:0]    waddr,      //write address
    input wire [31:0]   wdata,      //write data
    input wire [4:0]    raddr1,     //read address 1
    input wire [31:0]   rdata1,     //read data 1
    input wire [4:0]    raddr2,     //read address 2
    input wire [31:0]   rdata2      //read data 2
    );
    
    reg [31:0] regs [0:31];
    
    integer i;
    initial begin
        for(i=0;i<32;i=i+1)
            regs[i]=32'b0;
    end
    
    //write
    always @(posedge clk) begin
        if(we&&(waddr!=0))      //x0 is always 0
            regs[waddr]<=wdata;
    end
    
    //read
    assign rdata1=(raddr1 == 0)? 32'b0 : regs[raddr1];
    assign rdata2=(raddr2 == 0)? 32'b0 : regs[raddr2];
    
endmodule
