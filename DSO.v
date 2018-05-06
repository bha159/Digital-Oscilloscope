module DSO(CLOCK_50, KEY, SW, LED, ADC_SCLK, ADC_CS_N, ADC_SDAT, ADC_SADDR, hsync, vsync, rgb);
	input CLOCK_50;
	input [0:0] KEY;
	input [2:0] SW;
	output [7:0] LED;
	input ADC_SDAT;
	output ADC_SCLK, ADC_CS_N, ADC_SADDR;
	output wire hsync;
	output wire vsync;
	output wire [2:0] rgb;

	//Assignments
	wire [11:0] values [7:0];
	wire video_on;
	wire pixel_tick;
	wire pix_x;
	wire pix_y;
	reg [2:0] rgb_reg, rgb_next;
	reg [14:0] write_addr; //Write address of dual port ram
	reg [14:0] read_addr; //read address of dual port ram
	wire [11:0] output_a; //Output at port a
	wire [11:0] output_b; //Output at port b
	reg [11:0] reg_check;
	wire do_write; //To check if ADC has spitted out value

	//Instantiating modules
	adc ADC (.CLOCK (CLOCK_50),.RESET (!KEY[0]),.ADC_SCLK (ADC_SCLK),.ADC_CS_N (ADC_CS_N),.ADC_SDAT (ADC_SDAT),.ADC_SADDR (ADC_SADDR),.CH0 (values[0]),.CH1 (values[1]),.CH2 (values[2]),.CH3 (values[3]),.CH4 (values[4]),.CH5 (values[5]),.CH6 (values[6]),.CH7 (values[7]));
	sync vga (.clk(CLOCK_50), .reset(!KEY[0]), .h_sync(hsync), .v_sync(vsync), .video_on(video_on), .p_tick(pixel_tick), .pixel_x(pix_x), .pixel_y(pix_y));
	dualport du(.clock(ADC_SCLK), .addr_a(write_addr), .addr_b(read_addr), .we_a(do_write), .we_b(1'b0), .in_a(values[0]), .in_b(values[0]), .out_a(output_a), .out_b(output_b));

	//Assign statements
	assign LED=values[0][11:4];
	//assign rgb=(video_on)?values[0][11:9]:3'b000;
	assign  rgb = rgb_reg;
	assign  do_write = (reg_check !== values[0]);
	
	//Always block
	always @(posedge CLOCK_50)
		reg_check <= values[0];

	always @(posedge CLOCK_50) 
		if(do_write)
			write_addr <= write_addr + 1;

	always @(posedge CLOCK_50)
		if(do_write) 
			read_addr <= read_addr + 1;

	always @(posedge CLOCK_50 )
		if (pixel_tick)
			rgb_reg<=rgb_next;

	always @(*)
	begin
		if(~video_on)
			rgb_next = 3'b000;
		else if(obs_on7)
			rgb_next = rgb_obs7;
		else
			rgb_next = 3'b000;
	end

endmodule