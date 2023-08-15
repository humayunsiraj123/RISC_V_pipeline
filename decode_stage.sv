module decode_stage (
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
	// out sig to reg_decode
	output logic [31:0] pc_e         ,
	output logic [31:0] pc_plus4_e   ,
	//control unit io
	output logic        jump_e       ,
	output logic        branch_e     ,
	output logic [ 1:0] result_src_e ,
	output logic        mem_write_e  ,
	output logic        alu_src_e    ,
	output logic        reg_write_e  ,
	output logic [ 2:0] alu_control_e,
	//datapath sigs
	output logic [31:0] rs1_e        ,
	output logic [31:0] rs2_e        ,
	output logic [31:0] rd_e         ,
	output logic [31:0] imm_ext_e    ,
);

// internal reg and wires
	logic       jump_d       ;
	logic       branch_d     ;
	logic [1:0] result_src_d ;
	logic       mem_write_d  ;
	logic       alu_src_d    ;
	logic [1:0] imm_src_d    ;
	logic       reg_write_d  ;
	logic [2:0] alu_control_d;
	//datapath sigs
	logic [31:0] rs1_d    ;
	logic [31:0] rs2_d    ;
	logic [31:0] rd_d     ;
	logic [31:0] imm_ext_d;


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

	always_ff @(posedge clk) begin : proc_decode_register
		if(srst || flush_e) begin
			pc_e          <= 0;
			pc_plus4_e    <= 0;
			//control <= 0 unit io
			jump_e        <= 0;
			branch_e      <= 0;
			result_src_e  <= 0;
			mem_write_e   <= 0;
			alu_src_e     <= 0;
			reg_write_e   <= 0;
			alu_control_e <= 0;
			//datapath <= 0 sigs
			rs1_e         <= 0;
			rs2_e         <= 0;
			rd_e          <= 0;
			imm_ext_e     <= 0;
		end else begin
			pc_e          <= pc_d          ;
			pc_plus4_e    <= pc_plus4_d    ;
			//control <=controd  unit io
			jump_e        <= jump_d        ;
			branch_e      <= branch_d      ;
			result_src_e  <= result_src_d  ;
			mem_write_e   <= mem_write_d   ;
			alu_src_e     <= alu_src_d     ;
			reg_write_e   <= reg_write_d   ;
			alu_control_e <= alu_control_d ;
			//datapath <=datapatd  sigs
			rs1_e         <= rs1_d         ;
			rs2_e         <= rs2_d         ;
			rd_e          <= rd_d          ;
			imm_ext_e     <= imm_ext_d     ;
		end
	end



endmodule : decode_stage