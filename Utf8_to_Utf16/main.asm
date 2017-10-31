; Template 32-bit
.686
.model flat

extern	_MessageBoxW@16	:	PROC
extern	_ExitProcess@4	:	PROC
public	_main

.data
	utf8_text	db	50H, 6FH, 0C5H, 82H, 0C4H, 85H, 63H, 7AH, 65H, 6EH, 69H, 65H, 20H			
				db	7AH, 6FH, 73H, 74H, 61H, 0C5H, 82H, 6FH, 20H, 6EH, 61H, 77H, 69H			
				db	0C4H, 85H, 7AH, 61H, 6EH, 65H, 2EH			
				db	0E2H, 91H, 0A4H
				db	0f0h, 09fh, 090h, 095h, 0
					

	utf16_text	dw	120 dup(?)
	utf16_title	dw	'T', 'i', 't', 'l', 'e', ' ', 'u', 't', 'f', '-', '1', '6'
.code
	_main PROC
		mov		edi, 0
		mov		ecx, OFFSET utf16_text - OFFSET utf8_text
		mov		edx, 0

	converter:
		mov		eax, 0
		mov		ebx, 0
		mov		al,	utf8_text[edi]
		cmp		eax, 7Fh
		ja		more_than_one_byte
		mov		ah, 0
		mov		utf16_text[edx], ax
		jmp		next

	more_than_one_byte:
		shl		eax, 8
		inc		edi
		mov		al, utf8_text[edi]
		dec		ecx
		bt		ax, 13
		jc		more_than_two_bytes
		shl		al, 2
		shl		ax, 3
		shr		ax, 5
		mov		utf16_text[edx], ax
		jmp		next

	more_than_two_bytes:
		shl		eax, 8
		inc		edi
		mov		al, utf8_text[edi]
		dec		ecx
		bt		eax, 20
		jc		more_than_three_bytes
		shl		al, 2
		shl		ax, 2
		shl		eax, 12
		shr		eax, 16
		mov		utf16_text[edx], ax
		jmp		next

	more_than_three_bytes:
		shl		eax, 8
		inc		edi
		mov		al, utf8_text[edi]
		dec		ecx
		mov		ebx, eax
		shr		ebx, 16
		shl		bl, 2
		shl		bx, 5
		shr		bx, 7
		shl		ebx, 16
		mov		bx, ax
		shl		bl, 2
		shl		bx, 2
		shr		ebx, 4
		mov		eax, ebx
		sub		eax, 10000h
		shl		eax, 6
		shr		ax, 6
		mov		bx, ax
		shr		eax, 16
		add		ax, 0d800h
		add		bx, 0dc00h
		mov		utf16_text[edx], ax
		add		edx, 2
		mov		utf16_text[edx], bx
		jmp		next

	next:
		add		edx, 2
		inc		edi
		dec		ecx
		jnz		converter

		push	0
		push	OFFSET utf16_title
		push	OFFSET utf16_text
		push	0
		call	_MessageBoxW@16


		push	0
		call	_ExitProcess@4
	_main ENDP
END