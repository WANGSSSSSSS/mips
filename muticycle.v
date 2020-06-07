module mutiCycle(clk, start, op ,inputA, inputB, hiOut, loOut, stall);
input clk,start;
input [4:0] op;
input [31:0] inputA,inputB;
reg[31:0] hi,lo;
reg[1:0] state;
reg[5:0] cycle;

output [31:0] hiOut, loOut;
output reg stall;

reg flag;

wire [31:0] hi_sub_inputB;
wire [31:0] hi_sub_inputBS;
assign hi_sub_inputB = ({hi[30:0],lo[31]} - inputB);


wire [31:0]true_inputB;
assign true_inputB = inputB[31] ? ~inputB+1:inputB;
wire [31:0]true_inputA;
assign true_inputA = inputA[31] ? ~inputA+1:inputA;

assign hi_sub_inputBS = {hi[30:0],lo[31]} - true_inputB;


assign hiOut = hi;
assign loOut = lo;

`define MUTIOP 5'b01100
`define MUTIUOP 5'b01101
`define DIVOP 5'b01110
`define DIVUOP 5'b01111
`define MTHI  5'b01001
`define MTLO 5'b01011

initial begin
state = 2'b00;
stall = 1'b0;
end


always@(posedge clk) begin
case(state)
2'b00 : begin
		if(start) begin
		case(op)
		`MUTIOP : begin  hi<=32'b0;	lo<=inputB;	cycle<=6'b0;	state <= 2'b01; stall <= 1'b0; flag<= 1'b0; end
		`MUTIUOP: begin  hi<=32'b0;	lo<=inputB; cycle<=6'b0;    state <= 2'b01; stall <= 1'b0; end
		`DIVOP  : begin  lo<=true_inputA; hi<=32'b0; cycle<=6'b0;     state <= 2'b01; stall <= 1'b0; end
		`DIVUOP : begin  lo<=inputA; hi<=32'b0; cycle<=6'b0;     state <= 2'b01; stall <= 1'b0; end
		//`MTHI : begin hi <= inputA; stall =1'b1;end
		//`MTLO: begin lo <= inputA; stall = 1'b1; end
		default : stall <= 1'b0;
		endcase
		end
		else begin
		case(op)
		`MTHI : begin hi <= inputA; end
		`MTLO: begin lo <= inputA;  end
		endcase
		end
    stall <= 1'b0;
		end
2'b01 : begin
		case(op)
		`MUTIOP : begin cycle<= cycle +1; state <= state + (cycle == 6'b011111); stall <=1'b0;
				case({lo[0],flag})
				2'b00 : begin {hi,lo,flag} <= $signed({hi,lo,flag})>>>1;/*(cycle != 5'b11111);*/ end
				2'b01 : begin {hi,lo,flag} <= $signed({hi+inputA,lo, flag})>>>1;/*(cycle != 5'b11111);*/ end
				2'b10 : begin {hi,lo,flag} <= $signed({hi-inputA,lo, flag})>>>1;/*(cycle != 5'b11111);*/ end
				2'b11 :	begin {hi,lo,flag} <= $signed({hi,lo, flag})>>>1;/*(cycle != 5'b11111); */end
				endcase
		end
		`MUTIUOP: begin cycle<= cycle +1; {hi,lo} <= {{1'b0,hi}+ {1'b0,inputA&{32{lo[0]}}} ,lo[31:1]}; state <= state + (cycle == 6'b011111); stall <=1'b0; end
		`DIVOP : begin cycle<= cycle +1; state <= state + (cycle == 6'b011111);   stall <=1'b0;
					{hi,lo} <= {hi[30:0], lo[31]} < true_inputB ?  {hi[30:0],lo,1'b0}:{hi_sub_inputBS,lo[30:0],1'b1} ;
				end
		`DIVUOP : begin cycle<= cycle +1; state <= state + (cycle == 6'b011111);stall <=1'b0;
					{hi,lo} <= {hi[30:0], lo[31]} < inputB ?  {hi[30:0],lo,1'b0}:{hi_sub_inputB,lo[30:0],1'b1} ;
				end
		endcase
		end
2'b10 : begin
		case(op)
		`MUTIOP : begin stall <= 1'b1; end
		`MUTIUOP: begin stall <= 1'b1; end
		`DIVUOP : begin stall <= 1'b1; end
		`DIVOP : begin stall <= 1'b1; lo <= inputA[31]^inputB[31] ? ~lo+1:lo; hi <= inputA[31] ? ~hi+1 : hi; end
		endcase
		state <= 2'b00;
		end
endcase
end

endmodule
