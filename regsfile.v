module RegisterFile(CLK,Write,RST,regA,regB,regWrite,datain,busA,busB);
input[4:0] regA,regB,regWrite;
input CLK,RST;
input [3:0]Write;
input [31:0] datain;
output reg[31:0] busA,busB;
reg [31:0]regs[0:31];


always@(*)
begin
busA = regs[regA];
busB = regs[regB];
end

always@(posedge CLK) begin
if(Write)
begin
regs[regWrite][31:24] <= datain[31:24] ;
regs[regWrite][23:16] <= datain[23:16] ;
regs[regWrite][15:8]  <=datain[15:8] ;
regs[regWrite][7:0]  <= datain[7:0];
end
if(!RST)
begin
regs[0] = 0;regs[1] = 0;regs[2] = 0;regs[3] = 0;
regs[4] = 0;regs[5] = 0;regs[6] = 0;regs[7] = 0;
regs[8] = 0;regs[9] = 0;regs[10] = 0;regs[11] = 0;
regs[12] = 0;regs[13] = 0;regs[14] = 0;regs[15] = 0;
regs[16] = 0;regs[17] = 0;regs[18] = 0;regs[19] = 0;
regs[20] = 0;regs[21] = 0;regs[22] = 0;regs[23] = 0;
regs[31] = 0;regs[24] = 0;regs[25] = 0;regs[26] = 0;
regs[27] = 0; regs[28] =0; regs[29]=  0; regs[30] = 0;
end

end
endmodule


module CP0(CLK,Write,RST,except,pc,cause,state,badAddress,rd,wb_rd,sel,Epc,dataout,datain);
input[31:0] pc,cause,state,badAddress,datain;
input[4:0] rd, wb_rd;
input[2:0] sel;
input CLK,Write,except,RST;

output reg[31:0] dataout;
output[31:0] Epc;

reg[31:0] regs[0:31];

assign Epc = regs[14];

always@(*)  begin
dataout = regs[rd];
end

always@(posedge CLK)   begin

if(except)
begin
regs[8] <= badAddress;
regs[12] <= state;
regs[13] <= cause;
regs[14] <= pc;
end

if(Write)
begin
regs[wb_rd] <= datain;
end

/*
case({Write,except})
2'b11 :  begin regs[8] <= badAddress;
               regs[12] <= state;
               regs[13] <= cause;
               regs[14] <= pc;  end
2'b01 :  begin regs[8] <= badAddress;
                              regs[12] <= state;
                              regs[13] <= cause;
                              regs[14] <= pc;  end
2'b10 :  begin regs[wb_rd] <= datain; end
endcase*/

if(!RST)  begin
regs[0] = 0;regs[1] = 0;regs[2] = 0;regs[3] = 0;
regs[4] = 0;regs[5] = 0;regs[6] = 0;regs[7] = 0;
regs[8] = 0;regs[9] = 0;regs[10] = 0;regs[11] = 0;
regs[12] = 0;regs[13] = 0;regs[14] = 0;regs[15] = 0;
regs[16] = 0;regs[17] = 0;regs[18] = 0;regs[19] = 0;
regs[20] = 0;regs[21] = 0;regs[22] = 0;regs[23] = 0;
regs[31] = 0;regs[24] = 0;regs[25] = 0;regs[26] = 0;
regs[27] = 0; regs[28] =0; regs[29]=  0; regs[30] = 0;
end
end

endmodule
