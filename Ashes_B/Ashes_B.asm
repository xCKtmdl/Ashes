CODE SEGMENT

ASSUME CS:CODE

STACK_P PROC 

	cli

	xor	AX,AX
	mov	SS,AX
	mov	SP,7c00h

	sti

STACK_P ENDP

DATA	PROC

	mov	ax,7c00h
	mov	ds,ax

	ASSUME DS:CODE

DATA	ENDP

Message	PROC

	lea	SI, Msg_1
	call	Display_Text

Message	ENDP

LOAD_Ashes	PROC

	mov	ax,0h
	mov	es,ax
	mov	bx,1000h
	mov	ah,2
	mov	al,3
	mov	dx,0h
	mov	ch,0h
	mov	cl,3h
	int	13h

LOAD_Ashes	ENDP

FINAL	PROC	

	mov	cx,1000h
	jmp	cx

FINAL	ENDP

Display_Text	PROC

	mov	al,[si]
	cmp	al,0h
	je	Exit_D
	mov	ah,0Eh
	mov	bx,0h
	int	10h
	inc	si
	jmp	Display_Text

Display_Text	ENDP

Exit_D	PROC

	RET

Exit_D	ENDP

;------------------------------------

Msg_1	DB	'Bootstrap routine for Ashes',0ah,0dh,00h

CODE	ENDS

END	STACK_P
	
	

	



	

