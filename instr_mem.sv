module instr_mem (
	input [31:0] Addr,    // addr 
	output logic [31:0] RD // read Data
);

logic [31:0] memory [1023:0];

initial begin
$readmemh("instr_mem.hex",memory);
// memory[0] = 'hFFC4A303;
// memory[1] = 'h0064A423;
// memory[2] = 'h0062E233;
// memory[3] = 'hFE420AE3;
end
always_comb begin : proc_instr_mem

RD = memory[Addr[31:2]];//as we need to read addr multiple for 4 
end

endmodule



