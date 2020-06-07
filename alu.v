module  ALU2(aluop,aluA,aluB,CLK,shamt,aluOUT,branch,overflow,stall);
input [4:0]aluop,shamt;
input signed [31:0] aluA,aluB;
input CLK;
output reg [31:0] aluOUT;
output reg branch,overflow;
output stall;

wire[31:0] hiOut,  loOut;

wire finish;
reg  start;

assign stall = start;
wire [31:0] negaluB;
assign negaluB = ~aluB +1;


initial begin
  branch = 1'b0;
  overflow = 1'b0;
  start = 1'b0;
end

reg _no;

mutiCycle  muticycle(CLK, start, aluop ,aluA, aluB, hiOut, loOut, finish);

always@(*)
begin
case(aluop)
5'b10000 : begin aluOUT = aluA+aluB;  overflow = (aluA[31]&aluB[31]&!aluOUT[31])|(!aluA[31]&!aluB[31]&aluOUT[31]);                             branch=0;  end
5'b10001 : begin {_no,aluOUT[31:0]} = {1'b0,aluA[31:0]}+{1'b0,aluB[31:0]}; branch=0;  overflow = 1'b0; end
5'b10010 : begin aluOUT = aluA+negaluB;   overflow = (aluA[31]&negaluB[31]&!aluOUT[31])|(!aluA[31]&!negaluB[31]&aluOUT[31]);                             branch=0;  end
5'b10011 : begin {_no,aluOUT} = {1'b0,aluA[31:0]} - {1'b0,aluB[31:0]};  overflow = 1'b0;/*overflow = $unsigned(aluA) < $unsigned(aluB);*/ branch=0; end
5'b10100 : begin aluOUT = aluA&aluB;         overflow = 1'b0;                      branch=0;  end
5'b10101 : begin aluOUT = aluA|aluB;           overflow = 1'b0;                        branch=0; end
5'b10110 : begin aluOUT = aluA^aluB;            overflow = 1'b0;                       branch=0;  end
5'b10111 : begin aluOUT = ~(aluA|aluB);         overflow = 1'b0;                       branch=0; end
5'b11010 : begin aluOUT = aluA < aluB;          overflow = 1'b0;                       branch=0;  end
5'b11011 : begin aluOUT = {1'b0,aluA[31:0]} < {1'b0, aluB[31:0]};   overflow = 1'b0;         branch=0; end
5'b11100 : begin aluOUT = aluB << (aluA[4:0] | shamt);      overflow = 1'b0;           branch=0; end
5'b11110 : begin aluOUT = aluB >> (aluA[4:0] | shamt);			 overflow = 1'b0;       branch=0; end
5'b11111 : begin aluOUT = aluB >>> (aluA[4:0] | shamt);			 overflow = 1'b0;       branch=0; end
5'b00001 : begin  aluOUT = aluA;                    overflow = 1'b0;                                  branch = (aluA == aluB); end
5'b00010 : begin  aluOUT = aluA;                    overflow = 1'b0;                                  branch = (aluA != aluB); end
5'b00011 : begin  aluOUT = aluA;                     overflow = 1'b0;                                branch = (aluA >= 0); end
5'b00100 : begin  aluOUT = aluA;                       overflow = 1'b0;                               branch = (aluA >  0); end
5'b00101 : begin  aluOUT = aluA;                         overflow = 1'b0;                             branch = (aluA <= 0);  end
5'b00110 : begin  aluOUT = aluA;                          overflow = 1'b0;                           branch = (aluA <  0);   end
5'b01100 :  begin aluOUT = aluA;   start = !finish; branch=0;  end // muti
5'b01101 :  begin aluOUT = aluA;   start = !finish; branch=0;end
5'b01110 : begin aluOUT = aluA;    start = !finish; branch=0;end
5'b01111 : begin aluOUT = aluA;    start = !finish;  branch=0;end   // div
5'b01000 : begin aluOUT = hiOut;  start = 1'b0;         overflow = 1'b0;                               branch=0; end
5'b01010 : begin aluOUT = loOut;  start = 1'b0;            overflow = 1'b0;                           branch=0; end
5'b01001 : begin  /*start = !finish;*/      overflow = 1'b0;                               branch=0; end
5'b01011 : begin  /*start = !finish;  */      overflow = 1'b0;                             branch=0; end
5'b00000 : begin aluOUT = aluA;   start = 1'b0;            overflow = 1'b0;                          branch=0;end
5'b00111 : begin aluOUT = aluB;    start = 1'b0;            overflow = 1'b0;                         branch=0; end
default : begin aluOUT = hiOut;  start = 1'b0;         overflow = 1'b0;                               branch=0; end
endcase
end

endmodule
