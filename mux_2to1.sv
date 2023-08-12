module mux_2to1#(
	parameter WIDTH=32)(
	input [WIDTH-1:0]in1,
	input [WIDTH-1:0]in2,
	input s,
	output logic [WIDTH-1:0]out);

always_comb
	out =s ? in2:in1;
	endmodule : mux_2to1
