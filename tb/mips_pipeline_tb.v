`timescale 1ns / 1ps

module mips_pipeline_tb;
    reg clk;
    reg rst;

    mips_pipeline dut (
        .clk(clk),
        .rst(rst)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    initial begin
        rst = 0;
        #10 rst = 1;
    end
    
    /* Instructions:
    lw $at, 0x1($zero)
    lw $v0, 0x2($zero)
    lw $v1, 0x3($zero)
    lb $zero, 0x0($zero)
    lb $zero, 0x0($zero)
    add $at, $at, $v0
    lb $zero, 0x0($zero)
    lb $zero, 0x0($zero)
    lb $zero, 0x0($zero)
    add $at, $at, $v1
    lb $zero, 0x0($zero)
    lb $zero, 0x0($zero)
    lb $zero, 0x0($zero)
    add $at, $at, $at
    lb $zero, 0x0($zero)
    lb $zero, 0x0($zero)
    lb $zero, 0x0($zero)
    lb $zero, 0x0($zero)
    add $at, $at, $zero
    lb $zero, 0x0($zero)
    lb $zero, 0x0($zero)
    lb $zero, 0x0($zero)
    lb $zero, 0x0($zero)
    lb $zero, 0x0($zero)
    */
    
endmodule
