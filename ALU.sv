module ALU #(parameter WIDTH=32) (
	input  [WIDTH-1:0] a        ,
	input  [WIDTH-1:0] b        ,
	input  [      2:0] alu_cntrl,
	output logic [WIDTH-1:0] result   ,
	output logic             zero     ,
	output logic             negative ,
	output logic             carry    ,
	output logic             over_flow
);

	logic [WIDTH-1:0] sum =0;
	
  logic             cout=0;


	// always_comb begin :alu_control
	// 	{cout,sum} = alu_cntrl[0] ?  a + (1+ (~b)): a + b ;
	// 	case (alu_cntrl[2:1])
	// 		2'b00 : result = sum;
	// 		2'b01 : result = sum;
	// 		2'b10 : result = a & b;
	// 		2'b11 : result = a | b;
	// 	endcase

// NOT instruction is perform with xori with -1 
  always_comb begin : proc_
   sum =a+b; 
   result = 0;
    case(alu_cntrl)
      3'd0 : {carry,result} = a + b;
      3'd1 : {carry,result} = a +  (~b) +1;
      3'd2 : result = a & b;
      3'd3 : result = a|b;
      3'd4 : result = a^b;//xor
      3'd5 : result[0] = a<b; //set if a is less than b
      3'd6 : result = a<<b;//left shift
      3'd7 : result = b>>a;//right shift
      default: result = 0;
    endcase
		carry     =  ~alu_cntrl[1] && cout;
		over_flow = (sum[31] ^ a[31]) &&(~(a[31] ^b[31] ^ alu_cntrl[0])) && ~alu_cntrl[1];
		zero     = &(!(sum));
		negative = result[31];


	end


endmodule
