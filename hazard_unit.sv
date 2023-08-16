module hazard_unit (
	input        [4:0] rs1_d       ,
	input        [4:0] rs2_d       ,
	input        [4:0] rs1_e       ,
	input        [4:0] rs2_e       ,
	input        [4:0] rd_e        ,
	input              pcsrc_e     ,
	input        [1:0] result_src_e,
	input        [4:0] rd_m        ,
	input              reg_write_m ,
	input              reg_write_w ,
	input        [4:0] rd_w        ,
	output logic       stall_f     ,
	output logic       stall_d     ,
	output logic       flush_d     ,
	output logic       flush_e     ,
	output logic [1:0] forwardAE   ,
	output logic [1:0] forwardBE   ,
);

	logic lw_stall = 0;
	always_comb begin
// load word stall
		lw_stall = result_src_e[0]&&((rs1_d==rd_e)||(rs2_d==rd_e));
		stall_f  = lw_stall;
		stall_d  = lw_stall;
//RAW hazard solf

//for scrB
		if(((rs1_e==rd_m) && reg_write_m) & (rs1_e!==0))
			forwardAE = 'b10;
		else if(((rs1_e==rd_w) && reg_write_w) & (rs1_e!==0))
			forwardAE = 'b10;
	end
	forwardAE ='b00;
//foor scrB
	if(((rs2_e==rd_m) && reg_write_m) & (rs2_e!==0))
		forwardBE ='b10;
	else if(((rs2_e==rd_w) && reg_write_w) & (rs2_e!==0))
		forwardBE ='b10;
	end
	forwardBE ='b00;
//flush two instruction branch
	flush_d =pcsrc_e;
	flush_e =flush_d


	endmodule