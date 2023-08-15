module fetch_stage (
  input               clk        ,
  input               srst       ,
  input               stall_f    ,
  input               pcsrc_e    ,
  input               stall_d    ,
  input               flush_d    ,
  input        [31:0] pc_target_e,
  output logic [31:0] instr_d    ,
  output logic [31:0] pc_d       ,
  output logic [31:0] pc_plus4_d
);


  logic [31:0] pc_in     ; //input to pc_reg
  logic [31:0] instr_f   ;
  logic [31:0] pc_f      ;
  logic [31:0] pc_plus4_f;

// mux to selection pc_in value
  mux_2to1 i_mux_2to1 (
    .in1(pc_plus4_f ), // plus 4 in previous pc value to jump om next instrc as word addressable mem anf each word of 4bytes
    .in2(pc_target_e), //form execution stage //branch and jal instr
    .s  (pcsrc_e    ), //to check if jal or branch
    .out(pc_in      )
  );

//pc_f + 4 ,pc_f adder
  always_comb begin : proc_pc_mux
    pc_plus4_f = pc_f + 4;
  end

  logic        enable ;
  logic [31:0] pc_next;

//pc reg
  pc_reg i_pc_reg (
    .clk    (clk    ),
    .srst   (srst   ),
    .enable (stall_f), //stall is active high else pc+4 and when stall it wont updated the pc value
    .pc_next(pc_in  ),
    .pc     (pc_f   )
  );
//instruction memory
  instr_mem i_instr_mem (
    .Addr(pc_f   ),
    .RD  (instr_f)
  );

// if_id register;

  always_ff @(posedge clk) begin : proc_fetch_reg
    if(srst||flush_d) begin
      pc_plus4_d <= 0;
      pc_d       <= 0;
      instr_d    <= 0;
    end else if(!stall_d) begin
      pc_plus4_d <= pc_plus4_f ;
      pc_d       <= pc_f ;
      instr_d    <= instr_f ;
    end
  end


endmodule