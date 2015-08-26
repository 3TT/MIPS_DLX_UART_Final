`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:01:14 07/22/2015 
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
`define D_BIT 7 //Por ser de 0 a 7 son 8 bits.
`define	DEBUG 321 //+1
`define NUM_BYTES 40

module debug_unit(
										input clk,
										input [`D_BIT:0] rx_dato_out, //Recibido desde RX
										input rx_done,
										input tx_done,
										input [`DEBUG:0] debug_signal,
										//nput [9:0] PC_plus_1,
										output reg enable,
										output reg [`D_BIT:0] tx_dato_in, //Enviado a TX
										//output wire [`D_BIT:0] tx_dato_in, //Enviado a TX
										output reg tx_start
										);

localparam [3:0]		IDLE = 4'b0000,
									CONT1 = 4'b0001,
									CONT2 = 4'b0010,
									STEP1 = 4'b0011,
									STEP2 = 4'b0100,
									STEP3 = 4'b0101,
									SEND1 = 4'b0110,
									SEND2 = 4'b0111,
									DECODE = 4'b1000,
									SEND3 = 4'b1001;								


reg [`DEBUG:0] buffer;
reg [7:0] contador;
reg [7:0] contador_instruc;
reg [3:0] estado_actual;
reg [7:0] rx_dato_aux;
//assign rx_dato_aux=rx_dato_out;
initial
	begin
		tx_start <= 0;
		tx_dato_in <= 0;
		enable <= 0;
		buffer <= 0;
		contador <= 0;
		contador_instruc <= 0;
		estado_actual <= IDLE;
	end
						  
always @ (posedge clk)
case(estado_actual)
			IDLE:
				begin
				rx_dato_aux=rx_dato_out;
					if(rx_done == 1)
						begin
							estado_actual = CONT1; //Se cambia de estado.
						end
					else
						begin
							estado_actual = IDLE; //Mantiene el estado. 
						end
				end
			CONT1:
				begin					
					//if(rx_done == 0)	//¿PORQUE SI SE SACA ESTE IF TIRA CUALQUIER COSA?
							//begin

								/*begin
									tx_dato_in = rx_dato_out;
									tx_start = 1;
									estado_actual = SEND1;
								end*/

									if(rx_dato_aux == "s")
										begin
											//tx_dato_in = "p";
											//tx_start = 1;
											estado_actual = STEP1;
										end
									else if(rx_dato_aux == "c")
										begin
											//tx_dato_in = "0";
											//tx_start = 1;
											estado_actual = STEP1;
										end
							else 
									begin
										estado_actual = STEP1;
									end
					/*	
						end
					else
							estado_actual = IDLE;
							*/
				end
			STEP1:
				begin
				enable =1;
				estado_actual = STEP2;
				end
			STEP2:
				begin
				enable = 0;
				tx_dato_in = debug_signal[`DEBUG-2:`DEBUG-9];
				estado_actual = SEND1;
				tx_start = 1;
				end	
			SEND1:
				begin
					if(tx_done == 1)
						begin
							tx_start = 0;
							estado_actual = IDLE;
						end
					else 
						begin
							estado_actual = SEND1;
						end
				end
			default:
				begin
					estado_actual = IDLE;
				end
		endcase

/*
	always@(posedge clk) 
		begin
			//tx_start <= 0;
			case (estado_actual)
			IDLE:
				begin
					tx_start <= 0;
					if(rx_done == 1)
						begin
							estado_actual <= DECODE; //Se cambia de estado.
						end
					else
						begin
							estado_actual <= IDLE; //Mantiene el estado. 
						end
				end
			DECODE:
				begin					
					if(rx_done == 0)	//¿PORQUE SI SE SACA ESTE IF TIRA CUALQUIER COSA?
						begin

*/

							/*begin
								tx_dato_in = rx_dato_out;
								tx_start = 1;
								estado_actual = SEND1;
							end*/

/*

						if(rx_dato_out == "c")
							begin
								//buffer <= "p";
								//tx_start <= 1;
								//contador <= 1;
								estado_actual <= CONT1;
							end
						else if(rx_dato_out == "s")
							begin
								//buffer <= "0";
								//tx_start <= 1;
								//contador <= 1;
								estado_actual <= STEP1;
							end
						else 
								begin
									estado_actual <= IDLE;
								end
					end
				end
			
			CONT1: 
				begin
					enable <= 1;
	*/
					//Se espera a terminar la ejecucion
					/*if(debug_signal[`DEBUG:`DEBUG-9] < 62)
						estado_actual <= CONT1;
					else
						estado_actual <= CONT2;*/
	/*				if(contador_instruc > 0)
						begin
							estado_actual <= CONT1;
							contador_instruc <= 1'b1;
						end
					else
						begin
							estado_actual <= CONT2;
							contador_instruc <= 0;
						end
				end
			
			CONT2: 
				begin
					enable <= 0;		
					buffer <= debug_signal;
					contador <= `NUM_BYTES;	//Da 40,25 envios, pero creo que lo unico que perderiamos son los dos bits mas significativos del PC...
					estado_actual <= SEND1;
				end
			
			STEP1: 
				begin
					enable <= 1;
					estado_actual <= STEP2;
				end			
			
			STEP2: 
				begin
					enable <= 0;
					estado_actual <= STEP3;
				end
			
			STEP3: 
				begin
					contador <= `NUM_BYTES;
					buffer <= debug_signal;
					estado_actual <= SEND1;
				end
			
			SEND1: 
				begin
					tx_start <= 1;
					contador <= contador - 1'b1;
					estado_actual <= SEND2;
				end
				
			SEND2: 
				begin
					if(tx_done == 1)
						begin
							tx_start <= 0;
							estado_actual <= SEND3;
						end
					else 
						begin
							estado_actual <= SEND2;
					end
*/	
	/*tx_start <= 1;
					contador <= contador - 1'b1;
					estado_actual <= SEND2;*/
	/*			end

			SEND3: 
				begin
		*/			//tx_start <= 0;
					/*if(tx_done)
						begin*/
			/*				if(contador > 0) 
								begin
									buffer <= buffer >> 8;	
									tx_start <= 1;
									contador <= contador - 1'b1;
									estado_actual <= SEND2;
								end
							else 
								begin
									estado_actual <= IDLE;
								end
						//end
					end
				
		endcase
	end

   assign tx_dato_in = buffer [7:0];
*/

endmodule
