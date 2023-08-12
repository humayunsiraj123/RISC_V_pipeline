module main_decoder (
  input  [6:0] op_code   ,
  input  [2:0] funct3    ,
  input  [6:0] funct7    ,
  output logic [1:0] alu_op    ,
  output logic       branch    ,
  output logic       jump      ,
  output logic [1:0] result_src,
  output logic       mem_w     ,
  output logic       alu_src   ,
  output logic [1:0] imm_src   ,
  output logic       reg_w
);

  enum logic[6:0] {
    LW     = 7'b0000011,
    SW     = 7'b0100011,
    BEQ    = 7'b1100011,
    I_TYPE = 7'b0010011,//itype instruction
    R_TYPE = 7'b0110011,
    JAL    = 7'b1101111} instr_e;

  logic [10:0] decode_res;
  assign {reg_w,imm_src,alu_src,mem_w,result_src,branch,alu_op,jump} = decode_res;


  always_comb begin : proc_main_decoder
    case (op_code)
      LW      : decode_res = 11'b100_1001_0000;//11'b100_1001_0000 replace x with zero
      SW      : decode_res = 11'b001_1100_0000;//11'b001_11xx_0000 
      R_TYPE  : decode_res = 11'b100_0000_0100;//11'b1xx_0000_0100 
      BEQ     : decode_res = 11'b010_0000_1010;//11'b010_00xx_1010 
      I_TYPE  : decode_res = 11'b100_1000_0100;//11'b100_1000_0100 
      JAL     : decode_res = 11'b111_0010_0001;//11'b111_x010_0xx1 
      default : decode_res = 0;
    endcase


  end : proc_main_decoder
endmodule : main_decoder