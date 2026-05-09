// ALU

module ALU(
    input CLK,
    input RST,
    input [1:0] REG_ADDRESS,
    inout [7:0] REG_DATA,
    input REG_WRITE,
    input [4:0] OPCODE,
    input [1:0] STATE,
    output BRANCH
);

localparam OP_LOAD = 5'b0001, OP_LOAD_BYTE = 5'b0011;
localparam OP_ADD = 5'b10100, OP_SUB = 5'b10101, OP_MULT = 5'b10110, OP_DIV = 5'b10111;
localparam OP_AND = 5'b10000, OP_OR = 5'b10001, OP_XOR = 5'b10010, OP_NOT = 5'b10011;
localparam OP_SR = 5'b11000, OP_SL = 5'b11001;
localparam OP_EQ = 5'b11010, OP_GT = 5'b11011;

localparam OP_BEQ = 5'b00110, OP_BNQ = 5'b00111, OP_BGT = 5'b01000, OP_JUMP = 5'b00101;

reg signed [7:0] A;
wire [7:0] NextA;

reg signed [7:0] B;
wire [7:0] NextB;

reg signed [7:0] r0;
wire [7:0] Nextr0;

reg signed [7:0] r1;
wire [7:0] Nextr1;

// reg [7:0] r2;
// wire [7:0] Nextr2;

// reg [7:0] r3;
// wire [7:0] Nextr3;

// reg [7:0] r4;
// wire [7:0] Nextr4;

// reg [7:0] r5;
// wire [7:0] Nextr5;


wire [7:0] sum;
wire [7:0] sub;
wire [7:0] mult;
// wire [7:0] div;
wire [7:0] AND;
wire [7:0] OR;
wire [7:0] XOR;
wire [7:0] NOT;
wire [7:0] SR;
wire [7:0] SL;
wire [7:0] EQ;
wire [7:0] GT;
wire [7:0] Update;

localparam FETCH = 2'd0, EXECUTE = 2'd1, ADVANCE = 2'd2;


// A
always @ (posedge CLK) begin
    if (RST == 1) A <= 0;
    else A <= NextA;
end
// Mux for NextA
assign NextA = (REG_ADDRESS == 'b0 & REG_WRITE & STATE == EXECUTE) ? Update : A;


// B
always @ (posedge CLK) begin
    if (RST == 1) B <= 0;
    else B <= NextB;
end
// Mux for NextB
assign NextB = (REG_ADDRESS == 'b1 & REG_WRITE & STATE == EXECUTE) ? Update : B;


// R0
always @ (posedge CLK) begin
    if (RST == 1) r0 <= 0;
    else r0 <= Nextr0;
end
// Mux for Nextr0
assign Nextr0 = (REG_ADDRESS == 'b10 & REG_WRITE & STATE == EXECUTE) ? Update : r0;


// R1
always @ (posedge CLK) begin
    if (RST == 1) r1 <= 0;
    else r1 <= Nextr1;
end
// Mux for Nextr1
assign Nextr1 = (REG_ADDRESS == 'b11 & REG_WRITE & STATE == EXECUTE) ? Update : r1;

// // R2
// always @ (posedge CLK) begin
//     if (RST == 1) r2 <= 0;
//     else r2 <= Nextr2;
// end
// // Mux for Nextr2
// assign Nextr2 = (REG_ADDRESS == 'b100 & REG_WRITE & STATE == EXECUTE) ? Update : r2;

// // R3
// always @ (posedge CLK) begin
//     if (RST == 1) r3 <= 0;
//     else r3 <= Nextr3;
// end
// // Mux for Nextr3
// assign Nextr3 = (REG_ADDRESS == 'b101 & REG_WRITE & STATE == EXECUTE) ? Update : r3;

// // R4
// always @ (posedge CLK) begin
//     if (RST == 1) r4 <= 0;
//     else r4 <= Nextr4;
// end
// // Mux for Nextr4
// assign Nextr4 = (REG_ADDRESS == 'b110 & REG_WRITE & STATE == EXECUTE) ? Update : r4;

// // R4
// always @ (posedge CLK) begin
//     if (RST == 1) r5 <= 0;
//     else r5 <= Nextr4;
// end
// // Mux for Nextr4
// assign Nextr5 = (REG_ADDRESS == 'b111 & REG_WRITE & STATE == EXECUTE) ? Update : r5;



// Arithmetic and logical operations
assign sum = A+B;
assign sub = A-B;
assign mult = A*B;
//assign div = A/B;
assign AND = A&B;
assign OR = A|B;
assign XOR = (A|B)&~(A&B);
assign NOT = ~A;
assign SR = {1'b0, A[7:1]};
assign SL = {A[6:0], 1'b0};
assign EQ = A==B;
assign GT = A>B;


// MUX for selecting what operation to store
assign Update =
    (OPCODE == OP_ADD)  ? sum      :
    (OPCODE == OP_SUB)  ? sub      :
    (OPCODE == OP_MULT) ? mult     :
    // (OPCODE == OP_DIV) ? div      :
    (OPCODE == OP_AND)  ? AND      :
    (OPCODE == OP_OR)   ? OR       :
    (OPCODE == OP_XOR)  ? XOR      :
    (OPCODE == OP_NOT)  ? NOT      :
    (OPCODE == OP_SR)   ? SR       :
    (OPCODE == OP_SL)   ? SL       :
    (OPCODE == OP_EQ)   ? EQ       :
    (OPCODE == OP_GT)   ? GT       :
    (OPCODE == OP_LOAD | OPCODE == OP_LOAD_BYTE) ? REG_DATA :
    8'h0;

// Mux for REG_DATA
assign REG_DATA =
    (~REG_WRITE & REG_ADDRESS == 3'h0 & STATE == EXECUTE & (OPCODE == 5'h2 | OPCODE == 5'h4))  ? A      :
    (~REG_WRITE & REG_ADDRESS == 3'h1 & STATE == EXECUTE & (OPCODE == 5'h2 | OPCODE == 5'h4))  ? B      :
    (~REG_WRITE & REG_ADDRESS == 3'h2 & STATE == EXECUTE & (OPCODE == 5'h2 | OPCODE == 5'h4))  ? r0     :
    (~REG_WRITE & REG_ADDRESS == 3'h3 & STATE == EXECUTE & (OPCODE == 5'h2 | OPCODE == 5'h4))  ? r1     :
    8'h0;

// Branching logic
assign BRANCH = (OPCODE == OP_BEQ & A == B | OPCODE == OP_BNQ & A != B | OPCODE == OP_BGT & A > B | OPCODE == OP_JUMP) ? 1 : 0;

endmodule