module detect(rs, rt, exe_wen, exe_wnum, mem_wen, mem_wnum, wb_wen, wb_wnum, rs_select, rt_select);
input exe_wen, mem_wen, wb_wen;
input [4:0] rs,rt, exe_wnum, mem_wnum, wb_wnum;

output reg [1:0] rs_select, rt_select;

always @ ( * ) begin
case({exe_wen, mem_wen, wb_wen})
3'b000 : begin rs_select = 2'b00; rt_select = 2'b00; end
3'b100 : begin rs_select = (rs == exe_wen) ? 2'b01 : 2'b00;  rt_select = (rt == exe_wen) ? 2'b01 : 2'b00;  end
3'b101 : begin rs_select = (rs == exe_wen) ? 2'b01 : 2'b00;  rt_select = (rt == exe_wen) ? 2'b01 : 2'b00;  end
3'b110 : begin rs_select = (rs == exe_wen) ? 2'b01 : 2'b00;  rt_select = (rt == exe_wen) ? 2'b01 : 2'b00;  end
3'b111 : begin rs_select = (rs == exe_wen) ? 2'b01 : 2'b00;  rt_select = (rt == exe_wen) ? 2'b01 : 2'b00;  end
3'b010 : begin rs_select = (rs == mem_wen) ? 2'b10 : 2'b00;  rt_select = (rt == mem_wen) ? 2'b10 : 2'b00;  end
3'b011 : begin rs_select = (rs == mem_wen) ? 2'b10 : 2'b00;  rt_select = (rt == mem_wen) ? 2'b10 : 2'b00;  end
3'b001 : begin rs_select = (rs == wb_wen) ? 2'b11 : 2'b00;  rt_select = (rt == wb_wen) ? 2'b01 : 2'b00;  end
default : begin rs_select = 2'b00; rt_select = 2'b00; end
endcase
end


endmodule
