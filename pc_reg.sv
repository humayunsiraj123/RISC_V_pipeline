module pc_reg (
	input               clk    , // Clock
	input               srst   , // Asynchronous reset active high
	input               enable,
	input        [31:0] pc_next,
	output logic [31:0] pc
);
//initial begin

//end

	always_ff @(posedge clk) begin : proc_program_counter
		if(srst) begin
			pc <= 'h0;//sample program
		end else if(!enable) begin// for stall f 
			pc <= pc_next ;
		end
	end
	
endmodule