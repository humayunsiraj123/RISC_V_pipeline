module risc_v_pipeline_core (
  input clk , // Clock
  input srst
);

  typedef enum logic[6:0] {
    LW     = 7'b0000011,
    SW     = 7'b0100011,
    BEQ    = 7'b1100011,
    I_TYPE = 7'b0010011,//itype instruction
    R_TYPE = 7'b0110011,
    JAL    = 7'b1101111} instr_e;
  instr_e instr_name;
  instr_e instr_type;



  logic        stall_f     = 1;
  logic        pcsrc_e     = 0;
  logic        stall_d     = 1;
  logic        flush_d     = 0;
  logic [31:0] pc_target_e = 0;
  logic [31:0] instr_d     = 0;
  logic [31:0] pc_d        = 0;
  logic [31:0] pc_plus4_d  = 0;

  fetch_stage i_fetch_stage (
    .clk        (clk        ),
    .srst       (srst       ),
    .stall_f    (stall_f    ),
    .pcsrc_e    (pcsrc_e    ),
    .stall_d    (stall_d    ),
    .flush_d    (flush_d    ),
    .pc_target_e(pc_target_e),
    .instr_d    (instr_d    ),
    .pc_d       (pc_d       ),
    .pc_plus4_d (pc_plus4_d )
  );


  logic        flush_e       = 0;
  logic        reg_write_w   = 0;
  logic [ 4:0] rd_w          = 0;
  logic [31:0] result_w      = 0;
  logic [31:0] pc_e          = 0;
  logic [31:0] pc_plus4_e    = 0;
  logic        jump_e        = 0;
  logic        branch_e      = 0;
  logic [ 1:0] result_src_e  = 0;
  logic        mem_write_e   = 0;
  logic        alu_src_e     = 0;
  logic        reg_write_e   = 0;
  logic [ 2:0] alu_control_e = 0;
  logic [ 4:0] rs1_e         = 0;
  logic [ 4:0] rs2_e         = 0;
  logic [31:0] rd1_e         = 0;
  logic [31:0] rd2_e         = 0;
  logic [ 4:0] rd_e          = 0;
  logic [31:0] imm_ext_e     = 0;
  logic [ 4:0] rs1_d         = 0;
  logic [ 4:0] rs2_d         = 0;
  decode_stage i_decode_stage (
    .clk          (clk          ),
    .srst         (srst         ),
    .flush_e      (flush_e      ),
    .instr_d      (instr_d      ),
    .pc_d         (pc_d         ),
    .pc_plus4_d   (pc_plus4_d   ),
    .reg_write_w  (reg_write_w  ),
    .rd_w         (rd_w         ),
    .result_w     (result_w     ),
    .pc_e         (pc_e         ),
    .pc_plus4_e   (pc_plus4_e   ),
    .jump_e       (jump_e       ),
    .branch_e     (branch_e     ),
    .result_src_e (result_src_e ),
    .mem_write_e  (mem_write_e  ),
    .alu_src_e    (alu_src_e    ),
    .reg_write_e  (reg_write_e  ),
    .alu_control_e(alu_control_e),
    .rs1_e        (rs1_e        ),
    .rs2_e        (rs2_e        ),
    .rs1_d        (rs1_d        ),
    .rs2_d        (rs2_d        ),
    .rd1_e        (rd1_e        ),
    .rd2_e        (rd2_e        ),
    .rd_e         (rd_e         ),
    .imm_ext_e    (imm_ext_e    )
  );


  logic [ 1:0] forwardAE    = 0;
  logic [ 1:0] forwardBE    = 0;
  logic        res_src_e    = 0;
  logic        pc_src_e     = 0;
  logic [31:0] pc_plus4_m   = 0;
  logic [ 4:0] rd_m         = 0;
  logic [31:0] alu_result_m = 0;
  logic [31:0] write_data_m = 0;
  logic [ 1:0] result_src_m = 0;
  logic        mem_write_m  = 0;
  logic        reg_write_m  = 0;
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
    .result_w     (result_w     ),
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
    .pc_src_e     (pcsrc_e      ),
    .pc_target_e  (pc_target_e  ),
    .pc_plus4_m   (pc_plus4_m   ),
    .rd_m         (rd_m         ),
    .alu_result_m (alu_result_m ),
    .write_data_m (write_data_m ),
    .result_src_m (result_src_m ),
    .mem_write_m  (mem_write_m  ),
    .reg_write_m  (reg_write_m  )
  );

  logic [31:0] read_data_w  = 0;
  logic [31:0] alu_result_w = 0;
  logic [31:0] pc_plus4_w   = 0;
  logic [ 1:0] result_src_w = 0;
  memory_stage i_memory_stage (
    .clk         (clk         ),
    .srst        (srst        ),
    .rd_m        (rd_m        ),
    .alu_result_m(alu_result_m),
    .write_data_m(write_data_m),
    .pc_plus4_m  (pc_plus4_m  ),
    .reg_write_m (reg_write_m ),
    .result_src_m(result_src_m),
    .mem_write_m (mem_write_m ),
    .rd_w        (rd_w        ),
    .read_data_w (read_data_w ),
    .alu_result_w(alu_result_w),
    .pc_plus4_w  (pc_plus4_w  ),
    .reg_write_w (reg_write_w ),
    .result_src_w(result_src_w)
  );


  logic reg_write_w_out;
  write_back_stage i_write_back_stage (
    .clk            (clk            ),
    .srst           (srst           ),
    .reg_write_w    (reg_write_w    ),
    .result_src_w   (result_src_w   ), // TODO: Check connection ! Signal/port not matching : Expecting logic  -- Found logic [1:0]
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
    .rs1_e       (rs1_e       ),
    .rs2_e       (rs2_e       ),
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



  // always_comb begin : proc_
  //   $cast(instr_type,instr_d[6:0]);
  // end



endmodule