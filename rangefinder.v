module rangefinder(input wire clock,
                   input wire echo,
						 output wire trigger,
						 output wire[7:0] led_count);
						 
wire[45:0] times;
wire[12:0] distance;

timecount my_time(clock, trigger, echo, times);
converter convrt (clock, times, distance);
ledPrint print   (clock, distance, led_count);



endmodule



module timecount(input  wire clock,
                 output wire trigger,
					  input  wire echo,
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

module converter(input  wire clock,
                 input  wire[45:0] times,
					  output wire[12:0] distance);
					 
reg[12:0] distance_reg;
wire[45:0] distance_wire;
assign distance = distance_reg;
assign distance_wire = (times * 9'd343)/(2'd2 * 16'd50000);


always @(posedge clock)
begin
    distance_reg <= distance_wire[12:0];
end
endmodule

module ledPrint(input  wire clock,
                input  wire[12:0] distance,
                output wire[7:0]  led_count);
					 
reg[7:0] led_reg;
initial led_reg <= 8'b00000000;


always @(posedge clock)
begin
	led_reg <= 8'h00;
	if (distance[7:0] > 1*10) begin
      led_reg[0] <= 1'b1;
   end 
	if (distance[7:0] > 2*10) begin
      led_reg[1] <= 1'b1;
   end
	if (distance[7:0] > 3*10) begin
      led_reg[2] <= 1'b1;
   end
	if (distance[7:0] > 4*10) begin
      led_reg[3] <= 1'b1;
   end
	if (distance[7:0] > 5*10) begin
      led_reg[4] <= 1'b1;
   end
	if (distance[7:0] > 6*10) begin
      led_reg[5] <= 1'b1;
   end
	if (distance[7:0] > 7*10) begin
      led_reg[6] <= 1'b1;
   end
	if (distance[7:0] > 8*10) begin
      led_reg[7] <= 1'b1;
   end
	
end 

assign led_count = led_reg;					 
					 
endmodule	