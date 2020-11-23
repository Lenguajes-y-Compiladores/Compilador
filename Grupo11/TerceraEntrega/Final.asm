include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

MAXTEXTSIZE equ 100

.DATA

contador                        	DD	
promedio                        	DD	
actual                          	DD	
suma                            	DD	
_Prueba_txt_LyC_Tema_1!         	DB	"Prueba.txt LyC Tema 1",'$', 22 dup (?)
@STDOUT@STDOUT                  	DD	
_Ingrese_entero_para_actual:_   	DB	"Ingrese entero para actual:",'$', 28 dup (?)
@STDIN@STDIN                    	DD	
_0                              	DD	0
_02_5                           	DD	02.5
_0xA2B0                         	DD	41648
_92                             	DD	92
_1                              	DD	1
_0_342                          	DD	0.342
_256                            	DD	256
@CONT@CONT                      	DD	
_0b10                           	DD	2
_52                             	DD	52
_4                              	DD	4
_La_suma_es:_                   	DB	"La suma es:",'$', 12 dup (?)
_actual_mayor_a_2_y_dist_a_0    	DB	"actual mayor a 2 y dist a ",'$', 27 dup (?)
_0b111010                       	DD	58
_no_es_mayor_que_2              	DB	"no es mayor que ",'$', 17 dup (?)

.CODE

strlen proc
	mov bx, 0
	strl01:
	cmp BYTE PTR [si+bx],'$'
	je strend
	inc bx
	jmp strl01
	strend:
	ret
strlen endp

copiar proc
	call strlen
	cmp bx , MAXTEXTSIZE
	jle copiarSizeOk
	mov bx , MAXTEXTSIZE
	copiarSizeOk:
	mov cx , bx
	cld
	rep movsb
	mov al , '$'
	mov byte ptr[di],al
	ret
copiar endp

concat proc
	push ds
	push si
	call strlen
	mov dx , bx
	mov si , di
	push es
	pop ds
	call strlen
	add di, bx
	add bx, dx
	cmp bx , MAXTEXTSIZE
	jg concatSizeMal
	concatSizeOk:
	mov cx , dx
	jmp concatSigo
	concatSizeMal:
	sub bx , MAXTEXTSIZE
	sub dx , bx
	mov cx , dx
	concatSigo:
	push ds
	pop es
	pop si
	pop ds
	cld
	rep movsb
	mov al , '$'
	mov byte ptr[di],al
	ret
concat endp

MOV AX,@DATA
MOV DS,AX
MOV es,ax
FINIT
FFREE


liberar:
	ffree
	mov ax, 4c00h
	int 21h

;FIN DEL PROGRAMA DE USUARIO

end