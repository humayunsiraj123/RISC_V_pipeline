module fetch_reg (
	input               clk       ,
	input               srst      ,
	input               stall_d   ,
	input               flush_d   ,
	input        [31:0] pc_plus4_f,
	input        [31:0] pc_f      ,
	input        [31:0] instr_f   ,
	output logic [31:0] pc_plus4_d,
	output logic [31:0] pc_d      ,
	output logic [31:0] instr_d
);



	always_ff @(posedge clk) begin : proc_fetch_reg
		if(srst||flush_d) begin
			pc_plus4_d <= 0;
			pc_d       <= 0;
			instr_d    <= 0;
		end else if(!stall_d) begin
			pc_plus4_d <= pc_plus4_f ;
			pc_d       <= pc_f ;
			instr_d    <= instr_f ;
		end
	end


endmodule