[org 0x7c00]

read:

write:
	mov ah, 0x0e ; turn on teletype mode
	.lp:
		mov al, [bx] 	; set al to the first char of ax
		cmp al, 0	; compare al with 0
		je .lpexit	; jump to lpexit if al == 0

		inc bx		; increment ax (e.g. changes "Hello, world!" to "ello, world!")
		int 0x10	; bios call to render the char
		jmp .lp		; loop
	.lpexit:

	ret