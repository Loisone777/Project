`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/17 15:44:35
// Design Name: 
// Module Name: mem_wb
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


module mem_wb(
    input wire clk,
    input wire rst,
    input wire stall,             // 一般接 0 也行，接口统一

    // from MEM
    input wire [31:0] mem_read_data,
    input wire [31:0] mem_alu_result,
    input wire [4:0]  mem_rd,
    input wire        mem_RegWrite,
    input wire        mem_MemToReg,

    // to WB
    output reg [31:0] wb_read_data,
    output reg [31:0] wb_alu_result,
    output reg [4:0]  wb_rd,
    output reg        wb_RegWrite,
    output reg        wb_MemToReg
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wb_read_data  <= 0;
            wb_alu_result <= 0;
            wb_rd         <= 0;
            wb_RegWrite   <= 0;
            wb_MemToReg   <= 0;
        end
        if (!stall) begin
            wb_read_data  <= mem_read_data;
            wb_alu_result <= mem_alu_result;
            wb_rd         <= mem_rd;
            wb_RegWrite   <= mem_RegWrite;
            wb_MemToReg   <= mem_MemToReg;
        end
    end
endmodule

