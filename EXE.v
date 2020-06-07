module EXE(input clk, input write, input rst, input flush,input addresserror,
  input [31:0]  pc,
  input [4:0] aluop,
  input [4:0] shamt,
  input [31:0] immS,
  input [31:0] immU,
  input [31:0] busA,
  input [31:0] busB,
  input [31:0] cp0_bus,
  input [25:0] index,
  input aluAselect,
  input [1:0] aluBselect,
  input pc8,
  input [1:0] jump_inst,
  input [1:0] bc_inst,
  input bad_inst,
  input epc_inst,
  input reg_wen,
  input [4:0]reg_num,
  input cp0_wen,
  input [4:0] cp0_num,
  input [2:0] cp0_sel,
  input [3:0] memReadEn,
  input [3:0] memWriteEn,
  input mem_to_reg,
  input pc_change,

  output reg[31:0] pc_out,
  output reg [1:0]pc_select,
  output [31:0]pc_branch,
  output [31:0] pc_jump,
  output stall_out,

output reg reg_wen_out,
output reg[4:0] reg_num_out,
output reg cp0_wen_out,
output reg[4:0] cp0_num_out,
output reg [2:0] cp0_sel_out,

  output reg [31:0] busB_out,
  output [31:0] exe_data,
  output reg [31:0] exe_data_out,
  output reg [3:0] memReadEn_out,
  output reg [3:0] memWriteEn_out,
  output reg mem_to_reg_out,
  output reg overflow_out,
  output reg Int_out,
  output reg bad_inst_out,
  output reg [1:0] bc_inst_out,

  output [31:0] data_address,
  output reg pc_change_out,

  output be_nop_out

  //input hit,
  //output reg hit_out
  );



  reg disable_block;

  reg hazad_after_load;
  reg be_nop;

  assign be_nop_out = be_nop;


wire [31:0]aluA,aluB, alu_out, alu_value;
wire branch,overflow,stall, Int;

select2 select_aluA(aluAselect, busA, cp0_bus, aluA);
select4 select_aluB(aluBselect, busB, immS, immU, {immU[15:0], 16'h0000}, aluB);

assign stall_out =  (stall | {hazad_after_load,(memReadEn& {4{!be_nop}} != 2'b00)} == 2'b01) & !flush;
assign alu_value = pc8 ? pc +8 : alu_out;
assign exe_data = alu_value;

assign pc_jump = jump_inst[0] ?  {pc[31:28], index ,2'b00} : busA;
assign pc_branch = pc + {immS[29:0], 2'b00} + 4;

assign data_address = alu_out & {32{memReadEn != 4'b0000}};   // TODO

always@(*) begin
case({jump_inst[1],branch,epc_inst})
3'b100 : pc_select = 2'b10;
3'b110:  pc_select = 2'b10;
3'b111:  pc_select = 2'b11;
3'b011 : pc_select = 2'b01;
3'b010 : pc_select = 2'b01;
3'b001 : pc_select = 2'b11;
default : pc_select = 2'b00;
endcase
end


ALU2  alu(aluop&{5{!disable_block & !addresserror & !bad_inst}},aluA,aluB,clk,shamt,alu_out,branch,overflow,stall);

assign Int = (pc_branch == pc)&branch | (pc_jump == pc)&jump_inst[1];

always @ ( posedge clk) begin
if(write) begin
busB_out <= busB;
exe_data_out <= alu_value;
memReadEn_out <= memReadEn& {4{!be_nop & !flush}};
memWriteEn_out <= memWriteEn & {4{!flush & !overflow & !be_nop}};
overflow_out <= overflow;
Int_out <= Int;
bad_inst_out <=  bad_inst;
bc_inst_out <=  bc_inst;
reg_wen_out <=  reg_wen & !flush & !overflow & !be_nop;
reg_num_out <= reg_num & {5{!be_nop}};
cp0_wen_out <=  cp0_wen & !flush & !overflow & !be_nop;
cp0_sel_out <= cp0_sel;
cp0_num_out <=  cp0_num;
pc_out <= pc&{32{!be_nop}};
mem_to_reg_out <= mem_to_reg& !be_nop;
pc_change_out <=  pc_change& !be_nop;
hazad_after_load <= (memReadEn& {4{!be_nop}} != 4'b0000);
be_nop <= {hazad_after_load,(memReadEn& {4{!be_nop}} != 4'b0000)} == 2'b01;

disable_block <= (Int |  bad_inst | bc_inst[1] | overflow| addresserror ) | disable_block& !flush;
///hit_out <= !hit;
end

if(!rst | stall ) begin
busB_out <= 0;
exe_data_out <= 0;
memReadEn_out <= 0;
memWriteEn_out <=0;
overflow_out <= 0;
Int_out <= 0;
bad_inst_out <=  0;
bc_inst_out <=  0;
pc_out <= 0;
mem_to_reg_out <= 0;
pc_change_out <=  pc_change;
be_nop <= 0;
disable_block <= 0;
//hit_out <= 1'b0;
end

end

endmodule //EXE
