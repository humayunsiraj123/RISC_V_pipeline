
module mux_4to1#(
	parameter WIDTH=32)(
	input [WIDTH-1:0]in1,
	input [WIDTH-1:0]in2,
	input [WIDTH-1:0]in3,
	input [WIDTH-1:0]in4,
	input [1:0]s,
	output logic [WIDTH-1:0]out);

always_comb
	out =s[1] ? (s[0]? in4:in3):(s[0]? in2:in1);
	endmodule : mux_4to1
