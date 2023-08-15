module decode_stage_simple (
	input               clk          ,
	input               srst         ,
	//from fetch_reg
	input        [31:0] instr_d      ,
	input        [31:0] pc_d         ,
	input        [31:0] pc_plus4_d   ,
	//from write back stage
	input               reg_write_w  ,
	input        [ 4:0] rd_w         ,
	input        [31:0] result_w     ,
	//control unit io
	output logic        jump_d       ,
	output logic        branch_d     ,
	output logic [ 1:0] result_src_d ,
	output logic        mem_write_d  ,
	output logic        alu_src_d    ,
	output logic [ 1:0] imm_src_d    ,
	output logic        reg_write_d  ,
	output logic [ 2:0] alu_control_d,
	//datapath sigs
	output logic [31:0] rs1_d        ,
	output logic [31:0] rs2_d        ,
	output logic [31:0] rd_d         ,
	output logic [31:0] imm_ext_d    ,
);



	logic zero = 0;
	logic  pc_src,

// controller unit
	control_unit i_control_unit (
		.instr      (instr_d      ),
		.zero       (zero         ),
		.jump       (jump_d       ),
		.branch     (branch_d     ),
		.result_src (result_src_d ),
		.mem_w      (mem_write_d  ),
		.alu_src    (alu_src_d    ),
		.imm_src    (imm_src_d    ),
		.reg_w      (reg_write_d  ),
		.pc_src     (pc_src_d     ),
		.alu_control(alu_control_d)
	);



	logic [ 4:0] A1 ;
	logic [ 4:0] A2 ;
	logic [ 4:0] A3 ;
	logic [31:0] WD3;
	logic        WE3;
	logic [31:0] RD1;
	logic [31:0] RD2;
	always_comb begin : proc_
		A1    = instr_d[19:15];
		A2    = instr_d[24:20];
		rs1_d = A1 ;//instr_d[19:15];
		rs2_d = A2 ;
		rd_d  = instr_d[11:7];
	end



	register_file i_register_file (
		.clk (clk        ),
		.srst(srst       ),
		.A1  (A1         ),
		.A2  (A2         ),
		.A3  (rd_w       ),
		.WD3 (result_w   ),
		.WE3 (reg_write_w),
		.RD1 (RD1        ),
		.RD2 (RD2        )
	);


//	immediate sign extend
	extend i_extend (
		.imm    (imm_ext_d),
		.imm_src(imm_src_d),
		.imm_ext(imm_ext_d)
	);


// decode _stage register





endmodule : decode_stage