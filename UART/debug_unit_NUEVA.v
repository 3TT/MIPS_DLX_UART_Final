`timescale 1us / 1us
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:29:12 03/14/2015 
// Design Name: 
// Module Name:    debug_unit 
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
`include "../modulos/definiciones.vh"

//`define	DEBUG 1415 //+1
//`define NUM_BYTES 177
module debug_unit_NUEVA(
	//Entradas de funcionamiento
	 input top_clk,
	 input wire rx_done_tick,
	 input wire [7:0] rx_bus,
	 input wire tx_done_tick,
	
	//Entradas de datos
	 input [`DEBUG:0] send_data, 
	 
	//Salidas de funcionamiento
	 output reg enable,
	 
	//Salidas de envio
	 output reg tx_start /* synthesis syn_keep = 1 */,
	 output wire [7:0] tx_bus
    );
	 
	 reg [1415:0] buffer = 0 /* synthesis syn_keep = 1 */;
	 reg [7:0] contador = 0;
	 reg [5:0] contador_fin = 0;

   parameter IDLE = 3'b000;
	parameter STEP1 = 3'b001;
	parameter CONT1 = 3'b010;
	parameter CONT2 = 3'b011;
	parameter STEP3 = 3'b100;
	parameter SEND1 = 3'b101;
	parameter SEND2 = 3'b110;
	parameter STEP2 = 3'b111;
	
	reg [2:0] state = IDLE;

	initial
		enable <= 0;

	always@(posedge top_clk) 
		begin
			tx_start <= 0;
			(* PARALLEL_CASE *) case (state)
			IDLE: 
				begin
					if (rx_done_tick) 
						begin
							if (rx_bus == "c") 
								begin
									state <= CONT1;
									contador_fin <= 0;
								end
							if (rx_bus == "s") 
								begin
									state <= STEP1;
								end
						end	
				end
			
			CONT1: 
				begin
					enable <= 1;
					//espero que termine la ejecucin
					//if(send_data[`DEBUG-2:`DEBUG-9] < 45)
					if(contador_fin < 46)
						state <= CONT1;
					else
						state <= CONT2;
					contador_fin <= contador_fin + 1'b1;
				end
			
			CONT2: 
				begin
					enable <= 0;		
					buffer <= send_data;
					contador <= `NUM_BYTES;
					state <= SEND1;
				end
			
			STEP1: 
				begin
					enable <= 1;
					state <= STEP2;
				end			
			
			STEP2: 
				begin
					enable <= 0;
					state <= STEP3;
				end
			
			STEP3: 
				begin
					contador <= `NUM_BYTES;
					buffer <= send_data;
					state <= SEND1;
				end
			
			SEND1: 
				begin
					tx_start <= 1;
					contador <= contador - 1'b1;
					state <= SEND2;
				end

			SEND2: 
				begin
					if(tx_done_tick)
						begin
							if(contador > 0) 
								begin
									buffer <= buffer >> 8;	
									tx_start <= 1;
									contador <= contador - 1'b1;
								end
							else 
								begin
									state <= IDLE;
								end
						end
					end
				
		endcase
	end

   assign tx_bus = buffer [7:0];

endmodule
