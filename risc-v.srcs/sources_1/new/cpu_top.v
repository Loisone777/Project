`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/17 15:45:22
// Design Name: 
// Module Name: cpu_top
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


module cpu_top(
    input wire clk,
    input wire rst
    );
    
    //========= IF stage ===========//
    reg [31:0] pc;
    wire [31:0] pc_next=pc+4;
    
    always @(posedge clk or posedge rst) begin
        if(rst)
            pc <= 32'b0;
        else if (!stall)
            pc <= pc_next;
    end
    
    wire [31:0] if_instr;
    imem u_imem(
        .addr    (pc),
        .instr   (if_instr)
    );
    
    // IF/ID pipeline
    wire [31:0] id_pc,id_instr;
    wire        ifid_flush = 0; // 暂时不做分支，先接 0
    if_id u_ifid(
        .clk        (clk),
        .rst        (rst),
        .stall      (stall), 
        .flush      (ifid_flush),   
                    
        //from if   
        .if_pc      (pc),
        .if_instr   (if_instr),
                    
        //to id     
        .id_pc      (id_pc),
        .id_instr   (id_instr)
    );
    
    //============ ID stage ==========
    //从指令中解析字段
    wire [6:0]  opcode;
    wire [2:0]  funct3;
    wire [6:0]  funct7;
    wire [4:0]  rs1,rs2,rd;
    wire [31:0] imm;
    
    decoder u_dec(
        .instr      (id_instr ),
        .opcode     (opcode),
        .funct3     (funct3),
        .funct7     (funct7),
        .rs1        (rs1   ),
        .rs2        (rs2   ),
        .rd         (rd    ),      
        .imm        (imm   )
    );
    
    //control unit
    wire RegWrite,MemRead,MemWrite,MemToReg,Branch,Jump,ALUSrc;
    wire [1:0] ALUOp;
    
    control_unit u_ctrl(
        .opcode     (opcode  ),
        .RegWrite   (RegWrite),   
        .MemRead    (MemRead ),    
        .MemWrite   (MemWrite),   
        .MemToReg   (MemToReg),   
        .Branch     (Branch  ),     
        .Jump       (Jump    ),       
        .ALUSrc     (ALUSrc  ),     
        .ALUOp      (ALUOp   )       
    );
    
    //register: writeback from WB stage
    wire [31:0] rs1_val,rs2_val;
    wire [31:0] wb_write_data;
    wire        wb_RegWrite;
    wire [4:0]  wb_rd;
    
    register_file u_rf(
        .clk        (clk    ),
        .we         (wb_RegWrite),         
        .waddr      (wb_rd  ),      
        .wdata      (wb_write_data),      
        .raddr1     (rs1 ),     
        .rdata1     (rs1_val ),     
        .raddr2     (rs2 ),     
        .rdata2     (rs2_val )     
    );
    
    //=============== Hazard Detection ============
    //load-use hazard: EX阶段的load -> 下一条用它
    wire id_ex_MemRead;
    wire [4:0] id_ex_rd;
    wire stall;
    
    hazard_detection u_hazard(
        .id_ex_MemRead  (id_ex_MemRead),
        .id_ex_rd       (id_ex_rd     ),
        .if_id_rs1      (rs1    ),
        .if_id_rs2      (rs2    ),
        .stall          (stall        )
    );
    
    //============= ID/EX pipeline ===========
    wire [31:0] ex_pc,ex_rs1_val,ex_rs2_val,ex_imm;
    wire [4:0]  ex_rs1,ex_rs2,ex_rd;
    wire [2:0]  ex_funct3;
    wire [6:0]  ex_funct7;
    wire        ex_RegWrite,ex_MemRead,ex_MemWrite,ex_MemToReg;
    wire        ex_Branch,ex_Jump,ex_ALUSrc;
    wire [1:0]  ex_ALUOp;
    
    id_ex u_idex(
        .clk    (clk),
        .rst    (rst),
        .stall  (stall),
        
        //signals from ID stage
        .id_pc          (id_pc      ),
        .id_rs1_val     (rs1_val ),
        .id_rs2_val     (rs2_val ),
        .id_imm         (imm     ),
        .id_rs1         (rs1     ),
        .id_rs2         (rs2     ),
        .id_rd          (rd      ),
                        
        .id_funct3      (funct3  ),
        .id_funct7      (funct7  ),
        .id_RegWrite    (RegWrite),   // 是否写寄存器堆
        .id_MemRead     (MemRead ),    // Data memory 读
        .id_MemWrite    (MemWrite),   // Data memory 写
        .id_MemToReg    (MemToReg),   // WB: 1=从内存写回，0=从 ALU 写回
        .id_Branch      (Branch  ),     // 分支指令
        .id_Jump        (Jump    ),       //for Jal/Jalr
        .id_ALUSrc      (ALUSrc  ),     // ALU 第二个操作数：0=rs2，1=imm
        .id_ALUOp       (ALUOp   ),      // 给 alu_control 用的高层编码
    
        //signals output to EX stage
        .ex_pc          (ex_pc      ),
        .ex_rs1_val     (ex_rs1_val ),
        .ex_rs2_val     (ex_rs2_val ),
        .ex_imm         (ex_imm     ),
        .ex_rs1         (ex_rs1     ),
        .ex_rs2         (ex_rs2     ),
        .ex_rd          (ex_rd      ),
                    
        .ex_funct3      (ex_funct3  ),
        .ex_funct7      (ex_funct7  ),
        .ex_RegWrite    (ex_RegWrite),   // 是否写寄存器堆
        .ex_MemRead     (ex_MemRead ),    // Data memory 读
        .ex_MemWrite    (ex_MemWrite),   // Data memory 写
        .ex_MemToReg    (ex_MemToReg),   // WB: 1=从内存写回，0=从 ALU 写回
        .ex_Branch      (ex_Branch  ),     // 分支指令
        .ex_Jump        (ex_Jump    ),       //for Jal/Jalr
        .ex_ALUSrc      (ex_ALUSrc  ),     // ALU 第二个操作数：0=rs2，1=imm
        .ex_ALUOp       (ex_ALUOp   )       // 给 alu_control 用的高层编码
    );
    
    // 给 hazard_detection 用的 id_ex_MemRead/id_ex_rd
    assign id_ex_MemRead = ex_MemRead;
    assign id_ex_rd      = ex_rd;
    
    // ============ EX stage ==============
    //forwarding
    wire [1:0] ForwardA,ForwardB;
    // 需要从后面两级拿信息：先声明线网，等下接
    wire        ex_mem_RegWrite;
    wire [4:0]  ex_mem_rd;
    wire [31:0] ex_mem_alu_result;
    wire        wb_RegWrite_int;
    wire [4:0]  wb_rd_int;
    // wb_write_data 前面已经声明
    
    forwarding_unit u_fwd (
        .ex_mem_RegWrite (ex_mem_RegWrite),
        .ex_mem_rd       (ex_mem_rd),
        .mem_wb_RegWrite (wb_RegWrite_int),
        .mem_wb_rd       (wb_rd_int),
        .id_ex_rs1       (ex_rs1),
        .id_ex_rs2       (ex_rs2),
        .ForwardA        (ForwardA),
        .ForwardB        (ForwardB)
    );
    
    //forwarding mux
    reg [31:0] alu_in1_pre,alu_in2_pre;
    always @(*) begin
        case(ForwardA)
            2'b10:alu_in1_pre = ex_mem_alu_result;
            2'b01:alu_in1_pre = wb_write_data;
            default: alu_in1_pre = ex_rs1_val;
        endcase
        
        case(ForwardB)
            2'b10:alu_in2_pre = ex_mem_alu_result;
            2'b01:alu_in2_pre = wb_write_data;
            default: alu_in2_pre = ex_rs2_val;
        endcase
    end
    
    wire [31:0] alu_in1 = alu_in1_pre;
    wire [31:0] alu_in2 = ex_ALUSrc ? ex_imm : alu_in2_pre;
    
    //ALU control
    wire [3:0] alu_ctrl;
    alu_control u_aluctrl(
        .ALUOp  (ex_ALUOp  ),
        .funct3 (ex_funct3 ),
        .funct7 (ex_funct7 ),
        .ALUCtrl(alu_ctrl)
    );
    
    //ALU
    wire [31:0] alu_result;
    wire        alu_zero;
    alu u_alu(
        .a          (alu_in1),
        .b          (alu_in2),      
        .alu_ctrl   (alu_ctrl), 
        .result     (alu_result),
        .zero       (alu_zero)
    );
    
    // 分支目标先简单算：pc + imm
    wire [31:0] ex_branch_target = ex_pc + ex_imm;
    
    //=================== EX/MEM pipeline ================
    wire [31:0] mem_branch_target,mem_alu_result,mem_rs2_val;
    wire [4:0]  mem_rd;
    wire        mem_zero;
    wire        mem_RegWrite, mem_MemRead, mem_MemWrite, mem_MemToReg;
    wire        mem_Branch, mem_Jump;
    
    ex_mem u_exmem(
        .clk    (clk),
        .rst    (rst),
        .stall  (1'b0),  //先不用单独stall MEM,
        
        //from EX stage
        .ex_branch_target   (ex_branch_target),     //branch/jump destination
        .ex_zero            (alu_zero         ),              //ALU zero 
        .ex_alu_result      (alu_result   ),        //ALU result
        .ex_rs2_val         (alu_in2_pre      ),           //store data
        .ex_rd              (ex_rd           ),
                           
        .ex_RegWrite        (ex_RegWrite     ),
        .ex_MemRead         (ex_MemRead      ),
        .ex_MemWrite        (ex_MemWrite     ),
        .ex_MemToReg        (ex_MemToReg     ),
        .ex_Branch          (ex_Branch       ),
        .ex_Jump            (ex_Jump         ),
        
        //to MEM stage
        .mem_branch_target  (mem_branch_target),     //branch/jump destination
        .mem_zero           (mem_zero         ),              //ALU zero 
        .mem_alu_result     (mem_alu_result   ),        //ALU result
        .mem_rs2_val        (mem_rs2_val      ),           //store data
        .mem_rd             (mem_rd           ),
                        
        .mem_RegWrite       (mem_RegWrite     ),
        .mem_MemRead        (mem_MemRead      ),
        .mem_MemWrite       (mem_MemWrite     ),
        .mem_MemToReg       (mem_MemToReg     ),
        .mem_Branch         (mem_Branch       ),
        .mem_Jump           (mem_Jump         )
    );
    
    //回接给forwarding
    assign ex_mem_RegWrite  = mem_RegWrite;
    assign ex_mem_rd        = mem_rd;
    assign ex_mem_alu_result = mem_alu_result;
    
    // ===================== MEM stage =====================
    wire [31:0] mem_read_data;
    dmem u_dmem (
        .clk       (clk),
        .MemRead   (mem_MemRead),
        .MemWrite  (mem_MemWrite),
        .addr      (mem_alu_result),
        .write_data(mem_rs2_val),
        .read_data (mem_read_data)
    );

    // （后面想做分支/跳转时，在这里用 mem_Branch/mem_zero/mem_branch_target 选择 pc_next）

    // ===================== MEM/WB pipeline =====================
    wire [31:0] wb_read_data_int, wb_alu_result_int;
    wire        wb_MemToReg_int;

    mem_wb u_memwb (
        .clk           (clk),
        .rst           (rst),
        .stall         (1'b0),
        .mem_read_data (mem_read_data),
        .mem_alu_result(mem_alu_result),
        .mem_rd        (mem_rd),
        .mem_RegWrite  (mem_RegWrite),
        .mem_MemToReg  (mem_MemToReg),

        .wb_read_data  (wb_read_data_int),
        .wb_alu_result (wb_alu_result_int),
        .wb_rd         (wb_rd_int),
        .wb_RegWrite   (wb_RegWrite_int),
        .wb_MemToReg   (wb_MemToReg_int)
    );

    // ===================== WB stage =====================
    assign wb_write_data = wb_MemToReg_int ? wb_read_data_int : wb_alu_result_int;
    assign wb_RegWrite   = wb_RegWrite_int;
    assign wb_rd         = wb_rd_int;
endmodule
