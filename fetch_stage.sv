module fetch_stage(
	input clk,
	input srst,
	input stall_f,
	input pcsrc_e,
	input [31:0]pc_target_e,
	output logic [31:0]instr_f,
	output logic [31:0]pc_f,
	output logic [31:0]pc_plus4_f);


	logic [31:0] pc_in;//input to pc_reg
	

// mux to selection pc_in value
	mux_2to1 i_mux_2to1 (
		.in1(pc_plus4_f),// plus 4 in previous pc value to jump om next instrc as word addressable mem anf each word of 4bytes
		.in2(pc_target_e),//form execution stage //branch and jal instr 
		.s(pcsrc_e),//to check if jal or branch
		.out(pc_in));

//pc_f + 4 ,pc_f adder
	always_comb begin : proc_pc_mux
		pc_plus4_f = pc_f + 4;
	end

	logic enable;
	logic [31:0] pc_next;

//pc reg
	pc_reg i_pc_reg (
		.clk(clk),
		.srst(srst),
		.enable(stall_f),//stall is active high else pc+4 and when stall it wont updated the pc value
		.pc_next(pc_in),
		.pc(pc_f)
		);
//instruction memory
	instr_mem i_instr_mem (
		.Addr(pc_ff),
		.RD(instr_f)
		 );




endmodule