`timescale 1us / 1us
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:07:01 03/11/2015 
// Design Name: 
// Module Name:    mod_m_counter 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mod_m_counter #(parameter N = 4 , M = 10)
(
input wire clk, reset,
output wire max_tick,
output wire [N-1:0] q
);

	reg [N-1:0] r_reg;
	wire [N-1:0] r_next;
	
	initial r_reg = 0; //Para intentar sacar un warning pero no lo saco.

	always @ ( posedge clk , posedge reset )
		if(reset)
			r_reg <= 0;
		else
			r_reg <= r_next;

	assign r_next = (r_reg==(M-1)) ? 1'b0 : r_reg + 1'b1;
	assign q = r_reg;
	assign max_tick = (r_reg==(M-1)) ? 1'b1 : 1'b0;
endmodule

