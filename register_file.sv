module register_file(
	input clk,
	input srst,
	input[4:0]A1,
	input[4:0]A2,
	input[4:0]A3,
	input[31:0]WD3,
	input WE3,
	output logic [31:0]RD1,
	output logic [31:0]RD2

	);

logic[31:0][31:0] memory;

initial begin
//lw instr
memory[0]  ='0;
memory[5]  ='d5;// example 1 x5
memory[9] ='h8;//x9

end


always @(posedge clk) begin : proc_regiter_files
	if(WE3)
		memory[A3] <= WD3 ;
	end

always @(*) begin : proc_RD_x
RD2 = srst ? 0: memory[A2];
RD1 = srst ? 0: memory[A1];
end



endmodule : register_file