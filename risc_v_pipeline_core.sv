module risc_v_pipeline_core (
  input clk , // Clock
  input srst
);

// fetch stage sigs
  logic        stall_f    ;
  logic        pcsrc_e    ;
  logic        stall_d    ;
  logic        flush_d    ;
  logic [31:0] pc_target_e;
  logic [31:0] instr_d    ;
  logic [31:0] pc_d       ;
  logic [31:0] pc_plus4_d ;

//decode stage sigs
  logic reg_write_w_out;
  logic        flush_e      ;
  logic [ 4:0] rd_w         ;
  logic [31:0] pc_e         ;
  logic [31:0] pc_plus4_e   ;
  logic        jump_e       ;
  logic        branch_e     ;
  logic [ 1:0] result_src_e ;
  logic        mem_write_e  ;
  logic        alu_src_e    ;
  logic        reg_write_e  ;
  logic [ 2:0] alu_control_e;
  logic [ 4:0] rs1_e        ;
  logic [ 4:0] rs2_e        ;
  logic [31:0] rd1_e        ;
  logic [31:0] rd2_e        ;
  logic [ 4:0] rd_e         ;
  logic [31:0] imm_ext_e    ;

// write back stage sigs
 logic [31:0] read_data_w ;
  logic [31:0] alu_result_w;
  logic [31:0] pc_plus4_w  ;
  logic [ 1:0] result_src_w;

  //hazard unit sigs 
  logic [4:0] rs1_d;
  logic [4:0] rs2_d;

  decode_stage i_decode_stage (
    .clk          (clk            ),
    .srst         (srst           ),
    .flush_e      (flush_e        ),
    .instr_d      (instr_d        ),
    .pc_d         (pc_d           ),
    .pc_plus4_d   (pc_plus4_d     ),
    .reg_write_w  (reg_write_w_out),
    .rd_w         (rd_w           ),
    .result_w     (result_w   )   ,
    .pc_e         (pc_e           ),
    .pc_plus4_e   (pc_plus4_e     ),
    .jump_e       (jump_e         ),
    .branch_e     (branch_e       ),
    .result_src_e (result_src_e   ),
    .mem_write_e  (mem_write_e    ),
    .alu_src_e    (alu_src_e      ),
    .reg_write_e  (reg_write_e    ),
    .alu_control_e(alu_control_e  ),
    .rs1_e        (rs1_e          ),
    .rs2_e        (rs2_e          ),
    .rd1_e        (rd1_e          ),
    .rd2_e        (rd2_e          ),
    .rd_e         (rd_e           ),
    .imm_ext_e    (imm_ext_e      )
  );


  logic [31:0] alu_result_m;
  logic [1:0] forwardAE;
  logic [1:0] forwardBE;
  logic res_src_e;
  logic pc_src_e;
  logic [31:0] pc_plus4_m;
  logic [4:0] rd_m;
  logic [31:0] write_data_m;
  logic [1:0] result_src_m;
  logic mem_write_m;
  logic reg_write_m;
execute_stage i_execute_stage (
  .clk          (clk          ),
  .srst         (srst         ),
  .pc_e         (pc_e         ),
  .pc_plus4_e   (pc_plus4_e   ),
  .rs1_e        (rs1_e        ),
  .rs2_e        (rs2_e        ),
  .rd1_e        (rd1_e        ),
  .rd2_e        (rd2_e        ),
  .rd_e         (rd_e         ),
  .imm_ext_e    (imm_ext_e    ),
  .result_w     (result_w ),
  .alu_result_m (alu_result_m ),
  .reg_write_e  (reg_write_e  ),
  .result_src_e (result_src_e ),
  .mem_write_e  (mem_write_e  ),
  .jump_e       (jump_e       ),
  .branch_e     (branch_e     ),
  .alu_control_e(alu_control_e),
  .alu_src_e    (alu_src_e    ),
  .forwardAE    (forwardAE    ),
  .forwardBE    (forwardBE    ),
  .res_src_e    (res_src_e    ),
  .pc_src_e     (pc_src_e     ),
  .pc_target_e  (pc_target_e  ),
  .pc_plus4_m   (pc_plus4_m   ),
  .rd_m         (rd_m         ),
  .write_data_m (write_data_m ),
  .result_src_m (result_src_m ),
  .mem_write_m  (mem_write_m  ),
  .reg_write_m  (reg_write_m  )
);


 
  memory_stage i_memory_stage (
    .clk         (clk         ),
    .srst        (srst        ),
    .rd_m        (rd_m        ),
    .alu_result_m(alu_result_m),
    .write_data_m(write_data_m),
    .pc_plus4_m  (pc_plus4_m  ),
    .result_src_m(result_src_m),
    .mem_write_m (mem_write_m ),
    .rd_w        (rd_w        ),
    .read_data_w (read_data_w ),
    .alu_result_w(alu_result_w),
    .pc_plus4_w  (pc_plus4_w  ),
    .reg_write_w (reg_write_w ),
    .result_src_w(result_src_w)
  );


  
  write_back_stage i_write_back_stage (
    .clk            (clk            ),
    .srst           (srst           ),
    .reg_write_w    (reg_write_w    ),
    .rd_w           (rd_w           ),
    .read_data_w    (read_data_w    ),
    .alu_result_w   (alu_result_w   ),
    .pc_plus4_w     (pc_plus4_w     ),
    .reg_write_w_out(reg_write_w_out),
    .result_w       (result_w       )
  );


 
  hazard_unit i_hazard_unit (
    .rs1_d       (rs1_d       ),
    .rs2_d       (rs2_d       ),
    .rs1_e       (rs1_e       ), // TODO: Check connection ! Signal/port not matching : Expecting logic [4:0]  -- Found logic [31:0]
    .rs2_e       (rs2_e       ), // TODO: Check connection ! Signal/port not matching : Expecting logic [4:0]  -- Found logic [31:0]
    .rd_e        (rd_e        ),
    .pcsrc_e     (pcsrc_e     ),
    .result_src_e(result_src_e),
    .rd_m        (rd_m        ),
    .reg_write_m (reg_write_m ),
    .reg_write_w (reg_write_w ),
    .rd_w        (rd_w        ),
    .stall_f     (stall_f     ),
    .stall_d     (stall_d     ),
    .flush_d     (flush_d     ),
    .flush_e     (flush_e     ),
    .forwardAE   (forwardAE   ),
    .forwardBE   (forwardBE   )
  );




endmodule