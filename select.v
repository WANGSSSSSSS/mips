module select4(select,inputA,inputB,inputC,inputD,out);
input [1:0] select;
input [31:0] inputA,inputB,inputC,inputD;
output reg[31:0] out;
always@(*)
case(select)
2'b00 : out <= inputA;
2'b01 : out <= inputB;
2'b10 : out <= inputC;
2'b11 : out <= inputD;
endcase
endmodule

module select2(select,inputA,inputB,out);
input select;
input [31:0]inputA,inputB;
output reg[31:0] out;

always@(*)
case(select)
1'b0 : out<= inputA;
1'b1 : out<= inputB;
endcase
endmodule


module select4_5(select,inputA,inputB,inputC,inputD,out);
input [1:0] select;
input [4:0] inputA,inputB,inputC,inputD;
output reg[4:0] out;
always@(*)
case(select)
2'b00 : out <= inputA;
2'b01 : out <= inputB;
2'b10 : out <= inputC;
2'b11 : out <= inputD;
endcase
endmodule
