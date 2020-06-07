module PC(CLK, Write, reset,Jump,pc4,Branch,Epc,except,Select,pc);
input[31:0] Jump, pc4, Branch, Epc;
input [1:0] Select;
input CLK,except,Write,reset;
output reg [31:0]pc;
//output reg _reset;
/*
reg [31:0] count;

initial begin
count = 0;
end*/


always@(posedge CLK)
begin
case ({Write,Select})
3'b100 : pc <= pc4;
3'b101 : pc <= Branch;
3'b110 : pc <= Jump;
3'b111 : pc <= Epc;
endcase
if(except&Write)pc <=32'hbfc00380;
if(!reset)pc <= 32'hbfc00000;
//_reset <= reset;
//count <= count+1;
end


// always @ ( posedge CLK ) begin
// pc <= _pc;
// _reset <= reset;
// end

endmodule

module PC4(pc,pc4);
input[31:0] pc;
output[31:0] pc4;
assign pc4 = pc + 4;
endmodule
