// Top module for the CPU. Here is where everything is connected together through the bus
`include "MEMORY.v"
`include "CU.v"

module CPUtop(
    input CLK,
    input RST,
    output [7:0] OUT_DATA,
    output [7:0] OUT_ADDRESS,
    output OUT_TYPE
);

wire [7:0] DATA;
wire [7:0] ADDRESS;
wire TYPE;

// Conectamos los cables internos a los pines de salida físicos del chip
assign OUT_DATA = DATA;
assign OUT_ADDRESS = ADDRESS;
assign OUT_TYPE = TYPE;


MEMORY memory (
    .CLK (CLK),
    .RST (RST),
    .DATA (DATA),
    .ADDRESS (ADDRESS),
    .TYPE (TYPE)
);

CU cu (
    .CLK (CLK),
    .RST (RST),
    .DATA (DATA),
    .ADDRESS (ADDRESS),
    .TYPE (TYPE)
);

endmodule