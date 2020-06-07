module ID(
  input clk,  input write, input rst,input flush,
  input [31:0]pc, input [31:0] inst,
  input [1:0] busB_select, input [1:0] busA_select,
  input [31:0] exe_data,
  input [31:0] mem_data,
  input [31:0] wb_data,
  input except,
  input [31:0] wb_cp0_state,
  input [31:0] wb_cp0_cause,
  input [31:0] wb_cp0_badAdddress,
  input [31:0] wb_cp0_epc,
  input wb_rf_wen,
  input [4:0] wb_rf_wnum,
  input wb_cp0_wen,
  input [2:0] wb_cp0_sel,
  input [4:0] wb_cp0_wnum,
  output reg [31:0] pc_out;
  output reg bad_inst,
  output reg epc_inst,
  output reg mem_to_reg,
  output reg [1:0] jump_inst,
  output reg [1:0] bc_inst,
  output reg[4:0] rd_out,
  output reg[4:0] reg_num_out,
  output reg[31:0] immU_out,
  output reg[31:0] immS_out,
  output reg[31:0] busA_out,
  output reg[31:0] busB_out,
  output reg[31:0] cp0_bus_out,
  output reg[25:0]  index_out,
  output reg [4:0] aluop_out,
  output reg[4:0] shamt_out,
  output reg  aluAselect_out,
  output reg [1:0] aluBselect_out,
  output reg pc8_out,
  output reg  regWrite_out,
  output reg cp0Write_out,
  output reg [3:0] mem_wen_out,
  output reg [3:0] mem_ren_out,
  output reg[31:0]epc_out
   )

   wire [2:0] sel;
   wire [4:0] rs, rd, rt;
   wire [15:0] imm;
   wire [25:0] index;
   wire [4:0] shamt;
   wire [31:0] busA, busB, epc, cp0_bus, final_busA, final_busB;

 assign rs = inst[15:21];
 assign rt = inst[20:16];
 assign rd = inst[15:11];
 assign imm = inst[15:0];
 assign  sel = inst[2:0];
 assign index = inst[25:0];
 assign shamt = inst[10:6];

wire [31:0] extend_immS, extend_immU;
assign extend_immS = {{16{imm[15]}},imm[15:0]};
assign extend_immU = {16'h0000,imm};

select4 sel_busA(busA_select, busA, exe_data, mem_data, wb_data, final_busA);
select4 sel_busB(busB_select, busB, exe_data, mem_data, wb_data, final_busB);


RegisterFile  rf(clk, wb_rf_wen&!except, rst, rs, rt, wb_rf_wnum, wb_data, busA, busB);

CP0 cp0(clk,  wb_cp0_wen, rst, except,
                  wb_cp0_epc,
                  wb_cp0_cause,
                  wb_cp0_state,
                  wb_cp0_badAdddress,
                  wb_cp0_wnum,
                  wb_cp0_sel,
                  epc,
                  cp0_bus,
                  wb_data
                  );

        wire[4:0]          aluop;
        wire                    pc8;
        wire [1:0]          aluBselect;
        wire                    regWrite;
        wire          Cp0Write;
        wire [3:0]          MemWrite;
        wire [1:0]          RegToWrite;
        wire          MemToReg;
        wire[1:0]          Jump;
        wire          epcInst;
        wire[1:0]          B_C;
        wire[3:0]          memReadEn;
        wire          aluAselect;
        wire       badInst;
  //wire stall;//TODO
  //assign stall = !write;
Control control(  clk,	inst,	aluop,	pc8,	aluBselect,		regWrite,		Cp0Write,
        				MemWrite,	RegToWrite,		MemToReg,		Jump,		epcInst,			B_C,			memReadEn,
        				aluAselect,		badInst
        				);
wire reg_num;
select4_5 select_reg(RegToWrite, rd, rt, 5'b11111, 5'b00000, reg_num);


always @ ( posedge clk) begin
if(write) begin
pc_out <= pc;
immU_out <= extend_immU;
immS_out <= extend_immS;
busA_out <= final_busA;
busB_out <= final_busB;
bad_inst <= badInst;
epc_inst <= epcInst;
mem_to_reg <= MemToReg;
jump_inst <= Jump & {2{!flush& !badInst}};
bc_inst <= B_C & {2{!flush& !badInst}};
rd_out <= rd;
shamt_out <= shamt;
reg_num_out <= reg_num;
aluop_out <= aluop;
aluAselect_out <= aluAselect;
aluBselect_out <= aluBselect;
pc8_out <= pc8;
regWrite_out <= regWrite& !flush & !badInst;
cp0Write_out <= Cp0Write & !flush & !badInst;
mem_ren_out <= memReadEn;
mem_wen_out <= MemWrite & {4{!flush& !badInst}};
epc_out <= epc;
cp0_bus_out <= cp0_bus;
index_out <= index;
end
if(!rst) begin
pc_out <= 0;
immU_out <=0;
immS_out <= 0;
busA_out <= 0;
busB_out <= 0;
bad_inst <=0;
epc_inst <= 0;
mem_to_reg <=0;
jump_inst <= 0;
bc_inst <= 0;
rd_out <= 0;
shamt_out <= 0;
reg_num_out <= 0;
aluop_out <= 0;
aluAselect_out <= 0;
aluBselect_out <= 0;
pc8_out <= pc8;
regWrite_out <= 0 ;
cp0Write_out <= 0;
mem_ren_out <= 0;
mem_wen_out <= 0;
epc_out <= 0;
cp0_bus_out <= 0;
index_out <= 0;
end
end

endmodule
