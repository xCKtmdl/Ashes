;KERNEL and Data segment setup
;******************************************************************
CODE SEGMENT

	ASSUME CS:CODE

STACK_SET PROC

	mov	sp,1000h
	
STACK_SET ENDP

KERNEL_DS_SET PROC

	mov	ax,100h
	mov	ds,ax
	ASSUME DS:CODE

KERNEL_DS_SET ENDP

;******************************************************************


;Setup interupt 60h so that programs can safely return to Ashes
;******************************************************************
INSTALL_INT_60H PROC

	mov	ax,0
	mov	es,ax
	mov	di,180h

	cli

	cld
	mov	ax,1000h
	stosw
	mov	ax,0
	stosw

	sti

INSTALL_INT_60H ENDP
;******************************************************************


;Command Processor
;******************************************************************
COMMAND_P PROC

	lea	si,MESS_COM
	call	Display_Text
	mov	ah,1h
	int	21h
	cmp	al,'1'
	jne	COMMAND_P
	jmp	command1

COMMAND_P ENDP

;******************************************************************

;System Hardware (Command 1)
;******************************************************************

command1 PROC

	call	EQUIP
	add	ah,30h
	mov	BYTE PTR DS:PRNS,ah
	add	al,30h
	mov	BYTE PTR DS:S_PORTS,al
	add	bh,30h
	mov	BYTE PTR DS:DSKTS,bh
	add	bl,30h
	mov	BYTE PTR DS:CORPO,bl
	add	ch,30h
	mov	BYTE PTR DS:MOUSE,ch

	lea	si,equips
	call	Display_Text
	jmp	COMMAND_P

command1	ENDP

EQUIP	PROC

	int	11h
	mov	dx,ax
	push	dx

;**************************
;                         *
;Test for printers	  *
;		 	  *
;**************************

	and	dh,11000000b
	mov	cl,6
	shr	dh,cl
	mov	ah,dh
	pop	dx

;**************************
;                         *
;Test for serial ports	  *
;		 	  *
;**************************

	and	dh,00001110b
	shr	dh,1
	mov	al,dh

;**************************
;                         *
;Test for diskettes	  *
;		 	  *
;**************************

	push	dx
	and	dl,11000000b
	mov	cl,6
	shr	dl,cl
	mov	bh,dl
	inc	bh
	pop	dx

;**************************
;                         *
;Test 8087		  *
;		 	  *
;**************************

	push	dx
	and	dl,00000010b
	shr	dl,1
	mov	bl,dl
	pop	dx

;**************************
;                         *
;Test for mouse		  *
;		 	  *
;**************************

	and	dl,00000100b
	shr	dl,1
	shr	dl,1
	mov	ch,dl
	

;**************************
;                         *
;get memory		  *
;		 	  *
;**************************
	
	push	ax
	push	bx
	push	cx
	int	12h
	mov	dx,ax
	pop	cx
	pop	bx
	pop	ax
	mov	cl,0
	clc
	ret

EQUIP	ENDP

;******************************************************************

;Messages
;******************************************************************

MESS_COM	DB	0ah,0dh
		DB	'	AshesOS	',0ah,0dh
		DB	' Menu of operations ',0ah,0dh
		DB	'1. Machine Type      ',0ah,0dh
		DB	'Select operation desired:',00

EQUIPS		DB	0ah,0ah,0dh
PRNS		DB	20h
		DB	' printer port(s)',0ah,0dh	
S_PORTS		DB	20h
		DB	' serial port(s)',0ah,0dh	
DSKTS		DB	20h
		DB	' disk drives(s)',0ah,0dh	
CORPO		DB	20h
		DB	' math coprocessor',0ah,0dh	
Mouse		DB	20h
		DB	' mouse ports (ps/2 only)',0ah,0dh	
;******************************************************************

;Display
;******************************************************************

Display_Text PROC

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

	ret

Exit_D	ENDP
;******************************************************************

CODE	ENDS
END







	

	
	

	

	
