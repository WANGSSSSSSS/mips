module Control(
				clk,
				inst,
				aluOP,
				pc8,
				aluBselect,
				regWrite,
				Cp0Write,
				MemWrite,
				RegToWrite,
				MemToReg,
				Jump,
				epcInst,
				B_C,
				memReadEn,
				aluAselect,
				bad_inst_out,
				pc_change
				);
input[31:0] inst;
input  clk;
output bad_inst_out;
output reg  Cp0Write,pc8, epcInst;
output reg pc_change;
reg bad_inst;

assign bad_inst_out = (inst!=32'h0)&bad_inst;

output reg[1:0] Jump,aluBselect,B_C,RegToWrite;
output reg[4:0] aluOP;
output reg MemToReg,aluAselect, regWrite;
output reg [3:0]memReadEn, MemWrite;


always@(*)
begin
	if(inst[31:26] == 6'b000000)
	begin
	MemWrite = 0;
	//Cp0Write = 1'b0;
	MemToReg = 1'b0;
	regWrite = (inst[15:11]!=5'b00000);
	//B_C = 2'b00;
	aluBselect = 2'b00;
	epcInst = 1'b0;
	memReadEn = 4'b0000;
	aluAselect = 1'b0;
		case(inst[5:0])
		6'b100000 : begin aluOP = 5'b10000;  Jump = 2'b00;RegToWrite = 2'b00;pc8=1'b0;B_C = 2'b00;Cp0Write = 1'b0;aluAselect = 1'b0;bad_inst = 1'b0;end
		6'b100001 : begin aluOP = 5'b10001;	 Jump = 2'b00;RegToWrite = 2'b00;pc8=1'b0;B_C = 2'b00;Cp0Write = 1'b0;aluAselect = 1'b0;bad_inst = 1'b0;end
		6'b100010 : begin aluOP = 5'b10010;	 Jump = 2'b00;RegToWrite = 2'b00;pc8=1'b0;B_C = 2'b00;Cp0Write = 1'b0;aluAselect = 1'b0;bad_inst = 1'b0;end
		6'b100011 : begin aluOP = 5'b10011;  Jump = 2'b00;RegToWrite = 2'b00;pc8=1'b0;B_C = 2'b00;Cp0Write = 1'b0;aluAselect = 1'b0;bad_inst = 1'b0;end
		6'b100100 : begin aluOP = 5'b10100;  Jump = 2'b00;RegToWrite = 2'b00;pc8=1'b0;B_C = 2'b00;Cp0Write = 1'b0;aluAselect = 1'b0;bad_inst = 1'b0;end
		6'b100101 : begin aluOP = 5'b10101; Jump = 2'b00; RegToWrite = 2'b00;pc8=1'b0;B_C = 2'b00;Cp0Write = 1'b0;aluAselect = 1'b0;bad_inst = 1'b0;end
		6'b100110 : begin aluOP = 5'b10110;  Jump = 2'b00;RegToWrite = 2'b00;pc8=1'b0;B_C = 2'b00;Cp0Write = 1'b0;aluAselect = 1'b0;bad_inst = 1'b0;end
		6'b100111 : begin aluOP = 5'b10111;  Jump = 2'b00;RegToWrite = 2'b00;pc8=1'b0;B_C = 2'b00;Cp0Write = 1'b0;aluAselect = 1'b0;bad_inst = 1'b0;end
		6'b101010 : begin aluOP = 5'b11010; Jump = 2'b00; RegToWrite = 2'b00;pc8=1'b0;B_C = 2'b00;Cp0Write = 1'b0;aluAselect = 1'b0;bad_inst = 1'b0;end
		6'b101011 : begin aluOP = 5'b11011;  Jump = 2'b00;RegToWrite = 2'b00;pc8=1'b0;B_C = 2'b00;Cp0Write = 1'b0;aluAselect = 1'b0;bad_inst = 1'b0;end

		6'b000100 : begin aluOP = 5'b11100;  Jump = 2'b00;RegToWrite = 2'b00;pc8=1'b0;B_C = 2'b00;Cp0Write = 1'b0;aluAselect = 1'b0;bad_inst = 1'b0;end
		6'b000111 : begin aluOP = 5'b11111;  Jump = 2'b00;RegToWrite = 2'b00;pc8=1'b0;B_C = 2'b00;Cp0Write = 1'b0;aluAselect = 1'b0;bad_inst = 1'b0;end
		6'b000110 : begin aluOP = 5'b11110;  Jump = 2'b00;RegToWrite = 2'b00;pc8=1'b0;B_C = 2'b00;Cp0Write = 1'b0;aluAselect = 1'b0;bad_inst = 1'b0;end
		6'b000000 : begin aluOP = 5'b11100;  Jump = 2'b00;RegToWrite = 2'b00;pc8=1'b0;B_C = 2'b00;Cp0Write = 1'b0;aluAselect = 1'b0;bad_inst = 1'b0;end
		6'b000011 : begin aluOP = 5'b11111;  Jump = 2'b00;RegToWrite = 2'b00;pc8=1'b0;B_C = 2'b00;Cp0Write = 1'b0;aluAselect = 1'b0;bad_inst = 1'b0;end
		6'b000010 : begin aluOP = 5'b11110;  Jump = 2'b00;RegToWrite = 2'b00;pc8=1'b0;B_C = 2'b00;Cp0Write = 1'b0;aluAselect = 1'b0;bad_inst = 1'b0;end
		6'b011000 : begin aluOP = 5'b01100;  Jump = 2'b00;RegToWrite = 2'b00;pc8=1'b0;B_C = 2'b00;Cp0Write = 1'b0;aluAselect = 1'b0;bad_inst = 1'b0;end
		6'b011001 : begin aluOP = 5'b01101;  Jump = 2'b00;RegToWrite = 2'b00;pc8=1'b0;B_C = 2'b00;Cp0Write = 1'b0;aluAselect = 1'b0;bad_inst = 1'b0;end
		6'b011010 : begin aluOP = 5'b01110; Jump = 2'b00;RegToWrite = 2'b00; pc8=1'b0;B_C = 2'b00;Cp0Write = 1'b0;aluAselect = 1'b0;bad_inst = 1'b0;end
		6'b011011 : begin aluOP = 5'b01111;  Jump = 2'b00;RegToWrite = 2'b00;pc8=1'b0;B_C = 2'b00;Cp0Write = 1'b0;aluAselect = 1'b0;bad_inst = 1'b0;end
		6'b010000: begin aluOP = 5'b01000; Jump = 2'b00;RegToWrite = 2'b00;pc8=1'b0;B_C = 2'b00;Cp0Write = 1'b0;aluAselect = 1'b0;bad_inst = 1'b0;end
		6'b010010: begin aluOP = 5'b01010; Jump = 2'b00;RegToWrite = 2'b00;pc8=1'b0;B_C = 2'b00;Cp0Write = 1'b0;aluAselect = 1'b0;bad_inst = 1'b0;end
		6'b010001: begin aluOP = 5'b01001; Jump = 2'b00;RegToWrite = 2'b00;pc8=1'b0;B_C = 2'b00;Cp0Write = 1'b0;aluAselect = 1'b0;bad_inst = 1'b0;end
		6'b010011: begin aluOP = 5'b01011; Jump = 2'b00;RegToWrite = 2'b00;pc8=1'b0;B_C = 2'b00;Cp0Write = 1'b0;aluAselect = 1'b0;bad_inst = 1'b0;end

		6'b001000 : begin aluOP = 5'b00000;  Jump = 2'b10;RegToWrite = 2'b00;pc8=1'b0;B_C = 2'b00;Cp0Write = 1'b0;aluAselect = 1'b0;bad_inst = 1'b0;end
		6'b001001 : begin aluOP = 5'b00000;  Jump =  2'b10;RegToWrite = 2'b10; pc8=1'b1;B_C = 2'b00;Cp0Write = 1'b0;aluAselect = 1'b0;bad_inst = 1'b0;end

		6'b001101: begin aluOP = 5'b00000; Jump = 2'b00;B_C = 2'b10;Cp0Write = 1'b1;bad_inst = 1'b0;end // break
		6'b001100:begin  aluOP = 5'b00000; Jump = 2'b00;regWrite = 0;B_C = 2'b11;Cp0Write = 1'b1;bad_inst = 1'b0;end// syscall

		6'b100000 : begin aluOP = 5'b01000;  Jump = 2'b00;RegToWrite = 2'b00;B_C = 2'b00;bad_inst = 1'b0;end
		6'b100010 : begin aluOP = 5'b00001;  Jump = 2'b00;RegToWrite = 2'b00;B_C = 2'b00;bad_inst = 1'b0;end
		6'b100001 : begin aluOP = 5'b00001; Jump = 2'b00; RegToWrite = 2'b00;B_C = 2'b00;bad_inst = 1'b0;end
		6'b100011 : begin aluOP = 5'b00001;  Jump = 2'b00;RegToWrite = 2'b00;B_C = 2'b00;bad_inst = 1'b0;end
		default: begin aluOP = 5'b00000; bad_inst = 1'b1; end
		endcase
	end
	// else if(inst[31:26] == 6'b000010)
	// begin
	// aluOP = 5'b00000;
	// Jump = 2'b11;
	// Cp0Write = 1'b0;
	// end
	// else if(inst[31:26] == 6'b000011)
	// begin
	// aluOP = 5'b00000;
	// Jump = 2'b11;
	// Cp0Write = 1'b0;
	// end
	else
	 case(inst[31:26])
	 6'b001000 : begin aluOP = 5'b10000;aluBselect = 2'b01; regWrite = 1; MemWrite = 0;RegToWrite=2'b01;MemToReg=1'b0;Jump = 2'b00;pc8=1'b0;memReadEn = 4'b0000;aluAselect = 1'b0;B_C = 2'b00;Cp0Write = 1'b0;epcInst = 1'b0;bad_inst = 1'b0;end
	 6'b001001 : begin aluOP = 5'b10001;aluBselect = 2'b01; regWrite = 1; MemWrite = 0;RegToWrite=2'b01;MemToReg=1'b0;Jump = 2'b00;pc8=1'b0;memReadEn = 4'b0000;aluAselect = 1'b0;B_C = 2'b00;Cp0Write = 1'b0;epcInst = 1'b0;bad_inst = 1'b0;end
	 6'b001010 : begin aluOP = 5'b11010;aluBselect = 2'b01; regWrite = 1; MemWrite = 0;RegToWrite=2'b01;MemToReg=1'b0;Jump = 2'b00;pc8=1'b0;memReadEn = 4'b0000;aluAselect = 1'b0;B_C = 2'b00;Cp0Write = 1'b0;epcInst = 1'b0;bad_inst = 1'b0;end
	 6'b001011 : begin aluOP = 5'b11011; aluBselect = 2'b01;regWrite = 1; MemWrite = 0;RegToWrite=2'b01;MemToReg=1'b0;Jump = 2'b00;pc8=1'b0;memReadEn = 4'b0000;aluAselect = 1'b0;B_C = 2'b00;Cp0Write = 1'b0;epcInst = 1'b0;bad_inst = 1'b0;end
	 6'b001100 : begin aluOP = 5'b10100; aluBselect = 2'b10;regWrite = 1; MemWrite = 0;RegToWrite=2'b01;MemToReg=1'b0;Jump = 2'b00;pc8=1'b0;memReadEn = 4'b0000;aluAselect = 1'b0;B_C = 2'b00;Cp0Write = 1'b0;epcInst = 1'b0;bad_inst = 1'b0;end
	 6'b001101 : begin aluOP = 5'b10101; aluBselect = 2'b10;regWrite = 1; MemWrite = 0;RegToWrite=2'b01;MemToReg=1'b0;Jump = 2'b00;pc8=1'b0;memReadEn = 4'b0000;aluAselect = 1'b0;B_C = 2'b00;Cp0Write = 1'b0;epcInst = 1'b0;bad_inst = 1'b0;end
	 6'b001110 : begin aluOP = 5'b10110; aluBselect = 2'b10;regWrite = 1; MemWrite = 0;RegToWrite=2'b01;MemToReg=1'b0;Jump = 2'b00;pc8=1'b0;memReadEn = 4'b0000;aluAselect = 1'b0;B_C = 2'b00;Cp0Write = 1'b0;epcInst = 1'b0;bad_inst = 1'b0;end
	 6'b001111 : begin aluOP = 5'b00111; aluBselect = 2'b11;regWrite = 1; MemWrite = 0;RegToWrite=2'b01;MemToReg=1'b0;Jump = 2'b00;pc8=1'b0;memReadEn = 4'b0000;aluAselect = 1'b0;B_C = 2'b00;Cp0Write = 1'b0;epcInst = 1'b0;bad_inst = 1'b0;end


	 6'b100000 : begin aluOP = 5'b10000;aluBselect = 2'b01; regWrite = 1; MemWrite = 0;RegToWrite=2'b01;MemToReg=1'b1;memReadEn = 4'b1001;Jump = 2'b00;pc8=1'b0;aluAselect = 1'b0;B_C = 2'b00;Cp0Write = 1'b0;epcInst = 1'b0;bad_inst = 1'b0;end
	 6'b100100 : begin aluOP = 5'b10000; aluBselect = 2'b01;regWrite = 1; MemWrite = 0;RegToWrite=2'b01;MemToReg=1'b1;memReadEn = 4'b0001;Jump = 2'b00;pc8= 1'b0;aluAselect = 1'b0;B_C = 2'b00;Cp0Write = 1'b0;epcInst = 1'b0;bad_inst = 1'b0;end
	 6'b100001 : begin aluOP = 5'b10000;aluBselect = 2'b01; regWrite = 1; MemWrite = 0;RegToWrite=2'b01;MemToReg=1'b1;memReadEn = 4'b1011;Jump = 2'b00;pc8=1'b0;aluAselect = 1'b0;B_C = 2'b00;Cp0Write = 1'b0;epcInst = 1'b0;bad_inst = 1'b0;end
	 6'b100101 : begin aluOP = 5'b10000; aluBselect = 2'b01;regWrite = 1; MemWrite = 0;RegToWrite=2'b01;MemToReg=1'b1;memReadEn = 4'b0011;Jump = 2'b00;pc8=1'b0;aluAselect = 1'b0;B_C = 2'b00;Cp0Write = 1'b0;epcInst = 1'b0;bad_inst = 1'b0;end
	 6'b100011 : begin aluOP = 5'b10000; aluBselect = 2'b01;regWrite = 1; MemWrite = 0;RegToWrite=2'b01;MemToReg=1'b1;memReadEn = 4'b1111;Jump = 2'b00;pc8=1'b0;aluAselect = 1'b0;B_C = 2'b00;Cp0Write = 1'b0;epcInst = 1'b0;bad_inst = 1'b0;end
	 6'b101000 : begin aluOP = 5'b10000; aluBselect = 2'b01;regWrite = 0; MemWrite = 4'b0001;RegToWrite=2'b01;MemToReg=1'b0;memReadEn = 4'b0000;Jump = 2'b00;pc8=1'b0;aluAselect = 1'b0;B_C = 2'b00;Cp0Write = 1'b0;epcInst = 1'b0;bad_inst = 1'b0;end
	 6'b101001 : begin aluOP = 5'b10000; aluBselect = 2'b01;regWrite = 0; MemWrite = 4'b0011;RegToWrite=2'b01;MemToReg=1'b0;memReadEn = 4'b0000;Jump = 2'b00;pc8=1'b0;aluAselect = 1'b0;B_C = 2'b00;Cp0Write = 1'b0;epcInst = 1'b0;bad_inst = 1'b0;end
	 6'b101011 : begin aluOP = 5'b10000; aluBselect = 2'b01;regWrite = 0; MemWrite = 4'b1111;RegToWrite=2'b01;MemToReg=1'b0;memReadEn = 4'b0000;Jump = 2'b00;pc8=1'b0;aluAselect = 1'b0;B_C = 2'b00;Cp0Write = 1'b0;epcInst = 1'b0;bad_inst = 1'b0;end

	 6'b010000 : begin
	 case({inst[25], inst[23]})
	 2'b00 : begin aluOP = 5'b00000; regWrite = 1;memReadEn = 4'b0000;Jump = 2'b00;MemWrite=2'b00;pc8=1'b0;RegToWrite=2'b01;  MemToReg=1'b0;aluAselect = 1'b1;B_C = 2'b00;Cp0Write = 1'b0;MemWrite = 4'b0000; epcInst = 1'b0;bad_inst = 1'b0;end// mfco
	 2'b10 : begin aluOP = 5'b10000; regWrite = 0;memReadEn = 4'b0000;Jump = 2'b00;MemToReg=1'b0;pc8=1'b0;B_C = 2'b00;epcInst = 1'b1;Cp0Write = 1'b0; aluBselect = 2'b01; MemWrite = 4'b0000; bad_inst = 1'b0;end// exrt
	 2'b01:  begin aluOP = 5'b00111; aluBselect = 2'b00; regWrite = 0;memReadEn = 4'b0000;Jump = 2'b00;MemToReg=1'b0;pc8=1'b0;  Cp0Write = 1'b1;B_C = 2'b00;MemWrite = 4'b0000; epcInst = 1'b0;bad_inst = 1'b0;end// mtco
   default : begin bad_inst = 1'b1;  end
	 endcase
	 //default : begin  bad_inst = 1'b1; end
	 end
	 //end // tq




	 6'b000011 : begin  aluOP = 5'b10000; aluBselect=2'b01; regWrite = 1; MemWrite = 0;RegToWrite=2'b10; MemToReg=1'b0;memReadEn = 4'b0000;Jump = 2'b11;pc8=1'b1; aluAselect = 1'b0;B_C = 2'b00;Cp0Write = 1'b0;epcInst = 1'b0;bad_inst = 1'b0;end
   6'b000010 : begin  aluOP = 5'b10000; aluBselect=2'b01; regWrite = 0; MemWrite = 0;RegToWrite=2'b10; MemToReg=1'b0;memReadEn = 4'b0000;Jump = 2'b11;pc8=1'b0; aluAselect = 1'b0;B_C = 2'b00;Cp0Write = 1'b0;epcInst = 1'b0;bad_inst = 1'b0;end


	 6'b000100 : begin aluOP = 5'b00001;aluBselect = 2'b00; regWrite = 0; MemWrite = 0;MemToReg=1'b0;memReadEn = 4'b0000;Jump = 2'b00;aluAselect = 1'b0;B_C = 2'b00;Cp0Write = 1'b0;epcInst = 1'b0;bad_inst = 1'b0;pc_change = 1'b1;end
	 6'b000101 : begin aluOP = 5'b00010; aluBselect = 2'b00;regWrite = 0; MemWrite = 0;MemToReg=1'b0;memReadEn = 4'b0000;Jump = 2'b00;aluAselect = 1'b0;B_C = 2'b00;Cp0Write = 1'b0;epcInst = 1'b0;bad_inst = 1'b0;pc_change = 1'b1;end
	 6'b000111 : begin aluOP = 5'b00100;aluBselect = 2'b00; regWrite = 0; MemWrite = 0;MemToReg=1'b0;memReadEn = 4'b0000;Jump = 2'b00;aluAselect = 1'b0;B_C = 2'b00;Cp0Write = 1'b0;epcInst = 1'b0;bad_inst = 1'b0;pc_change = 1'b1;end
	 6'b000110 : begin aluOP = 5'b00101; aluBselect = 2'b00;regWrite = 0; MemWrite = 0;MemToReg=1'b0;memReadEn = 4'b0000;Jump = 2'b00;aluAselect = 1'b0;B_C = 2'b00;Cp0Write = 1'b0;epcInst = 1'b0;bad_inst = 1'b0;pc_change = 1'b1;end
	 6'b000001 : begin
				case({inst[20],inst[16]})
				2'b00 : begin aluOP = 5'b00110;   aluBselect=2'b11; regWrite = 0; MemWrite = 0;RegToWrite=2'b10; MemToReg=1'b0;memReadEn = 4'b0000;Jump = 2'b00;pc8=1'b0; aluAselect = 1'b0;B_C = 2'b00;Cp0Write = 1'b0;epcInst = 1'b0;bad_inst = 1'b0;pc_change = 1'b1;end
				2'b01 : begin aluOP = 5'b00011;   aluBselect=2'b11; regWrite = 0; MemWrite = 0;RegToWrite=2'b10; MemToReg=1'b0;memReadEn = 4'b0000;Jump = 2'b00;pc8=1'b0; aluAselect = 1'b0;B_C = 2'b00;Cp0Write = 1'b0;epcInst = 1'b0;bad_inst = 1'b0;pc_change = 1'b1;end
				2'b10 : begin aluOP = 5'b00110;	  aluBselect=2'b11; regWrite = 1; MemWrite = 0;RegToWrite=2'b10; MemToReg=1'b0;memReadEn = 4'b0000;Jump = 2'b00;pc8=1'b1;aluAselect = 1'b0;B_C = 2'b00; Cp0Write = 1'b0;epcInst = 1'b0;bad_inst = 1'b0;pc_change = 1'b1;end
				2'b11 : begin aluOP = 5'b00011;   aluBselect=2'b11; regWrite = 1; MemWrite = 0;RegToWrite=2'b10; MemToReg=1'b0;memReadEn = 4'b0000;Jump = 2'b00;pc8=1'b1;aluAselect = 1'b0;B_C = 2'b00; Cp0Write = 1'b0;epcInst = 1'b0;bad_inst = 1'b0;pc_change = 1'b1;end
				default: begin   bad_inst = 1'b1; pc_change = 1'b0;end
				endcase
				end
				default : begin bad_inst = 1'b1; pc_change = 1'b0;end
	 endcase

/*
	if(_Flush)
	begin
	Jump = 2'b00;
	MemWrite =0;
	regWrite =0;
	RegToWrite = 2'b11;
	Cp0Write =0;
	aluOP = 5'b00000;
	bad_inst = 1'b0;
	end*/
end

endmodule
