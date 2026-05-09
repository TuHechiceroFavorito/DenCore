`include "ALU.v"

module CU (
    input CLK,
    input RST,
    inout [7:0] DATA,
    output [7:0] ADDRESS,
    output TYPE
);

ALU alu(
    .CLK (CLK),
    .RST (RST),
    .REG_ADDRESS (INSTRUCTION_reg[2:1]),
    .REG_DATA (DATA[7:0]),
    .REG_WRITE (READ_WRITE),
    .OPCODE (INSTRUCTION_reg[7:3]),
    .STATE (ExCycle),
    .BRANCH (BRANCH)
);

reg [1:0] ExCycle;
reg [7:0] INSTRUCTION_reg;
reg [6:0] PC;
reg signed [7:0] C;

wire READ_WRITE;
wire BRANCH;

wire [7:0] NextC;
wire [7:0] UpdateC;

localparam FETCH = 2'd0, EXECUTE = 2'd1;

// Read/write decode operation. Write 1, read 0
assign READ_WRITE = (~INSTRUCTION_reg[0] & (INSTRUCTION_reg[7] | INSTRUCTION_reg[7:3] == 4'h1 | INSTRUCTION_reg[7:3] == 4'h3)) ? 1 : 0;

//ExCycle
always @ (posedge CLK) begin
    if (RST == 1) ExCycle <= FETCH;
    else begin
        if (ExCycle == EXECUTE) ExCycle <= 0;
        else ExCycle <= ExCycle + 1;
    end
end

// Demux for address line
assign ADDRESS = (ExCycle == FETCH) ? {1'b0, PC} : 
    (ExCycle == EXECUTE & ~INSTRUCTION_reg[0] & (INSTRUCTION_reg[6:3] == 4'b11 | INSTRUCTION_reg[6:3] == 4'b100)) ? {1'b0, C[6:0]}:
    8'hff;

// Instruction register
always @ (posedge CLK) begin
    if (RST == 1) INSTRUCTION_reg <= 0;
    else begin
        if (ExCycle == FETCH) INSTRUCTION_reg <= DATA;
    end
end


// PC
always @ (posedge CLK) begin
    if (RST == 1) PC <= 0;
    else begin
        if (ExCycle == EXECUTE & (~BRANCH | INSTRUCTION_reg[0])) PC = PC + 1;
        else if (ExCycle == EXECUTE & BRANCH & ~INSTRUCTION_reg[0]) PC = C;
    end
end

// // Mux for C register
// assign UpdateC = (INSTRUCTION_reg[0] | INSTRUCTION_reg[7:3] == 5'h2 & ExCycle == EXECUTE) ? DATA: C;
// assign NextC = (INSTRUCTION_reg[0] & ExCycle == EXECUTE) ? {1'b0, UpdateC[7:1]}: UpdateC;

// C register
always @ (posedge CLK) begin
    if (RST == 1) C <= 0;
    else begin
        if (INSTRUCTION_reg[0] & ExCycle == EXECUTE) C <= {1'h0, INSTRUCTION_reg[7:1]};
        else if (INSTRUCTION_reg[7:3] == 5'h2 & ExCycle == EXECUTE) C <= DATA;
    end
end

// Demux data
assign DATA = (~INSTRUCTION_reg[0] & INSTRUCTION_reg[7:3] == 5'h1 & ExCycle == EXECUTE) ? C : 8'h0;

// Type line
assign TYPE = (~INSTRUCTION_reg[0] & INSTRUCTION_reg[7:3] == 5'h4 & ExCycle == EXECUTE);

endmodule