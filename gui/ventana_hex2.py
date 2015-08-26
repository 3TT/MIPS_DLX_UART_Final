#!/usr/bin/python

from gi.repository import Gtk 
import pygtk
import serial
import sys
   
class Ventana:
	def __init__(self):
		self.builder = Gtk.Builder()
		self.builder.add_from_file('gui.glade')
		self.builder.connect_signals(self)

		self.device = '/dev/ttyUSB0'
		self.baudrate = 9600
		self.bytes = list()
		self.reg = list()

		self.pc = self.builder.get_object("entry1")
		self.npc = self.builder.get_object("entry2")
		self.instruccion = self.builder.get_object("entry3")

		self.cantidadBytes = 0
		self.bytesPc = 0
		self.bytesInstruccion = 0
		self.bytesRegisters = 0
		self.bytesIdEx = 0
		self.bytesExMem = 0
		self.bytesMemWb = 0

		self.reg.append(self.builder.get_object("entry7"))
		self.reg.append(self.builder.get_object("entry8"))
		self.reg.append(self.builder.get_object("entry9"))
		self.reg.append(self.builder.get_object("entry10"))
		self.reg.append(self.builder.get_object("entry11"))
		self.reg.append(self.builder.get_object("entry12"))
		self.reg.append(self.builder.get_object("entry13"))
		self.reg.append(self.builder.get_object("entry14"))
		self.reg.append(self.builder.get_object("entry15"))
		self.reg.append(self.builder.get_object("entry16"))
		self.reg.append(self.builder.get_object("entry17"))
		self.reg.append(self.builder.get_object("entry18"))
		self.reg.append(self.builder.get_object("entry19"))
		self.reg.append(self.builder.get_object("entry20"))
		self.reg.append(self.builder.get_object("entry21"))
		self.reg.append(self.builder.get_object("entry22"))
		self.reg.append(self.builder.get_object("entry23"))
		self.reg.append(self.builder.get_object("entry24"))
		self.reg.append(self.builder.get_object("entry25"))
		self.reg.append(self.builder.get_object("entry26"))
		self.reg.append(self.builder.get_object("entry27"))
		self.reg.append(self.builder.get_object("entry28"))
		self.reg.append(self.builder.get_object("entry29"))
		self.reg.append(self.builder.get_object("entry30"))
		self.reg.append(self.builder.get_object("entry31"))
		self.reg.append(self.builder.get_object("entry32"))
		self.reg.append(self.builder.get_object("entry33"))
		self.reg.append(self.builder.get_object("entry34"))
		self.reg.append(self.builder.get_object("entry35"))
		self.reg.append(self.builder.get_object("entry36"))
		self.reg.append(self.builder.get_object("entry37"))
		self.reg.append(self.builder.get_object("entry38"))
		
		self.memWbMemReadData = self.builder.get_object("entry4")
		self.memWbMuxWbDato0 = self.builder.get_object("entry5")
		self.memWbRegDst = self.builder.get_object("entry6")
		self.memWbMemToReg = self.builder.get_object("entry47")
		self.memWbRegWrite = self.builder.get_object("entry48")

		self.idExOpcode = self.builder.get_object("entry39")
		self.idExRegDst = self.builder.get_object("entry40")
		self.idExAluSrc = self.builder.get_object("entry41")
		self.idExMemWrite = self.builder.get_object("entry42")
		self.idExRegWrite = self.builder.get_object("entry43")
		self.idExMemToReg = self.builder.get_object("entry44")

		self.iterSerial =self.builder.get_object("entry45")
		self.regOut2 = self.builder.get_object("entry62")

		self.idExReadData1 = self.builder.get_object("entry58")
		self.idExReadData2 = self.builder.get_object("entry59")
		self.idExSignE = self.builder.get_object("entry60")
		self.idExFuncion = self.builder.get_object("entry61")
		self.idExRegFileRs = self.builder.get_object("entry63")
		self.idExRegFileRt = self.builder.get_object("entry64")

		self.exMemRegDst = self.builder.get_object("entry65")
		self.exMemRegWrite = self.builder.get_object("entry66")
		self.exMemMemToReg = self.builder.get_object("entry67")
		self.exMemAluOuput = self.builder.get_object("entry68")
		self.exMemReadData2 = self.builder.get_object("entry69")
		self.exMemMemWrite = self.builder.get_object("entry46")

		self.ventanaPrincipal = self.builder.get_object("Pipeline")
		self.ventanaPrincipal.show()
###############################################################################
	def on_Pipeline_destroy(self, object, data=None):
    		Gtk.main_quit()
