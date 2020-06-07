module mycpu_top(
input clk,
input resetn,
input [5:0]int,
output inst_sram_en,
output[3:0] inst_sram_wen,
output[31:0] inst_sram_addr,
output[31:0] inst_sram_wdata,
input[31:0]  inst_sram_rdata,

output data_sram_en,
output[3:0] data_sram_wen,
output[31:0] data_sram_addr,
output[31:0] data_sram_wdata,
input[31:0]  data_sram_rdata,

output[31:0] debug_wb_pc,
output[3:0] debug_wb_rf_wen,
output[4:0] debug_wb_rf_wnum,
output[31:0] debug_wb_rf_wdata);

wire wb_flush, wb_stall, except;

wire id_pc_change, exe_pc_change, mem_pc_change, pc_change;

wire if_write;
wire [31:0] id_pc, id_inst, if_pc; // TODO
wire [1:0] pc_select;
IF If(clk,if_write, resetn, wb_flush | (pc_select !=2'b00),inst_sram_rdata,id_inst,if_pc,id_pc);

assign inst_sram_wdata = 0;


wire exe_rf_wen, wb_rf_wen, id_reg_wen/*, mem_rf_wen*/;
wire [4:0] exe_rf_wnum,  wb_rf_wnum/*, mem_rf_wnum*/,id_reg_num, wb_cp0_wnum;
wire [2:0] wb_cp0_sel;
wire [1:0]busA_select, busB_select;
wire [31:0] exe_rf_data, mem_rf_data, wb_rf_data;
wire wb_cp0_wen;
wire [31:0] wb_cp0_epc, wb_cp0_cause, wb_cp0_state, wb_cp0_badAdddress;

wire exe_be_nop;
wire to_exe;

detect  hazad_detect(id_inst[25:21], id_inst[20:16], id_reg_wen&!exe_be_nop, id_reg_num, exe_rf_wen, exe_rf_wnum, wb_rf_wen, wb_rf_wnum, busA_select, busB_select);


wire id_write;
wire id_bad_inst, id_epc_inst, id_mem_to_reg, id_aluAselect, id_pc8,  id_cp0_wen;
wire [1:0] id_jump_inst, id_bc_inst, id_aluBselect;
wire [2:0] id_cp0_sel;
wire [3:0] id_mem_wen;
wire [3:0] id_mem_ren;
wire [4:0] id_rd, id_aluop, id_shamt;
wire [31:0] id_immU, id_immS, id_busA, id_busB, id_cp0_bus;
wire [25:0] id_index;
wire [31:0] exe_pc, pc_epc;
ID Id(clk, id_write, resetn, wb_flush,
  id_pc, id_inst,
  busA_select, busB_select,
 exe_rf_data,
 mem_rf_data,
 wb_rf_data,
 except,
wb_cp0_state,
wb_cp0_cause,
wb_cp0_badAdddress,
wb_cp0_epc,
wb_rf_wen,
wb_rf_wnum,
wb_cp0_wen,
wb_cp0_sel,
wb_cp0_wnum,
exe_pc,
id_bad_inst,
id_epc_inst,
id_mem_to_reg,
id_jump_inst,
id_bc_inst,
id_rd,
id_cp0_sel,
id_reg_num,
id_immU,
id_immS,
id_busA,
id_busB,
id_cp0_bus,
id_index,
id_aluop,
id_shamt,
id_aluAselect,
id_aluBselect,
id_pc8,
id_reg_wen,
id_cp0_wen,
id_mem_wen,
id_mem_ren,
pc_epc,
id_pc_change
  );
wire exe_write, exe_stall, exe_reg_wen, exe_cp0_wen, exe_overflow, exe_Int, exe_bad_inst;
wire exe_mem_to_reg;
wire [2:0] exe_cp0_sel;
wire[1:0] exe_bc_inst;
wire [3:0] exe_mem_ren, exe_mem_wen;
wire[4:0] exe_reg_num , exe_cp0_num;
wire[31:0] pc_branch, pc_jump;
wire[31:0] exe_mem_data, exe_busB, mem_pc;

wire[31:0] data_address_read; //TODO

  EXE exe( clk, exe_write, resetn, wb_flush,to_exe,
    exe_pc,
    id_aluop,
    id_shamt,
    id_immS,
    id_immU,
    id_busA,
    id_busB,
    id_cp0_bus,
    id_index,
    id_aluAselect,
    id_aluBselect,
    id_pc8,
    id_jump_inst,
    id_bc_inst,
    id_bad_inst,
    id_epc_inst,
    id_reg_wen,
    id_reg_num,
    id_cp0_wen,
	id_rd,
    id_cp0_sel,
    id_mem_ren,
    id_mem_wen,
    id_mem_to_reg,
	id_pc_change,
    mem_pc,
    pc_select,
    pc_branch,
    pc_jump,
    exe_stall,
    exe_reg_wen,
    exe_reg_num,
    exe_cp0_wen,
    exe_cp0_num,
    exe_cp0_sel,
    exe_busB,
    exe_rf_data,
    exe_mem_data,
    exe_mem_ren,
    exe_mem_wen,
    exe_mem_to_reg,
    exe_overflow,
    exe_Int,
    exe_bad_inst,
    exe_bc_inst,
    data_address_read,
	exe_pc_change,
  exe_be_nop
    );



    assign exe_rf_wnum = exe_reg_num;
    assign exe_rf_wen = exe_reg_wen;

    wire mem_write, mem_stall;
    wire mem_reg_wen,mem_cp0_wen, mem_sram_ren;
    wire [2:0] mem_cp0_sel;
    wire [3:0] mem_sram_wen;
    wire[4:0] mem_reg_num, mem_cp0_num;
    wire [31:0] mem_sram_address, mem_sram_data,mem_badAddress, wb_pc;
    wire[1:0] mem_bc_inst;
    //wire hit;
    wire mem_overflow, mem_Int, mem_bad_inst,addressError_read, addressError_write;
    MEM mem(clk, mem_write, resetn, wb_flush,
      mem_pc,
      exe_mem_data,
      exe_busB,
      data_sram_rdata,
      exe_mem_ren,
      exe_mem_wen,
      exe_mem_to_reg,
      exe_overflow,
      exe_Int,
      exe_bad_inst,
      exe_bc_inst,
      exe_reg_wen,
      exe_reg_num,
      exe_cp0_wen,
      exe_cp0_num,
      exe_cp0_sel,
	  exe_pc_change,
      wb_pc,
      mem_reg_wen,
      mem_reg_num,
      mem_cp0_wen,
      mem_cp0_num,
      mem_cp0_sel,
      mem_sram_address,
      mem_sram_wen,
      mem_sram_data,
      mem_rf_data,
      wb_rf_data,
      mem_overflow,
      mem_Int,
      mem_bad_inst,
      mem_bc_inst,
      to_exe,
      addressError_read,
      addressError_write,
      mem_badAddress,
      mem_stall,
	  pc_change
      );

  assign     wb_rf_wen = mem_reg_wen;
  assign     wb_rf_wnum  =  mem_reg_num;
  assign     wb_cp0_wnum = mem_cp0_num;
  assign     wb_cp0_wen = mem_cp0_wen;
  assign     wb_cp0_sel = mem_cp0_sel;
ExceptionHandler exp(clk, pc_change, 
  mem_overflow,
  mem_bad_inst,
   addressError_write,
   addressError_read,
   mem_badAddress,
   wb_pc,
  mem_Int,
  inst_sram_addr,
  mem_bc_inst,
  except,
  wb_cp0_badAdddress,
  wb_cp0_epc,
  wb_cp0_cause,
  wb_cp0_state);

  wire pc_write;
  wire [31:0] pc4;
  assign pc4 = if_pc + 4;

  assign inst_sram_addr = if_pc;
  PC pc(clk, pc_write, resetn, pc_jump, pc4, pc_branch, pc_epc, except, pc_select, if_pc);

  assign debug_wb_pc = wb_pc;
  assign debug_wb_rf_wen = {4{wb_rf_wen}};
  assign debug_wb_rf_wnum = wb_rf_wnum;
  assign debug_wb_rf_wdata = wb_rf_data;

  assign wb_flush = except;

  assign if_write = !mem_stall & !exe_stall;
  assign id_write  = !mem_stall & !exe_stall;
  assign exe_write = !mem_stall;
  assign mem_write =  1'b1;
  assign pc_write = !mem_stall & !exe_stall;
  assign inst_sram_en =  !mem_stall & !exe_stall & resetn;
  assign inst_sram_wen = 0;
  assign data_sram_en = 1'b1;
  assign data_sram_wdata = mem_sram_data;
  assign data_sram_wen = mem_sram_wen;
  assign data_sram_addr = mem_sram_address - 32'ha0000000;


  endmodule
