module alu_decoder (
  input  [2:0] funct3     ,
  input  [6:0] funct7     ,
  input  [6:0] op_code    ,
  input  [1:0] alu_op     ,
  output logic [2:0] alu_control
);

  always_comb begin : proc_alu_deocder
    if(alu_op==0)
      alu_control = 3'b000;//add lw,sw instr
    else if(alu_op==2'b01)
      alu_control = 3'b001;//sub branch
    else if(alu_op==2'b10)
      begin
        case({funct3,op_code[5],funct7[5]})
          'b000_11 : alu_control =  3'b001;//add
          'b000_?? : alu_control =  3'b000;//sub
          'b010_?? : alu_control =  3'b101;//slt
          'b110_?? : alu_control =  3'b011;//or
          'b111_?? : alu_control =  3'b010;//and
          //default:alu_control =  3'b010;//
        endcase // {funct3,op_code[5],funct7[5]}
      end
  end





endmodule : alu_decoder