module dualport
#(
	parameter addr_width = 15,
			  data_width = 12
);
(input wire clock,
 input wire [addr_width-1:0] addr_a, addr_b,
 input wire we_a, we_b,
 input wire [data_width-1:0] in_a, in_b,
 output reg [data_width-1:0] out_a, out_b
 );

    //memory
    reg [data_width-1:0] ram [0:2**addr_width-1];

    always @(posedge clock)
    begin
        if(we_a)
        begin
            ram[addr_a] <= in_a;
            out_a <= in_a;
        end
        else
            out_a <= ram[addr_a];
    end

    always @(posedge clock)
    begin
        if(we_b)
        begin
            ram[addr_b] <= in_b;
            out_b <= in_b;
        end
        else
            out_b <= ram[addr_b];
    end
endmodule