`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/18 22:05:57
// Design Name: 
// Module Name: cpu_top_tb
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

`timescale 1ns/1ps
module cpu_top_tb;

    reg clk;
    reg rst;

    // 实例化 DUT（Device Under Test）
    cpu_top uut (
        .clk (clk),
        .rst (rst)
    );

    // 生成时钟：10ns 周期 → 100MHz
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // 复位 & 跑一段时间
    initial begin
        // 初始化波形输出（如果用第三方仿真器，比如 iverilog/VCS）
        // $dumpfile("cpu_top.vcd");
        // $dumpvars(0, tb_cpu_top);

        rst = 1;
        #20;           // 复位保持 20ns
        rst = 0;

        // 跑一段时间，让流水线把指令都执行完
        #500;          // 500ns，大概 50 个时钟周期

        // 仿真结束前，打印一些关键结果：
        $display("==== Register dump ====");
        $display("x1 = %0d (uut.u_rf.regs[1])", uut.u_rf.regs[1]);
        $display("x2 = %0d (uut.u_rf.regs[2])", uut.u_rf.regs[2]);
        $display("x3 = %0d (uut.u_rf.regs[3])", uut.u_rf.regs[3]);
        $display("x4 = %0d (uut.u_rf.regs[4])", uut.u_rf.regs[4]);

        $display("==== Data memory ====");
        $display("MEM[0] (word) = %0d (uut.u_dmem.ram[0])", uut.u_dmem.ram[0]);

        // 简单自检：x3、x4、MEM[0] 都应该是 12
        if (uut.u_rf.regs[3] == 12 &&
            uut.u_rf.regs[4] == 12 &&
            uut.u_dmem.ram[0]  == 12) begin
            $display("TEST PASS ?");
        end else begin
            $display("TEST FAIL ?");
        end

        $stop;
    end

endmodule
