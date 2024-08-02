`timescale 1ns / 1ps
module tb();
	reg clk;
	reg inc;
	reg dec,out;
	
	initial begin
	 clk=0;
	 forever #5 clk=~clk;
	end
	
	PWM_Genertor(clk,inc,dec,out);
	initial begin
	inc=1;
	dec=0;
	#100 inc=0;
	inc=1;
	#100 inc=0;
	#100 dec=1;
	#100 dec=0;
        #100 dec=1;
	#100 dec=0;
        end
endmodule