`timescale 1ns/1ps

`include "CPUtop.v"
`include "MEMORY.v"
`include "CU.v"
`include "ALU.v"

module CPUtop_tb;

integer simulation_mode = 1;

reg  CLK;
reg  RST;

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
    if (dut.cu.alu.B   !== B)  $fatal(simulation_mode, "Wrong value in B. Expected %d. Got %d. PC = %d. %t",  B, dut.cu.alu.r0, PC, $time);
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

initial begin
    $display("Loading rom.");
    $readmemb("rom_image.mem", dut.memory.Mem);
end

initial begin
    // Set dump file to inspect waveform
    $dumpfile("dump.vcd");
    $dumpvars(0, CPUtop_tb);

    // Set reset and all external lines to low
    RST = 1;
    // Wait 5 clock cycles
    #100
    RST = 0;
    #20
    //             C, A, B, r0,r1,PC
    checkRegisters(0, 0, 0, 0, 0, 0);

    /*#20 // Load 5 in C
    //             C, A, B, r0,r1,PC
    checkRegisters(5, 0, 0, 0, 0, 1);
    #40 // Move C to A
    //             C, A, B, r0,r1,PC
    checkRegisters(5, 5, 0, 0, 0, 2);
    #40 // Load A in C
    //             C, A, B, r0,r1,PC
    checkRegisters(10, 5, 0, 0, 0, 3);
    #40 // Move from C to B
    //             C, A, B, r0,r1,PC
    checkRegisters(10, 5, 10, 0, 0, 4);
    #40 // A+B in A
    //             C, A, B, r0,r1,PC
    checkRegisters(10, 15, 10, 0, 0, 5);

    #40 // A&B in r1
    //             C, A, B, r0,r1,PC
    checkRegisters(10, 15, 10, 0, 10, 6);
    #40 // A|B in r0
    //             C, A, B, r0,r1,PC
    checkRegisters(10, 15, 10, 15, 10, 7);
    #40 // AxorB in r1
    //             C, A, B, r0,r1,PC
    checkRegisters(10, 15, 10, 15, 5, 8);
    #40 // SR A
    //             C, A, B, r0,r1,PC
    checkRegisters(10, 7, 10, 15, 5, 9);
    #40 // SL A
    //             C, A, B, r0,r1,PC
    checkRegisters(10, 14, 10, 15, 5, 10);
    #40 // Move C to A
    //             C, A, B, r0,r1,PC
    checkRegisters(10, 10, 10, 15, 5, 11);
    #40 // Move r1 to C
    //             C, A, B, r0,r1,PC
    checkRegisters(5, 10, 10, 15, 5, 12);
    #40 // Load byte in address C in A
    //             C, A, B, r0,r1,PC
    checkRegisters(5,'h86, 10, 15, 5, 13);
    #40 // Store byte in r0 to address C
    //             C, A, B, r0,r1,PC
    checkRegisters(5,'h86, 10, 15, 5, 14);
    #40 // Load byte in address C in A
    //             C, A, B, r0,r1,PC
    checkRegisters(5, 15, 10, 15, 5, 15);
    #40 // SUB A-B in r0
    //             C, A, B, r0,r1,PC
    checkRegisters(5, 15, 10, 5, 5, 16);
    #40 // Load d37 in C
    //             C, A, B, r0,r1,PC
    checkRegisters(37, 15, 10, 5, 5, 17);
    #40 // Move C to A
    //             C, A, B, r0,r1,PC
    checkRegisters(37, 15, 37, 5, 5, 18);
    #40 // SUB A-B in r1
    //             C, A, B, r0,r1,PC
    checkRegisters(37, 15, 37, 5, -22, 19);
    #40 // Load d7 in C
    //             C, A, B, r0,r1,PC
    checkRegisters(7, 15, 37, 5, -22, 20);
    #40 // Move C to B
    //             C, A, B, r0,r1,PC
    checkRegisters(7, 15, 7, 5, -22, 21);
    #40 // MULT A*B in A
    //             C, A, B, r0,r1,PC
    checkRegisters(7, 105, 7, 5, -22, 22);
    #40 // DIV A/B in A
    //             C, A, B, r0,r1,PC
    checkRegisters(7, 15, 7, 5, -22, 23);
    // #40 // Jump to address in C
    // //             C, A, B, r0,r1,PC
    // checkRegisters(5, 15, 10, 15, 5, 5);*/
    #15000
    $finish;
end

endmodule