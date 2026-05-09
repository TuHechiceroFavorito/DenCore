`timescale 1ns / 1ps

`include "CPUtop.v"
`include "MEMORY.v"
`include "CU.v"
`include "ALU.v"

module CPUtop_tb_addition;

// Allows for different types of debugging mode
integer simulation_mode = 1;

reg  CLK;
reg  RST;

// Task to automatically check values of registers
task automatic checkRegisters (
    input [7:0] C,
    input [7:0] A,
    input [7:0] B,
    input [7:0] r0,
    input [7:0] r1,
    input [6:0] PC
);
begin
    if (dut.cu.C       !== C)  $fatal(simulation_mode, "Wrong value in C. Expected %d. Got %d. PC = %d. %t",  C, dut.cu.C, PC, $time);
    if (dut.cu.alu.A   !== A)  $fatal(simulation_mode, "Wrong value in A. Expected %d. Got %d. PC = %d. %t",  A, dut.cu.alu.A, PC, $time);
    if (dut.cu.alu.B   !== B)  $fatal(simulation_mode, "Wrong value in B. Expected %d. Got %d. PC = %d. %t",  B, dut.cu.alu.B, PC, $time);
    if (dut.cu.alu.r0  !== r0) $fatal(simulation_mode, "Wrong value in r0. Expected %d. Got %d. PC = %d. %t",  r0, dut.cu.alu.r0, PC, $time);
    if (dut.cu.alu.r1  !== r1) $fatal(simulation_mode, "Wrong value in r1. Expected %d. Got %d. PC = %d. %t",  r1, dut.cu.alu.r1, PC, $time);
    if (dut.cu.PC      !== PC) $fatal(simulation_mode, "Wrong value in PC. Expected %d. PC = %d. %t",  PC, PC, $time);
end
endtask

CPUtop dut(
    .CLK (CLK),
    .RST (RST)
);

// Start clock
initial begin
    CLK = 0;
    forever #10 CLK = ~CLK;
end

// Load memory
initial begin
    $display("Loading rom.");
    $readmemb("rom_image.mem", dut.memory.Mem);
end

initial begin

    $dumpfile("dump.vcd");
    $dumpvars(0, CPUtop_tb_addition);

    // Set reset and all external lines to low
    RST = 1;
    // Wait 5 clock cycles
    #100
    RST = 0;
    #20 // All 0s at start
    //             C, A, B, r0,r1,PC
    checkRegisters(0, 0, 0, 0, 0, 0);
    #40 // Load 3 in C
    //             C, A, B, r0,r1,PC
    checkRegisters(3, 0, 0, 0, 0, 1);
    #40 // Copy C to A
    //             C, A, B, r0,r1,PC
    checkRegisters(3, 3, 0, 0, 0, 2);
    #40 // Load 4 in C
    //             C, A, B, r0,r1,PC
    checkRegisters(4, 3, 0, 0, 0, 3);
    #40 // Copy C to B
    //             C, A, B, r0,r1,PC
    checkRegisters(4, 3, 4, 0, 0, 4);
    #40 // Add A and B in r0
    //             C, A, B, r0,r1,PC
    checkRegisters(4, 3, 4, 7, 0, 5);

    #500
    $finish;
end

endmodule