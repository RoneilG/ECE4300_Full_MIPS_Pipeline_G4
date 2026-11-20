`timescale 1ns / 1ps

module mips_pipeline(
        input wire clk, rst
    );
    
    // iF outputs
        wire [31:0] ID_npc,
                    instr;
                    
    // iD outputs
        wire [31:0] EX_npc,
                    read_data1,
                    read_data2,
                    sign_ext;
        wire [4:0]  instr_2016,
                    instr_1511;
        wire [3:0]  EX_ex_ctl;
        wire [2:0]  EX_mem_ctl;
        wire [1:0]  EX_wb_ctl;
        
    // exec outputs
        wire [31:0] PC_from_ExMemLatch,
                    MEM_alu_result,
                    read_data2_out;
        wire [4:0]  MEM_write_reg;
        wire [1:0]  MEM_wb_ctl;
        wire        zero,
                    MEM_read,
                    MEM_write,
                    MEM_branch;
        
    // mem_wb outputs
        wire [31:0] read_data,
                    WB_alu_result,
                    write_data;
        wire [4:0]  WB_write_reg;
        wire [1:0]  WB_wb_ctl;
        wire        PC_Src;
    
    fetch mips_fetch (
        .clk(clk), 
        .rst(rst), 
        .ex_mem_pc_src(PC_Src),
        .ex_mem_npc(PC_from_ExMemLatch),
        
        .if_id_instr(instr), 
        .if_id_npc(ID_npc)
    );
    
    decode mips_decode (
        .clk(clk), 
        .rst(rst), 
        .wb_reg_write(WB_wb_ctl[1]),
        .wb_write_reg_location(MEM_write_reg),
        .mem_wb_write_data(write_data), 
        .if_id_instr(instr), 
        .if_id_npc(ID_npc),
                                                  
        .id_ex_wb(EX_wb_ctl),             
        .id_ex_mem(EX_mem_ctl),            
        .id_ex_execute(EX_ex_ctl),        
        .id_ex_npc(EX_npc),            
        .id_ex_readdat1(read_data1),       
        .id_ex_readdat2(read_data2),       
        .id_ex_sign_ext(sign_ext),       
        .id_ex_instr_bits_20_16(instr_2016),
        .id_ex_instr_bits_15_11(instr_1511)
    );
        
    execute mips_execute (
        .clk(clk), 
        .rst(rst), 
        .reg_dst(EX_ex_ctl[0]), 
        .alu_src(EX_ex_ctl[1]),
        .wb_ctl(EX_wb_ctl), 
        .alu_op(EX_ex_ctl[3:2]),
        .mem_ctl(EX_mem_ctl),
        
        .npc(EX_npc), 
        .read_data1(read_data1), 
        .read_data2(read_data2), 
        .sign_extended(sign_ext),
        .instr_20_16(instr_2016), 
        .instr_15_11(instr_1511),
        .wb_ctl_out(MEM_wb_ctl),
        .branch(MEM_branch), 
        .mem_read(MEM_read), 
        .mem_write(MEM_write), 
        .zero(zero),
        .add_result(PC_from_ExMemLatch), 
        .alu_result(MEM_alu_result), 
        .read_data2_out(read_data2_out),
        .write_register(MEM_write_reg)
    );
    
    memory mips_memory (
        .clk(clk), 
        .rst(rst), 
        .m_ctlout(MEM_branch), 
        .zero(zero),
        .mem_write(MEM_write), 
        .mem_read(MEM_read),
        .ctlwb_in(MEM_wb_ctl),
        .muxout_in(MEM_write_reg),
        .alu_result(MEM_alu_result), 
        .readdata2_ex_mem(read_data2_out),
        
        .reg_write(WB_wb_ctl[1]), 
        .mem_to_reg(WB_wb_ctl[0]), 
        .PCSrc(PC_Src),
        .readdata_out(read_data), 
        .mem_alu_result(WB_alu_result),
        .mem_write_reg(WB_write_reg)
    );
    
    wb_mux mips_wb (
        .a(read_data), 
        .b(WB_alu_result),
        .sel(WB_wb_ctl[0]),
        .y(write_data)
    );
    
endmodule
