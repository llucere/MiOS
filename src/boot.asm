[org 0x7c00]
jmp start

backspace:
	mov al, 0x08
	int 0x10
	mov al, 0x20
	int 0x10
	mov al, 0x08
	int 0x10
	ret

pchar:
	cmp al, 0x08
	je .isBackspace
	jmp .else1

	.isBackspace:
		dec byte[cursor_position]
		mov ah, 0x0e
		call backspace
		jmp .exit

	.else1:
		cmp al, 0xA
		je .isEnter
		cmp al, 0xD
		je .isEnter

		jmp .else2

		.isEnter:
		mov bx, new_line
		call write
		

		mov bx, cursor_position
		.lp1:
			call backspace
			dec bx

			cmp bx, 0
			jle .lp1

		mov byte[cursor_position], 0
		
		jmp .exit

		.else2:
		inc byte[cursor_position]
		mov ah, 0x0e
		int 0x10
		jmp .exit

	.exit:
ret

start:

;mov bx, string001
;call write

.lp:
	;mov bx, string002
	;call write

	mov ah, 0
	int 0x16
	call pchar
jmp .lp

jmp $

cursor_position: db 0
new_line: db "", 10, 0
string001: db "Hello, world!", 0
string002: db "(debug)", 0

%include "inc/sys.inc"
times 510 - ($ - $$) db 0
dw 0xAA55