###############################################################################    		
	def fillGui(self):
		self.setTextNpc()
		self.setTextInstruccion()
		self.setTextReg()
		self.setTextIdEx()
		self.setTextMemWb()
		self.setTextExMem()
###############################################################################
	def setTextNpc(self):
		self.npc.set_text(str(ord(self.bytes[self.cantidadBytes - 1]))) 
###############################################################################
	def setTextInstruccion(self):
		i = self.bytesInstruccion

		instruccion = str(hex(ord(self.bytes[i]))[2:].zfill(2)) + \
									str(hex(ord(self.bytes[i-1]))[2:].zfill(2)) + \
									str(hex(ord(self.bytes[i-2]))[2:].zfill(2)) + \
									str(hex(ord(self.bytes[i-3])))[2:].zfill(2)

		self.instruccion.set_text(instruccion)
###############################################################################
	def setTextReg(self):
		i = self.bytesRegisters
		
		for j in range(31, -1, -1):
			regAux = (ord(self.bytes[i]) << 24)  + \
								(ord(self.bytes[i-1]) << 16)  + \
								(ord(self.bytes[i-2]) << 8)  + \
								ord(self.bytes[i-3])

			self.reg[j].set_text(str(regAux))
			i -= 4
################################################################################
	def setTextIdEx(self):
		i = self.bytesIdEx

		idExOpcode = ord(self.bytes[i])		# 6 bits
		idExRegDst = ord(self.bytes[i-1])	# 5 bits
		idExAluSrc = ord(self.bytes[i-2])	# 1 bit
		idExMemWrite = ord(self.bytes[i-3])	# 1 bit
		idExRegWrite = ord(self.bytes[i-4])	# 5 bits
		idExMemToReg = ord(self.bytes[i-5]) # 1 bit

		idExReadData1 = (ord(self.bytes[i-6]) << 24) + \
													(ord(self.bytes[i-7]) << 16) + \
													(ord(self.bytes[i-8]) << 8) + \
													ord(self.bytes[i-9])

		idExReadData2 = (ord(self.bytes[i-10]) << 24) + \
													(ord(self.bytes[i-11]) << 16) + \
													(ord(self.bytes[i-12]) << 8) + \
													ord(self.bytes[i-13])

		idExSignE = (ord(self.bytes[i-14]) << 24) + \
													(ord(self.bytes[i-15]) << 16) + \
													(ord(self.bytes[i-16]) << 8) + \
													ord(self.bytes[i-17])

		idExFuncion = ord(self.bytes[i-18])	# 6 bits
		idExRegFileRs = ord(self.bytes[i-19]) # 5 bits
		idExRegFileRt = ord(self.bytes[i-20]) # 5 bits

		self.idExOpcode.set_text(str(idExOpcode))
		self.idExRegDst.set_text(str(idExRegDst))
		self.idExAluSrc.set_text(str(idExAluSrc))
		self.idExMemWrite.set_text(str(idExMemWrite))
		self.idExRegWrite.set_text(str(idExRegWrite))
		self.idExMemToReg.set_text(str(idExMemToReg))
		self.idExReadData1.set_text(str(idExReadData1))
		self.idExReadData2.set_text(str(idExReadData2))
		self.idExSignE.set_text(str(idExSignE))
		self.idExFuncion.set_text(str(idExFuncion))
		self.idExRegFileRs.set_text(str(idExRegFileRs))
		self.idExRegFileRt.set_text(str(idExRegFileRt))
################################################################################
	def setTextMemWb(self):
		i = self.bytesMemWb

		memWbMemReadData = (ord(self.bytes[i]) << 24) + \
													(ord(self.bytes[i-1]) << 16) + \
													(ord(self.bytes[i-2]) << 8) + \
													ord(self.bytes[i-3])

		memWbMuxWbDato0 = (ord(self.bytes[i-4]) << 24) + \
													(ord(self.bytes[i-5]) << 16) + \
													(ord(self.bytes[i-6]) << 8) + \
													ord(self.bytes[i-7])
		
		memWbRegDst = ord(self.bytes[i-8])
		memWbMemToReg = ord(self.bytes[i-9])
		memWbRegWrite = ord(self.bytes[i-10])

		self.memWbMemReadData.set_text(str(memWbMemReadData))
		self.memWbMuxWbDato0.set_text(str(memWbMuxWbDato0))
		self.memWbRegDst.set_text(str(memWbRegDst))
		self.memWbMemToReg.set_text(str(memWbMemToReg))
		self.memWbRegWrite.set_text(str(memWbRegWrite))
