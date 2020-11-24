include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

MAXTEXTSIZE equ 100

.DATA

contador                        	DD	?
promedio                        	DD	?
actual                          	DD	?
suma                            	DD	?
_Prueba_txt_LyC_Tema_1_         	DB	"Prueba.txt LyC Tema 1",'$', 22 dup (?)
@STDOUT                         	DD	?
_Ingrese_entero_para_actual     	DB	"Ingrese entero para actua",'$', 26 dup (?)
@STDIN                          	DD	?
_0                              	DD	0
_02_5                           	DD	02.5
_0xA2B0                         	DD	41648
_92                             	DD	92
_1                              	DD	1
_La_suma_es_                    	DB	"La suma es",'$', 11 dup (?)
_0b10                           	DD	2
_actual_mayor_a_2_y_dist_a_0    	DB	"actual mayor a 2 y dist a ",'$', 27 dup (?)
_0b111010                       	DD	58
_no_es_mayor_que_2              	DB	"no es mayor que ",'$', 17 dup (?)
@aux1                           	DD	?
@aux2                           	DD	?
@aux3                           	DD	?

.CODE

START:
MOV AX,@DATA
MOV DS,AX
MOV es,ax
FINIT
FFREE

DisplayString _Prueba_txt_LyC_Tema_1_
newLine 1
DisplayString _Ingrese_entero_para_actual
newLine 1
GetFloat actual
fild _0
fistp contador
fld _02_5
fild _0xA2B0
fadd
fstp @aux1
fld @aux1
fstp suma
condicionWhile1:
fild _92
fild contador
fcom
fstsw ax
sahf
JNBE endwhile1
startWhile1:
fild contador
fild _1
fadd
fstp @aux2
fld @aux2
fistp contador
fld suma
fld actual
fadd
fstp @aux3
fld @aux3
fstp suma
JMP condicionWhile1
endwhile1:
DisplayString _La_suma_es_
newLine 1
DisplayFloat suma,2
newLine 1
fild _0b10
fld actual
fcom
fstsw ax
sahf
JNA else1
fild _0
fld actual
fcom
fstsw ax
sahf
JE else1
startIf1:
DisplayString _actual_mayor_a_2_y_dist_a_0
newLine 1
JMP endif1
else1:
fild _0b111010
fld actual
fcom
fstsw ax
sahf
JNB endif2
startIf2:
DisplayString _no_es_mayor_que_2
newLine 1
endif2:
endif1:

liberar:
	ffree
	mov ax, 4c00h
	int 21h

;FIN DEL PROGRAMA DE USUARIO

end