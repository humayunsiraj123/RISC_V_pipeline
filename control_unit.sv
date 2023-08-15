module control_unit(
  input        [31:0] instr      ,
  input               zero       ,
  output logic        jump       ,
  output logic        branch     ,
  output logic [ 1:0] result_src ,
  output logic        mem_w      ,
  output logic        alu_src    ,
  output logic [ 1:0] imm_src    ,
  output logic        reg_w      ,
  output logic        pc_src     ,
  output logic [ 2:0] alu_control
);

  logic [6:0] op_code    ;
  logic [2:0] funct3     ;
  logic [6:0] funct7     ;
  logic [1:0] alu_op  = 0; //wire of alu_op from main to alu decoder
// main decoder module of control path
  always_comb
    begin
      op_code = instr[6:0];
      funct3  = instr[14:12];
      funct7  = instr[31:25];
    end



  //logic [1:0] imm_src;
  //addedI type and jal instrution support
  main_decoder i_main_decoder (
    .op_code   (op_code   ),
    .funct3    (funct3    ),
    .funct7    (funct7    ),
    .alu_op    (alu_op    ),
    .branch    (branch    ),
    .jump      (jump      ),
    .result_src(result_src), // TODO: Check connection ! Signal/port not matching : Expecting logic [1:0]  -- Found logic
    .mem_w     (mem_w     ),
    .alu_src   (alu_src   ),
    .imm_src   (imm_src   ),
    .reg_w     (reg_w     )
  );

  alu_decoder i_alu_decoder (
    .funct3     (funct3     ),
    .funct7     (funct7     ),
    .op_code    (op_code    ),
    .alu_op     (alu_op     ),
    .alu_control(alu_control)
  );

  always_comb begin : proc_x
    pc_src = (branch&&zero) || jump;//add jal branch support
  end



endmodule : control_unit