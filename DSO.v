module DSO(CLOCK_50, KEY, SW, LED, ADC_SCLK, ADC_CS_N, ADC_SDAT, ADC_SADDR, hsync, vsync, rgb);
	input CLOCK_50;
	input [0:0] KEY;
	input [2:0] SW;
	output [7:0] LED;
	input ADC_SDAT;
	output ADC_SCLK, ADC_CS_N, ADC_SADDR;
	//Assignments
	wire [11:0] values [7:0];
	output wire hsync;
	output wire vsync;
	output wire [2:0] rgb;
	wire video_on;
	wire pixel_tick;
	wire pixel_x;
	wire pixel_y;

	//assign LED = values [SW] [11:4];
	adc ADC (.CLOCK (CLOCK_50),.RESET (!KEY[0]),.ADC_SCLK (ADC_SCLK),.ADC_CS_N (ADC_CS_N),.ADC_SDAT (ADC_SDAT),.ADC_SADDR (ADC_SADDR),.CH0 (values[0]),.CH1 (values[1]),.CH2 (values[2]),.CH3 (values[3]),.CH4 (values[4]),.CH5 (values[5]),.CH6 (values[6]),.CH7 (values[7]));
	sync vga (.clk(CLOCK_50), .reset(!KEY[0]), .h_sync(hsync), .v_sync(vsync), .video_on(video_on));
	assign LED=values[0][11:4];
	assign rgb=(video_on)?values[0][11:9]:3'b000;
endmodule