################################################################################
	def setTextExMem(self):
			i = self.bytesExMem

			exMemRegDst = ord(self.bytes[i])
			exMemRegWrite = ord(self.bytes[i-1])
			exMemMemToReg = ord(self.bytes[i-2])

			exMemAluOuput = (ord(self.bytes[i-3]) << 24) + \
													(ord(self.bytes[i-4]) << 16) + \
													(ord(self.bytes[i-5]) << 8) + \
													ord(self.bytes[i-6])

			exMemReadData2 = (ord(self.bytes[i-7]) << 24) + \
													(ord(self.bytes[i-8]) << 16) + \
													(ord(self.bytes[i-9]) << 8) + \
													ord(self.bytes[i-10])

			exMemMemWrite = ord(self.bytes[i-11])

			self.exMemRegDst.set_text(str(exMemRegDst))
			self.exMemRegWrite.set_text(str(exMemRegWrite))
			self.exMemMemToReg.set_text(str(exMemMemToReg))
			self.exMemAluOuput.set_text(str(exMemAluOuput))
			self.exMemReadData2.set_text(str(exMemReadData2))
			self.exMemMemWrite.set_text(str(exMemMemWrite))
###############################################################################
	def on_paso_clicked(self, widget):		
		self.bytes = []

		tx_done_pc = 1 						#
		tx_done_instruccion = 4		# 1 registro de 4 bytes
		tx_done_register = 128		# 32 registros de 4 bytes
		tx_done_idEx = 21					# 3 registros de 4 bytes + 9 de 1 byte
		tx_done_memWb = 11 				# 2 registros de 4 bytes + 3 de 1 byte
		tx_done_exMem = 12 				# 2 registros de 4 bytes + 4 de 1 byte
		
		self.cantidadBytes = 	tx_done_pc + \
					tx_done_instruccion + \
					tx_done_register + \
					tx_done_idEx + \
					tx_done_memWb + \
					tx_done_exMem

		self.bytesPc = self.cantidadBytes - 1
		self.bytesInstruccion = self.bytesPc - tx_done_pc
		self.bytesRegisters = self.bytesInstruccion - tx_done_instruccion
		self.bytesIdEx = self.bytesRegisters - tx_done_register
		self.bytesMemWb = self.bytesIdEx - tx_done_idEx
		self.bytesExMem = self.bytesMemWb - tx_done_memWb

		error = 0
		
		try:
			s = serial.Serial(self.device, self.baudrate)
			s.write('s')

			tx_done = self.cantidadBytes

			while tx_done > 0:
				try:            
					line = s.read()
					self.bytes.append(line)
					tx_done -= 1
				except:
					error = 1
					break

			s.close()
		except:
			print "Error: " + str(self.device) + " - " + str(self.baudrate)
		
		if error == 0:
			self.fillGui()
###############################################################################
	def on_continuo_clicked(self, widget):
		self.bytes = []

		tx_done_pc = 1 						#
		tx_done_instruccion = 4		# 1 registro de 4 bytes
		tx_done_register = 128		# 32 registros de 4 bytes
		tx_done_idEx = 21					# 3 registros de 4 bytes + 9 de 1 byte
		tx_done_memWb = 11 				# 2 registros de 4 bytes + 3 de 1 byte
		tx_done_exMem = 12 				# 2 registros de 4 bytes + 4 de 1 byte
		
		self.cantidadBytes = 	tx_done_pc + \
					tx_done_instruccion + \
					tx_done_register + \
					tx_done_idEx + \
					tx_done_memWb + \
					tx_done_exMem

		self.bytesPc = self.cantidadBytes - 1
		self.bytesInstruccion = self.bytesPc - tx_done_pc
		self.bytesRegisters = self.bytesInstruccion - tx_done_instruccion
		self.bytesIdEx = self.bytesRegisters - tx_done_register
		self.bytesMemWb = self.bytesIdEx - tx_done_idEx
		self.bytesExMem = self.bytesMemWb - tx_done_memWb

		error = 0
		
		try:
			s = serial.Serial(self.device, self.baudrate)
			s.write('c')

			tx_done = self.cantidadBytes

			while tx_done > 0:
				try:            
					line = s.read()
					self.bytes.append(line)
					tx_done -= 1
				except:
					error = 1
					break

			s.close()
		except:
			print "Error: " + str(self.device) + " - " + str(self.baudrate)
		
		if error == 0:
			self.fillGui()
###############################################################################
if __name__ == "__main__":
        main = Ventana()
        Gtk.main()
