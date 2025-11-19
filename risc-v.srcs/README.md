# 5-Stage Pipelined RISC-V CPU (RV32I) – Verilog Implementation

This project implements a fully synthesizable **5-stage pipelined RISC-V RV32I CPU** in Verilog, including:

- Instruction Fetch (IF)
- Instruction Decode (ID)
- Execute (EX)
- Memory Access (MEM)
- Write Back (WB)

It supports full pipeline functionality with:
- **Hazard detection (load-use hazard stall)**
- **Forwarding unit (EX/MEM & MEM/WB bypass)**
- **IMEM/DMEM simulation memories**
- **Register file with dual-read single-write**
- **ALU and ALU control**
- **Immediate generator and decoder**

This CPU can successfully run basic RV32I programs such as:
addi x1, x0, 5
addi x2, x0, 7
add x3, x1, x2
sw x3, 0(x0)
lw x4, 0(x0)


---

## Project Structure
```
riscv-5stage-cpu-verilog/
│
├── sim/
│ ├── cpu_top.v
│ ├── if_id.v
│ ├── id_ex.v
│ ├── ex_mem.v
│ ├── mem_wb.v
│ ├── imem.v
│ ├── dmem.v
│ ├── dcoder.v
│ ├── register_file.v
│ ├── alu.v
│ ├── alu_control.v
│ ├── control_unit.v
│ ├── forwarding_unit.v
│ ├── hazard_detection.v
│
├── tb/
│ ├── cpu_top_tb.v
│ ├── alu_tb.v
│ ├── decoder_tb.v
│ ├── imem_tb.v
│ ├── reg_tb.v
│
├── mem/
│ ├── imem.mem
│
└── README.md
```


---

## Simulation

This CPU is designed for simulation in **Vivado**:

1. Add all `src/*.v` files to **Design Sources**
2. Add `tb/cpu_top_tb.v` to **Simulation Sources**
3. Add `mem/imem.mem` to project
4. Run Behavioral Simulation

You can inspect:
- `uut.pc`
- `uut.u_rf.regs[*]`
- `uut.u_dmem.ram[*]`
- All pipeline registers
- Forwarding and hazard signals

---

## Features Implemented

- 5-stage pipeline (IF/ID/EX/MEM/WB)
- Hazard detection (stalling on load-use)
- Forwarding (EX→EX and MEM→EX)
- Full RV32I ALU operations
- Memory load/store
- Immediate extraction
- Instruction decoder
- Register file with writeback support
