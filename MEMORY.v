// Memory module

module MEMORY(
    input CLK,
    input RST,
    inout [7:0] DATA,
    input [7:0] ADDRESS,
    input TYPE
);

reg [7:0] Mem [255:0];
integer  i;

assign DATA = (TYPE == 0 & ~ADDRESS[7]) ? Mem[ADDRESS[6:0]] : 8'dz;

always @ (posedge CLK) begin
    if (ADDRESS[7] === 0) begin
        if (TYPE == 1) Mem[ADDRESS[6:0]] <= DATA;
    end
end

endmodule