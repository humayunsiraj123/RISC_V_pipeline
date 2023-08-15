
module mux_3to1#(
	parameter WIDTH=32)(
	input [WIDTH-1:0]in1,
	input [WIDTH-1:0]in2,
	input [WIDTH-1:0]in3,

	input [1:0]s,
	output logic [WIDTH-1:0]out);

always_comb
	out=0;
	case(s)
		2'b00 : out = in1;
		2'b01: out = in2;
		2'b10: out = in3;
	endcase
	endmodule : mux_3to1
