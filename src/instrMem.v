`timescale 1ns / 1ps

module instrMem(
    output reg [31:0] data,
    input [31:0] addr,
    input clk, rst
    );
    
    reg [31:0] register [0:63];
    integer i;
    
    initial begin
        for (i = 0; i < 64; i = i+1)
            register[i] = 0;
				
        $readmemb("instr.mem", register);
        
        for (i = 0; i < 25; i = i + 1)
        $display("\IMEM[%0d] = %032b", i, register[i]);
    end

	always @ (negedge clk or negedge rst) begin
		if (!rst)
		  data <= 32'h0;
		else
          data <= register[addr];
	end
    
endmodule
