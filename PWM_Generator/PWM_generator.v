module PWM_Generator( input clock, decr_duty,incr_duty,
	output PWM_Out);
	
	wire slow_clock_enable;
	reg counter_debounce=0;
	wire tff1,tff2,incre;
	wire tff3,tff4,decre;
	reg [3:0] freq_counter=0;
	reg [3:0] DUTY_CYCLE=5;
	
	always@(posedge clock)begin
	 counter_debounce<=counter_debounce+1;
	 if (counter_debounce>=1) 
		counter_debounce<=0;
	 
	end
	
	assign slow_clock_enable=(counter_debounce==1)? 1:0;
	
	DFF_PWM ff1(clock,slow_clock_enable,incr_duty,tff1);
	DFF_PWM ff2(clock,slow_clock_enable,tff1,tff2);
	assign incre=slow_clock_enable & tff1 &(~tff2);
	
	DFF_PWM ff3(clock,slow_clock_enable,decr_duty,tff3);
	DFF_PWM ff4(clock,slow_clock_enable,tff3,tff4);
	assign decre=slow_clock_enable & tff3 &(~tff4);
	
	always@(posedge clock)begin
		freq_counter<=freq_counter+1;
		if (freq_counter>=9)
			freq_counter<=0;
	end
	
	always@(posedge clock)begin
		if (incre==1 && DUTY_CYCLE<=9)
			DUTY_CYCLE<=DUTY_CYCLE+1;
		else if(decre==1 && DUTY_CYCLE>=1)
			DUTY_CYCLE<=DUTY_CYCLE-1;
	end
	
	assign PWM_Out=(freq_counter < DUTY_CYCLE)? 1:0;
	
	endmodule

	
module DFF_PWM(input clk,enable,d,
	 output reg q);
	 
	 always@(posedge clk)begin
		if (enable==1)
			q<=d;
	 end		
endmodule
