module write_back_stage (
	input              clk         ,
	input              srst        ,
	//control unit write_back stage
	input logic              reg_write_w ,
	input logic              result_src_w
	// execute stage reg
	input logic [ 4:0] rd_w        ,
	input logic [31:0] read_data_w ,
	input logic [31:0] alu_result_w,
	input logic [31:0] pc_plus4_w  ,
	//
	output logic reg_write_w_out,
	output logic [31:0]result_w
	);


	logic [31:0] read_write_m; //



	assign reg_write_w_out = reg_write_w;

	mux_3to1 i_mux_3to1 (
		.in1(alu_result_w),
		.in2(read_write_w),
		.in3(pc_plus4_w  ),
		.s  (result_src_w),
		.out(result_w    )
	);


endmodule : write_back_stage