module rangefinder(input wire clock,
                   input wire echo,
						 output wire trigger,
						 output wire[7:0] led_count);
						 
wire[45:0] times;
wire[12:0] distance;



timecount my_time(clock, trigger, echo, times);
converter convrt(clock, times, distance);
ledPrint print(clock, distance, led_count);



endmodule



module timecount(input wire clock,
                 output wire trigger,
					  input wire echo,
					  output wire[45:0] times);

	
	
reg [22:0] clock_reg;
initial clock_reg = 23'b0;
 
reg trigger_reg;
initial trigger_reg = 1'b1;
assign trigger = trigger_reg;

reg [45:0] times_reg;
assign times = times_reg; 			 


always @(posedge clock)
begin
    clock_reg <= clock_reg + 1'b1;
    if(clock_reg < 500)
        begin
		      trigger_reg <= 1'b1;
		  end
		  else begin
		      trigger_reg <= 1'b0;
		  end
end

reg prev_echo;
always @(posedge clock)
begin
    prev_echo <= echo;
end

always @(posedge clock)
begin
	if(prev_echo==1'b0 && echo==1'b1)
		begin
			 times_reg <= clock_reg;
		end
end
endmodule

module converter(input wire clock,
                 input wire[45:0] times,
					  output wire[12:0] distance);
					 
reg[12:0] distance_reg;

assign distance = distance_reg;



always @(posedge clock)
begin
    distance_reg <= (times * 9'd343)/(2'd2 * 16'd50000);
end
endmodule

module ledPrint(input wire clock,
                input wire[12:0] distance,
                output wire[7:0] led_count);
					 
reg[7:0] led_count_regg;
initial led_count_regg <= 8'b00000001;


always @(posedge clock)
begin
    led_count_regg <= distance[7:0];
end 

assign led_count = led_count_regg;					 
					 
endmodule	