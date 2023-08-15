module execute_stage (
	input               clk          ,
	input               srst         ,
	//from decode_reg
	input        [31:0] pc_e         ,
	input        [31:0] pc_plus4_e   ,
	//datapath infrom decode_reg
	input  logic [31:0] rs1_e        ,
	input  logic [31:0] rs2_e        ,
	input  logic [31:0] rd1_e        ,
	input  logic [31:0] rd2_e        ,
	input  logic [ 4:0] rd_e         ,
	input  logic [31:0] imm_ext_e    ,
	//from write back stage
	input        [31:0] result_w     ,
	//from memory stage
	input        [31:0] alu_result_m ,
	// control unit sig from decode reg
	input  logic        reg_write_e  ,
	input  logic [ 1:0] result_src_e ,
	input  logic        mem_write_e  ,
	input  logic        jump_e       ,
	input  logic        branch_e     ,
	input  logic [ 2:0] alu_control_e,
	input  logic        alu_src_e    ,
	// forwarded sigs from hazard control unit
	input  logic [ 1:0] forwardAE    ,
	input  logic [ 1:0] forwardBE    ,
	output logic        res_src_e    ,
	// out sigs to pc, fetch stage
	output logic        pc_src_e     ,
	output logic [31:0] pc_target_e  ,
	//forward memory stage reg
	output logic [31:0] pc_plus4_m   ,
	output logic [ 4:0] rd_m         ,
	output logic [31:0] alu_result_m ,
	output logic [31:0] write_data_m ,
	//control unit io
	output logic [ 1:0] result_src_m ,
	output logic        mem_write_m  ,
	output logic        reg_write_m
);

// internal reg and wires

	logic [31:0] rd1_d        ;
	logic [31:0] rd2_d        ;
	logic        jump_d       ;
	logic        branch_d     ;
	logic [ 1:0] result_src_d ;
	logic        mem_write_d  ;
	logic        alu_src_d    ;
	logic [ 1:0] imm_src_d    ;
	logic        reg_write_d  ;
	logic [ 2:0] alu_control_d;
	//datapath sigs
	logic [31:0] rs1_d    ;
	logic [31:0] rs2_d    ;
	logic [31:0] rd_d     ;
	logic [31:0] imm_ext_d;


	logic zero_e;
	logic  pc_src,


		logic [2:0] alu_cntrl;
	logic [31:0] result;

	logic [31:0] srcAE   ;
	logic [31:0] srcBE   ;
	logic [31:0] to_srcBE;

	logic [31:0] write_data_e;
	logic [31:0] alu_result_e,
// out srcAE

	mux_3to1 i_mux_3to1 (
		.in1(rd1_e       ),
		.in2(result_w    ),
		.in3(alu_result_m),
		.s  (forwardAE   ),
		.out(srcAE       )
	);
// selection of  write_data_e to select src_BE
	mux_3to1 i_mux_3to1 (
		.in1(rd2_e       ),
		.in2(result_w    ),
		.in3(alu_result_m),
		.s  (forwardBE   ),
		.out(write_data_e)
	);
// selection src_BE base on alu_src_e
	mux_2to1 i_mux_2to1 (
		.in1(write_data_e),
		.in2(imm_ext_e   ),
		.s  (alu_src_e   ),
		.out(srcBE       )
	);

// pc_target_sig gen
// pc_target  sum of imm_ext pc_e
	always_comb begin
		pc_target_e = pc_e + imm_ext_e;
	end

// alu unit to geenrate zero and alu_result
	ALU i_ALU (
		.a        (srcAE        ),
		.b        (srcBE        ),
		.alu_cntrl(alu_control_e),
		.result   (alu_result_e ),
		.zero     (zero_e       ),
		.negative (negative     ),
		.carry    (carry        ),
		.over_flow(over_flow    )
	);

//  jal and branch pcsrc
	always_comb begin
		pc_src_e  = jump_e || (branch_e && zero_e ) ;//pcscr sig to pc at fetch stage
		res_src_e = result_src_e[0]; // to hazard control unit to assert flush due to branch
	end


// decode _stage register

	always_ff @(posedge clk) begin : proc_decode_register
		if(srst) begin
			//forward memory stage reg
			pc_plus4_m   <= 0;
			rd_m         <= 0;
			alu_result_m <= 0;
			write_data_m <= 0;
			//control unit io
			result_src_m <= 0;
			mem_write_m  <= 0;
			reg_write_m  <= 0;
		end else begin
			//forward memory stage reg
			pc_plus4_m   <= pc_plus4_e;
			rd_m         <= rd_e;
			alu_result_m <= alu_result_e;
			write_data_m <= write_data_e;
			//control unit //controe
			result_src_m <= result_src_e;
			mem_write_m  <= mem_write_e;
			reg_write_m  <= reg_write_e;
		end
	end



endmodule : decode_stage