`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/16 16:15:33
// Design Name: 
// Module Name: alu_control
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


module alu_control(
    input wire [1:0] ALUOp,
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    output reg [3:0] ALUCtrl
    );
    
    always @(*) begin
        case(ALUOp)
            2'b00:ALUCtrl = 4'b0010;//load/store->add
            2'b01:ALUCtrl = 4'b0110;//branch->sub
            2'b10:begin //R-type or I-type
                case(funct3)
                    3'b000:ALUCtrl = (funct7==7'b0100000)? 4'b0110:4'b0010; //sub:add
                    3'b111:ALUCtrl = 4'b0000;//and
                    3'b110:ALUCtrl = 4'b0001;//or
                    3'b010:ALUCtrl = 4'b0111;//slt
                    default:ALUCtrl = 4'b0010;
                endcase
            end
            
            default:ALUCtrl = 4'b0010;
        endcase
    end
endmodule
