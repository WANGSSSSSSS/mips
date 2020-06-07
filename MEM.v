module memRselect(select,memType,outputData, inputd, outputd, addressError);
input[3:0] select;
input[1:0] memType;
input[31:0] inputd;
output reg [3:0] outputData;
output  reg[31:0] outputd;
output reg addressError;
always@(*) begin
case(select)
4'b0001 : begin
                   case(memType)
                   2'b11 :  begin outputData = 4'b1000;  outputd = {inputd[7:0], 24'b0}; end
                   2'b01 :  begin outputData = 4'b0010;  outputd = {16'b0, inputd[7:0], 8'b0}; end
                   2'b10 :  begin outputData = 4'b0100;  outputd = {8'b0,inputd[7:0], 16'b0}; end
                   2'b00 :  begin outputData = 4'b0001;  outputd = {24'b0,inputd[7:0]};  end
                   default : outputData = 4'b0000;

                   endcase
                   addressError = 1'b0;
                   end
4'b0011 : begin
                   case(memType[1])
                  1'b0 :  begin outputData = 4'b0011;  outputd = {16'b0, inputd}; end
                  1'b1 :  begin outputData = 4'b1100;  outputd = {inputd, 16'b0};end
                  default : outputData = 4'b0000;
                   endcase
                   addressError = memType[0];
                   end
4'b1111 : begin outputData = 4'b1111;outputd = inputd;  addressError = (memType != 2'b00); end
default : begin outputData = 4'b0000; addressError = 1'b0; end
endcase
end

endmodule

module memSelect(select,memType,inputData, outputData, addressError);
input[3:0] select;
input[1:0] memType;
input [31:0] inputData;
output reg [31:0] outputData;
output  reg addressError;

initial begin
  addressError  = 1'b0;
end


always @ (* ) begin
case(select)
4'b0001: begin
                  case(memType)
                  2'b00:outputData = {24'b0,inputData[7:0]};
                  2'b01:outputData = {24'b0,inputData[15:8]};
                  2'b10:outputData = {24'b0,inputData[23:16]};
                  2'b11: outputData = {24'b0,inputData[31:24]};
                  endcase
                  addressError = 1'b0;
                  end
4'b0011: begin
                  case(memType[1])
                  1'b0:outputData = {16'b0,inputData[15:0]};
                  1'b1: outputData = {16'b0,inputData[31:16]};
                  endcase
                  addressError = memType[0];
                  end
4'b1001: begin
                  case(memType)
                  2'b00:outputData = {{24{inputData[7]}},inputData[7:0]};
                  2'b01:outputData = {{24{inputData[15]}},inputData[15:8]};
                  2'b10:outputData = {{24{inputData[23]}},inputData[23:16]};
                  2'b11: outputData = {{24{inputData[31]}},inputData[31:24]};
                  endcase
                  addressError = 1'b0;
                  end
4'b1011: begin
                  case(memType[1])
                  1'b0:outputData = {{16{inputData[15]}},inputData[15:0]};
                  1'b1:outputData = {{16{inputData[31]}},inputData[31:16]};
                  endcase
                  addressError = memType[0];
                  end
4'b1111: begin outputData = inputData;   addressError = (memType != 2'b00) ;end
default:  begin outputData = 32'h00000000;  addressError = 1'b0; end
endcase
end
endmodule



module MEM(input clk, input write,input rst, input flush,//input hit
  input [31:0] pc,
  input [31:0] address,
  input [31:0] exe_data,
  input [31:0] sram_data_read,
  input [3:0] memReadEn,
  input [3:0] memWriteEn,

  input mem_to_reg,

  input overflow,
  input Int,
  input bad_inst,
  input [1:0] bc_inst,
  input reg_wen,
  input [4:0]reg_num,
  input cp0_wen,
  input [4:0] cp0_num,
  input [2:0] cp0_sel,
  input pc_change,


  output reg[31:0] pc_out,
  output reg reg_wen_out,
  output reg[4:0] reg_num_out,
  output reg cp0_wen_out,
  output reg[4:0] cp0_num_out,
  output reg [2:0] cp0_sel_out,

  output [31:0] sram_address,
  output [3:0] sram_wen,
  output [31:0] sram_data_write,
  //output sram_ren,
  output [31:0]mem_data,
  output reg[31:0]wb_data_out,


  output reg overflow_out,
  output reg Int_out,
  output reg bad_inst_out,
  output reg [1:0] bc_inst_out,
  output reg addressError_read,
  output reg addressError_write,
  output reg [31:0]badAddress,

  output stall_out ,//TODO
  output reg pc_change_out

   );

    wire addressErrorIn, addressErrorOut;
    wire [31:0] mem_data_, mem_value, sram_data_write_;
    wire [3:0] sram_wen_;
    //reg HIT;

    //assign stall_out = HIT &  (memReadEn != 2'b00);

    reg to_stall;

    memSelect memselect(memReadEn, address[1:0], sram_data_read, mem_data_, addressErrorIn);
    memRselect memrselect(memWriteEn, address[1:0],sram_wen_,exe_data,sram_data_write_, addressErrorOut);

    assign mem_value = mem_to_reg ? mem_data_ : exe_data;
    assign mem_data = mem_value;
    assign sram_data_write = sram_data_write_;
    assign sram_address  = (address) & {32{!addressErrorIn & !addressErrorOut}};
    assign sram_wen = sram_wen_ &  {4{!addressErrorOut & !flush}};

    assign stall_out = ({to_stall,memReadEn!=1'b0} == 2'b01) & !addressErrorIn;

    always @ ( posedge clk ) begin

    if(write) begin
    overflow_out <= overflow;
    Int_out <= Int_out;
    bad_inst_out <=  bad_inst;
    bc_inst_out <=  bc_inst;
    addressError_read <=  addressErrorIn;
    addressError_write <=  addressErrorOut;
    wb_data_out <= mem_data;
    reg_wen_out <=  reg_wen & !flush;
    reg_num_out <= reg_num;
    cp0_wen_out <=  cp0_wen & !flush;
    cp0_sel_out <= cp0_sel;
    cp0_num_out <=  cp0_num;
    badAddress <= address;
    pc_out <= pc;
    //HIT <= hit;
    to_stall <= (memReadEn !=0);
	pc_change_out <=  pc_change;
    end

    if(!rst | stall_out) begin
    overflow_out <= 0;
    Int_out <= 0;
    bad_inst_out <=  0;
    bc_inst_out <=  0;
    addressError_read <=  0;
    addressError_write <=  0;
    wb_data_out <= 0;
    reg_wen_out <=  0 ;
    reg_num_out <= 0;
    cp0_wen_out <=  0;
    cp0_sel_out <= 0;
    cp0_num_out <=  0;
    badAddress <= 0;
    pc_out <= pc;
    to_stall <= 1'b0;
	pc_change_out <= 1'b0;
    end
    end

   endmodule
