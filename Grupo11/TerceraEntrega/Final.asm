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
_0b10                           	DD	2
_0                              	DD	0
_actual_mayor_a_2_y_dist_a_0    	DB	"actual mayor a 2 y dist a ",'$', 27 dup (?)
@STDOUT                         	DB	",'$',  dup (?)
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

fild _2
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
PutString _actual mayor a 2 y dist a 0
newLine 1
JMP endif1
else1:
fild _58
fld actual
fcom
fstsw ax
sahf
JNB endif2
startIf2:
PutString _no es mayor que 2
newLine 1
endif2:
endif1:

liberar:
	ffree
	mov ax, 4c00h
	int 21h

;FIN DEL PROGRAMA DE USUARIO

end