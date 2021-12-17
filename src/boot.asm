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

	;push cx
	xor cx, cx
	.isBackspace:
		mov cx, cursor_position
		dec cx
		mov [cursor_position], cx

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
			.lp1:
				call backspace
				dec cx

				cmp cx, 0
				jl .lp1

			mov [cursor_position], cx
			jmp .exit

		.else2:
			mov cx, cursor_position
			inc cx
			mov [cursor_position], cx

			mov ah, 0x0e
			int 0x10
			jmp .exit

	.exit:
	;pop cx
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