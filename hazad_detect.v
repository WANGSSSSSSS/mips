module detect(rs, rt,  exe_wen, exe_wnum, mem_wen, mem_wnum, wb_wen, wb_wnum, rs_select, rt_select/*,
                              exe_cp0_wen, exe_cp0_wnum, mem_cp0_wen,mem_cp0_wnum, wb_cp0_wen ,wb_cp0_wnum, cp0_select*/);
input exe_wen, mem_wen, wb_wen/* ,exe_cp0_wen, mem_cp0_wen, wb_cp0_wen*/;
input [4:0] rs,rt, exe_wnum, mem_wnum, wb_wnum/*, exe_cp0_wnum, mem_cp0_wnum, wb_cp0_wnum*/;

output  [1:0] rs_select, rt_select;

assign rs_select = (exe_wen & (rs == exe_wnum)) ?  2'b01 :  (mem_wen & (rs == mem_wnum)) ? 2'b10: (wb_wen & (rs == wb_wnum)) ? 2'b11 : 2'b00;
assign rt_select = (exe_wen & (rt == exe_wnum)) ?  2'b01 :  (mem_wen & (rt == mem_wnum)) ? 2'b10: (wb_wen & (rt == wb_wnum)) ? 2'b11 : 2'b00;
//assign cp0_select =   (exe_cp0_wen & (rd == exe_cp0_wnum)) ?  2'b01 :  (mem_cp0_wen & (rd == mem_cp0_wnum)) ? 2'b10: (wb_cp0_wen & (rd == wb_cp0_wnum)) ? 2'b11 : 2'b00;

endmodule
