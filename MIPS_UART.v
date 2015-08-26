`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:56:43 07/28/2015 
// Design Name: 
// Module Name:    MIPS_UART 
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
`include "modulos/definiciones.vh"

//`define	DEBUG 1415 //+1

module MIPS_UART(
									input clock,
									input rx,
									output tx,
									output [7:0]led 
    );

//wire clk, clk2;
//wire reset;
//wire enable_clk;

//wire read, write, empty, full;
//wire [7:0] transmitir, recibido;

wire enable;
wire [5:0] PC_plus_1;
wire [`DEBUG:0] debug_signal;

assign led=debug_signal[`DEBUG:`DEBUG-7];
/*
clock_mult instance_name
   (// Clock in ports
    .CLK_IN1(clock),      // IN
    // Clock out ports
    .CLK_OUT1(CLK_OUT1),     // OUT 100
    .CLK_OUT2(clk),     // OUT 50
    .CLK_OUT3(CLK_OUT3),     // OUT 25
    .CLK_OUT4(CLK_OUT4),    		  // OUT 10 
    .CLK_OUT5(CLK_OUT5),     // OUT  5
    .CLK_OUT6(CLK_OUT6),     // OUT  3
    // Status and control signals
    .RESET(RESET),// IN
    .LOCKED(LOCKED));      // OUT
*/	
	
clockReductor clockReductor(
												 .CLK_IN1(clock),
												 .CLK_OUT1(clk),
												 .CLK_OUT2(clkX2)
												 );
												 
/*clock_reductor clock_reductor(
														.CLK_IN1(clock), 
														.CLK_OUT1(clk)
														);*/
													 
UART uart(
					//.clk(clock),
					.clk(clk),
					//.rd(read),
					//.wr(write),
					//.w_data(transmitir),
					.rx(rx),
					.debug_signal(debug_signal),
					//.PC_plus_1(PC_plus_1),
					.enable(enable),
					.tx(tx)
					//.r_data(recibido),
					//.rx_empty(empty),
					//.tx_full(full)
					);

MIPS_DLX MIPS (
							 //.clock(clock),
							 .clock(clk),
							 .enable(enable),
							 .zero(zero),
							 .debug_signal(debug_signal)
							 //.PC_plus_1(PC_plus_1)
							 );

endmodule