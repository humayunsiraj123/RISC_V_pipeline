module extend (
	input  [31:0] imm    ,
	input  [3:0 ] imm_src,
	output logic [31:0] imm_ext  // Clock Enable
);

	logic [11:0] A=0;
	always_comb begin : proc_immediate_extend
		case(imm_src)
		3'b000 : imm_ext = {{20{imm[31]}},imm[31:20]}; //for  lw type instru
		3'b001 : imm_ext = {{20{imm[31]}},imm[31:25],imm[11:7]};// for SW type instr rd is immediate
		3'b010 : imm_ext = {{20{imm[31]}},imm[7],imm[30:25],imm[11:8],1'b0};//for beq instruction
		3'b011 : imm_ext = {{12{imm[31]}},imm[19:12],imm[20],imm[30:21],1'b0};//for jump and link instr    }
		3'b100 : imm_ext = {{12{imm[31]}},imm[31:12]};//U type
		3'b101 : imm_ext = {{12{imm[31]}},imm[19:12],imm[20],imm[30:21],1'b0};//UJ type
		endcase // imm_src
		//A = imm_src[0] ? {imm[31:25],imm[11:7]}:imm[31:20];//selecting immedaite src as for lw instrutcion immediate is				// instr[31:0] while in SW instr [31:25]and[11:7]
		//B = A[11] ? {{'1},A}:{{'0},A};
	end

endmodule