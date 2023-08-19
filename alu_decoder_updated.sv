module alu_decoder_updated (
  input  [2:0] funct3     ,
  input  [6:0] funct7     ,
  input  [6:0] op_code    ,
  input  [1:0] alu_op     ,
  output logic [2:0] alu_control
);

logic [1:0]op_funct7;

 3'd0 : {carry,result} = a + b;
      3'd1 : {carry,result} = a +  (~b) +1;
      3'd2 : result = a & b;
      3'd3 : result = a | b;
      3'd4 : result = a^b;//xor
      3'd5 : result[0] = a<b; //set if a is less than b
      3'd6 : result = a<<b;//left shift
      3'd7 : result = a>>b;//right shift
      4'd8:  result = a>>>b;// arithematic right shift
  always_comb begin : proc_alu_deocder
    op_funct7 = {op_code[5],funct7[5]};
    if(alu_op==0)
      alu_control = 3'b000;//add lw,sw instr
    else if(alu_op==2'b01)
      alu_control = 3'b001;//sub branch
    else if(alu_op==2'b10)
      begin
        case(funct3)
          'd0 : begin 
              if(op_funct7==2'b11)
                alu_control =  3'b001;//sub
              else
                alu_control =  3'b000;
              end 
          'd1   : alu_control =  3'd6;//shift left 
          'd2   : alu_control =  3'd5;//slt
          'd3   : alu_control =  3'd7;//usigned slt   zero extends
          'd4   : alu_control =  3'd4;//xor 
          'd5   :
              begin
                if(op_funct7==2'b11)
                alu_control =  4'b001;//sub
              else
                alu_control =  3'b000;
              end
          'd6   : alu_control =  3'b011;//or
          'd7   : alu_control =  3'b010;//and
          
        endcase // {funct3,op_code[5],funct7[5]}
      end
  end





endmodule : alu_decoder