[org 0x7c00]
jmp start

global create_new_line
create_new_line:
	xor cx, cx

	.lp1:
		call backspace

		inc cx
		cmp cx, cursor_current_coords[0]
		jle .lp1
	
	xor cx, cx
	mov [cursor_current_coords+0], cx
	ret

update_start_coords:
	mov ah, 3 ; get current pos
	int 10h
	mov [cursor_start_coords+0], dl
	mov [cursor_start_coords+1], dh
	ret

update_current_coords:
	mov ah, 3 ; get current pos
	int 10h
	mov [cursor_current_coords+0], dl
	mov [cursor_current_coords+1], dh
	ret

backspace:
	mov al, 0x08
	int 0x10
	mov al, 0x20
	int 0x10
	mov al, 0x08
	int 0x10
	ret

set_cursor:
	mov ah, 0x02
	mov bh, 0

	mov [cursor_current_coords+0], dl
	mov [cursor_current_coords+1], dh

	int 0x10
	ret

pchar:
	cmp al, 0x08
	je .isBackspace
	jmp .else1

	;push cx
	.isBackspace:
		mov cx, cursor_current_coords[0]
		dec cx
		mov [cursor_current_coords+0], cx

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

			mov bx, blank
			call write

			call create_new_line
			jmp .exit

		.else2:
			mov dl, cursor_current_coords[0]
			mov dh, cursor_current_coords[1]

			cmp ah, 0x48  ; up arrow key 
			je .upArrow

			cmp ah, 0x50  ; down arrow key 
			je .downArrow

			cmp ah, 0x4B  ; left arrow key 
			je .leftArrow

			cmp ah, 0x4D  ; right arrow key 
			je .rightArrow

			jmp .other

			.upArrow:
				sub dh, 1
				cmp dh, cursor_start_coords[1]
				jl .exit
				call set_cursor

				jmp .exit
				
			.downArrow:
				add dh, 1
				cmp dh, cursor_start_coords[1]
				jl .exit
				call set_cursor

				jmp .exit

			.leftArrow:
				sub dl, 1
				cmp dl, cursor_start_coords[0]
				jl .exit
				cmp dh, cursor_start_coords[1]
				jl .exit
				call set_cursor

				jmp .exit

			.rightArrow:
				add dl, 1
				cmp dl, cursor_start_coords[0]
				jl .exit
				cmp dh, cursor_start_coords[1]
				jl .exit
				call set_cursor

				jmp .exit

			.other:
				mov cx, cursor_current_coords[0]
				inc cx
				mov [cursor_current_coords+0], cx

				mov ah, 0x0e
				int 0x10
				jmp .exit

	.exit:
	;pop cx
ret

start:

mov bx, string001
call write
mov bx, new_line
call write
call create_new_line
call update_current_coords
call update_start_coords
.lp:
	;mov bx, string002
	;call write

	mov ah, 0
	int 0x16
	call pchar
jmp .lp

jmp $

global cursor_start_coords
global cursor_current_coords

cursor_start_coords: db 1, 1 ; x, y
cursor_current_coords: db 1, 1 ; x, y
blank: db 32, 0
new_line: db 10, 0

string001: db "Hello, world!", 0
string002: db "(debug)", 0
string003_long: db "999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999", 0
string004: db "(left)", 0
string005: db "(right)", 0
string006: db "(up)", 0
string007: db "(down)", 0

%include "inc/sys.inc"
times 510 - ($ - $$) db 0
dw 0xAA55