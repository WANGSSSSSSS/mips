module IF(clk,write, rst,flush,inst,instOut,pc,pcOut);
input clk,write,rst, flush;
input[31:0] inst,pc;
output [31:0] instOut;
output reg[31:0] pcOut;

reg Flush;

assign instOut = {inst & {32{rst & !Flush}}};

always@(posedge clk)
begin
if(write)
begin
pcOut <= pc;
end

Flush <= flush;

if(!rst)
begin
pcOut <= 32'h00000000;
Flush <= 1'b0;
end

end
endmodule
