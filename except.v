module ExceptionHandler(clk, pc_change,overflow, bad_inst, AddressErrorout,  AddressErrorin, address, pc, Int, pc_get_inst,B_C,Except,badAddress,badpc,cause,state);
input [31:0] pc,address,pc_get_inst;
input overflow,AddressErrorout, AddressErrorin, bad_inst, clk, pc_change, Int;
input [1:0]B_C;
output reg Except;
output reg[31:0] badpc,badAddress,cause,state;


wire pc_error, Int;
assign pc_error  =  pc_get_inst[1:0] != 2'b00;

reg have_branch;



always@(posedge clk)
begin
have_branch <= pc_change;
end

initial begin
  Except = 1'b0;
end


always@(*)
begin
Except = B_C[1] | AddressErrorout |overflow| AddressErrorin|pc_error| bad_inst| Int;

if(Except)
begin
case({B_C})
2'b10:    begin cause   = {have_branch,24'b0 ,5'b01001,2'b00};        state   =   32'h00400002;     badpc =  have_branch ? pc-4: pc;      badAddress = address;                                  end    //  break
2'b11 :    begin  cause  = {have_branch,24'b0 ,5'b01000,2'b00};        state   = 32'h00400002;      badpc = have_branch ? pc-4: pc;       badAddress = address;                                       end   //  syscall
2'b00 :  begin
                if(AddressErrorout)begin   cause   = {have_branch,24'b0 ,5'b00101,2'b00};        state   = 32'h00400002;    badpc =  have_branch ? pc-4: pc;      badAddress = address;  end
                else if(overflow)  begin   cause   = {have_branch,24'b0 ,5'b01100,2'b00};        state   = 32'h00400002;  badpc =  have_branch ? pc-4: pc;      badAddress = address;    end
                else if(bad_inst)  begin   cause   = {have_branch,24'b0 ,5'b01010,2'b00};        state   = 32'h00400002;   badpc =  have_branch ? pc-4: pc;      badAddress = address;   end
                else if(AddressErrorin) begin cause   = {have_branch,24'b0 ,5'b00100,2'b00};        state   = 32'h00400002; badpc =  have_branch ? pc-4: pc;      badAddress = address;   end
                else if(pc_error)begin cause   = {25'b0 ,5'b00100,2'b00};        state   = 32'h00400002;  badpc =  pc;      badAddress = pc_get_inst;   end
                else if(Int)begin cause   = {have_branch,24'b0 ,5'b00000,2'b00};        state   = 32'h0040ff03;  badpc = pc;  badAddress = address; end
                end
endcase
end

end

endmodule
