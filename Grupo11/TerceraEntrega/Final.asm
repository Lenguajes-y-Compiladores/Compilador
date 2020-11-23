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
_02_5                           	DD	02.5
_3                              	DD	3

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

fld _02.5
fild _3
fadd
fstp @aux1
fld @aux1
fstp suma

liberar:
	ffree
	mov ax, 4c00h
	int 21h

;FIN DEL PROGRAMA DE USUARIO

end