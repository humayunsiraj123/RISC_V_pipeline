module memory_stage (
	input               clk         ,
	input               srst        ,
	// execute stage reg
	input  logic [ 4:0] rd_m        ,
	input  logic [31:0] alu_result_m,
	input  logic [31:0] write_data_m,
	input  logic [31:0] pc_plus4_m  ,
	//control unit memory stage
	input  logic        reg_write_m ,
	input  logic [ 1:0] result_src_m,
	input  logic        mem_write_m ,
	//write back memory stage reg
	output logic [ 4:0] rd_w        ,
	output logic [31:0] read_data_w ,
	output logic [31:0] alu_result_w,
	output logic [31:0] pc_plus4_w  ,
	//control unit write_back stage
	output logic        reg_write_w ,
	output logic [ 1:0] result_src_w
);


	logic [31:0] read_write_m=0; //


// data_memory
	data_memory i_data_memory (
		.clk (clk         ),
		.srst(srst        ),
		.WE  (mem_write_m ),
		.A   (alu_result_m),
		.WD  (write_data_m),
		.RD  (read_write_m)
	);



// decode _stage register

	always_ff @(posedge clk) begin : proc_decode_register
		if(srst) begin
			//forward memory stage reg
			pc_plus4_w   <= 0;
			rd_w         <= 0;
			alu_result_w <= 0;
			read_data_w <=0;
			//control unit io
			result_src_w <= 0;
			reg_write_w  <= 0;
		end else begin
			//forward memory stage reg
			pc_plus4_w   <= pc_plus4_m;
			rd_w         <= rd_m;
			alu_result_w <= alu_result_m;
			read_data_w  <= read_write_m;
			//control unit //controe
			result_src_w <= result_src_m;
			reg_write_w  <= reg_write_m;
		end
	end



endmodule : memory_stage