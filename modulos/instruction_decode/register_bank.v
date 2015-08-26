`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:53:51 03/30/2015 
// Design Name: 
// Module Name:    register_bank 
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
module register_bank(input reg_write,
							input clock,
							input [4:0] ra,
							input [4:0] rb,
							input [4:0] rw, //Si es cero lee los registros ra y rb, si es distinto de cero guarda en rw el dato de busw
							input [31:0] busw,
							output [31:0] bus_a,
							output [31:0] bus_b,
							output [1023:0]registros
    );
	 
reg [31:0] registro[0:31];
integer i;
 
initial 
	begin
		registro[0]<=0;
		for (i = 1; i < 32; i = i+1) //No se toma el cero porque segun el Negro el registro cero tiene que ir conectado a tierra para que sea cero.
			registro[i] <= i;
	end

assign bus_a = registro[ra];
assign bus_b = registro[rb];

assign registros=({registro [ 31 ] , registro [ 30 ] , registro [ 29 ] , registro [ 28 ] , registro [ 27 ] , registro [ 26 ] , registro [ 25 ] , registro [ 24 ] , registro [ 23 ] , registro [ 22 ] , registro [ 21 ] , registro [ 20 ] , registro [ 19 ] , registro [ 18 ] , registro [ 17 ] , registro [ 16 ] , registro [ 15 ] , registro [ 14 ] , registro [ 13 ] , registro [ 12 ] , registro [ 11 ] , registro [ 10 ] , registro [ 9 ] , registro [ 8 ] , registro [ 7 ] , registro [ 6 ] , registro [ 5 ] , registro [ 4 ] , registro [ 3 ] , registro [ 2 ] , registro [ 1 ] , registro [ 0 ] });
//always @(reg_write)
//	begin
//		if(reg_write)
//			begin
//				registro[rw] = busw;
//			end
//		else
//			begin
//				registro[rw] = registro[rw];
//			end
//	end
always @(negedge clock)//--> Preguntarle al renzo porq quitando el posedge tira latches para cada uno de los bits de los regitros del banco de registro.
	begin
		if(reg_write == 1)
			registro[rw] <= busw;
		else
			registro[rw] <= registro[rw];
	end

endmodule
