module data_memory
(
	input clk,
	input srst,
	input WE,
	input [31:0]A,
	input [31:0]WD,
	output logic [31:0]RD
	);
	logic [31:0] mem [4096:0] ;
initial begin
	/*foreach(mem[i]) begin
		mem[i]=i;
	end*/
	// mem[2]='h4;
	// mem[6]='hC;
	// mem[4]	= 'h8;
	// mem[8]	= 'hf;
	// mem[0] = 'h1A;

	// mem['h2000]='h10;
end

	always @(posedge clk) begin 
		mem[A] <= WE ? WD :0;
	end

	always@(*) begin : proc_
	 	RD = srst? 0: mem[A];
	end

endmodule