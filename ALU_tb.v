`include "ALU.v"

module ALU_tb;

integer simulation_mode = 1;

reg  CLK;
reg  RST;
wire [7:0] DATA;
reg [7:0] ADDRESS;
reg TYPE;

reg [7:0] DATA_driver;
wire [7:0] DATA_receive;

assign DATA = DATA_driver;
assign DATA_receive = DATA;

ALU dut(
    .CLK (CLK),
    .RST (RST),
    .DATA (DATA),
    .ADDRESS (ADDRESS),
    .TYPE (TYPE)
);

// Start clock
initial begin
    CLK = 0;
    forever #10 CLK = ~CLK;
end

initial begin
    // Set dump file to inspect waveform
    $dumpfile("dump.vcd");
    $dumpvars(0, ALU_tb);

    // Set reset and all external lines to low
    DATA_driver = 8'bz;
    RST = 1;
    ADDRESS = 8'h0;
    TYPE = 0;
    // Wait 5 clock cycles
    #100
    RST = 0;
    #20
    if (dut.A != 0) $fatal(simulation_mode, "A not at reset value %t", $time);
    if (dut.B != 0) $fatal(simulation_mode, "B not at reset value %t", $time);
    #10
    // Write into A
    ADDRESS = 8'b00010001;
    DATA_driver = 8'h69;
    TYPE = 1;
    /*#20
    ADDRESS = 8'hz;
    DATA_driver = 8'bz;
    TYPE = 0;*/
    #20
    #10
    // Check
    if (dut.A != 8'h69) $fatal(simulation_mode, "A didn't store value %t", $time);
    if (dut.B != 0) $fatal(simulation_mode, "B value changed %t", $time);
    #10
    // Read A
    ADDRESS = 8'b00010001;
    DATA_driver = 8'bz;
    TYPE = 0;
    #20
    if (DATA != 8'h69) $fatal(simulation_mode, "A didnt send to DATA line %t", $time);
    #20
    // Write into B
    ADDRESS = 8'b00011001;
    DATA_driver = 8'h42;
    TYPE = 1;
    #20
    #10
    if (dut.B != 8'h42) $fatal(simulation_mode, "B didnt send to DATA line %t", $time);
    #10
    // Read B
    ADDRESS = 8'b00011001;
    DATA_driver = 8'bz;
    TYPE = 0;
    #20
    if (DATA != 8'h42) $fatal(simulation_mode, "A didnt send to DATA line %t", $time);
    #20
    // Wire A+B in A
    ADDRESS = 8'b00010010;
    DATA_driver = 8'bz;
    TYPE = 1;
    #20
    ADDRESS = 8'bz;
    DATA_driver = 8'bz;
    TYPE = 0;
    #10
    if (dut.A != 8'hAB) $fatal(simulation_mode, "A didnt store the sum of A and B %t", $time);
    #10
    // Read A
    ADDRESS = 8'b00010001;
    DATA_driver = 8'bz;
    TYPE = 0;
    #20
    if (DATA != 8'hAB) $fatal(simulation_mode, "A didnt send to DATA line %t", $time);
    #20
    // Check subtraction
    ADDRESS = 8'b00011011;
    DATA_driver = 8'bz;
    TYPE = 1;
    #20
    ADDRESS = 8'bz;
    DATA_driver = 8'bz;
    TYPE = 0;
    #10
    if (dut.B != 8'h69) $fatal(simulation_mode, "A didnt store the subtraction of A and B %t", $time);
    #10
    #20
    // Check bitwise AND
    ADDRESS = 8'b00010100;
    DATA_driver = 8'bz;
    TYPE = 1;
    #20
    ADDRESS = 8'bz;
    DATA_driver = 8'bz;
    TYPE = 0;
    #10
    if (dut.A != 8'h29) $fatal(simulation_mode, "A didnt store the A|B %t", $time);
    #10
    #20
    // Check bitwise XOR
    ADDRESS = 8'b00010110;
    DATA_driver = 8'bz;
    TYPE = 1;
    #20
    ADDRESS = 8'bz;
    DATA_driver = 8'bz;
    TYPE = 0;
    #10
    if (dut.A != 8'h40) $fatal(simulation_mode, "A didnt store the A^B %t", $time);
    #10
    #20
    // Check bitwise OR
    ADDRESS = 8'b00010101;
    DATA_driver = 8'bz;
    TYPE = 1;
    #20
    ADDRESS = 8'bz;
    DATA_driver = 8'bz;
    TYPE = 0;
    #10
    if (dut.A != 8'h69) $fatal(simulation_mode, "A didnt store the A|B %t", $time);
    #10
    #80

    
    $finish;
end

endmodule