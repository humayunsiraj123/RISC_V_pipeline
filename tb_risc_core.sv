module tb_risc_core ();
	logic clk  = 0;
	logic srst = 0;

/*	risc_core i_risc_core (
	.clk (clk ),
	.srst(srst)
	);
*/
	// top_riscv_single_cycle i_top_riscv_single_cycle (
	// 	.clk (clk ),
	// 	.srst(srst)
	// );

	risc_v_pipeline_core i_risc_v_pipeline_core (
		.clk (clk ),
		.srst(srst)
	);



	always #50 clk =~clk;

	initial begin
		$dumpfile("dump.vcd");
		$dumpvars(0,tb_risc_core);
		srst = 1;
		@(posedge clk);
		srst = 0;

		repeat(20) @(posedge clk);
		$stop();

	end
endmodule