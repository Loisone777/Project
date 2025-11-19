`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/16 16:45:44
// Design Name: 
// Module Name: hazard_detection
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


module hazard_detection(
    input wire          id_ex_MemRead,
    input wire [4:0]    id_ex_rd,
    input wire [4:0]    if_id_rs1,
    input wire [4:0]    if_id_rs2,
    
    output reg          stall
    );
    
    always @(*) begin
        if(id_ex_MemRead && ((id_ex_rd == if_id_rs1)||(id_ex_rd==if_id_rs2)))
            stall =1;
        else
            stall =0;
    end
endmodule
