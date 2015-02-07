SSEG	SEGMENT	STACK

	DB	400h DUP('?')

STACK_TOP EQU THIS BYTE

ASSUME SS:SSEG
SSEG	ENDS

DATA	SEGMENT

;*******************
;Disk Transfer Area*
;*******************
;DTA
;************************************

DTA_BUFF DB	128	DUP(00h)
	 DB	382	DUP(00h)

	 DB	55h
	 DB	0AAh	
	 DB	1024	DUP(00h)

	 DW	0000h

;************************************

;********************
;File Control Blocks*
;********************
;FCB - Ashes.bin
;************************************

FCB_BUF1	DB	0
		DB	'ASHES'
		DB	'BIN'
		DB	25 DUP (00h)
		DW	0000h

;FCB - Ashes.sys
;************************************


FCB_BUF2	DB	0
		DB	'ASHES '
		DB	'SYS'
		DB	25 DUP (00h)
		DW	0000h

;********************
;Error Msg's	    *
;********************
;Error Messages
;************************************

ERR_MS1 DB	'Cannot open file',10,13,'$'
ERR_MS2 DB	'File operation error', 10, 13,'$'

DATA	ENDS

;*********************************************************************************
CODE	SEGMENT
	ASSUME CS:CODE

START:
	mov	ax,DATA
	mov	ds,ax
	ASSUME DS:DATA

	lea	sp,SS:STACK_TOP

	push	ds
	pop	es
	ASSUME ES:DATA


;****************
;Set the DTA    *
;****************

	mov	ah,26
	mov	dx,OFFSET DTA_BUFF
	INT	21h

;**************************
;Open and load ashes.bin  *
;                         *
;**************************

	mov	ah,15
	mov	dx,OFFSET FCB_BUF1
	int	21h
	cmp	AL,0FFh
	je	OK_BOOT1
	mov	dx,OFFSET ERR_MS1
	jmp	ERROR


;************************
;Read 256 bytes from    *
;Ashes.bin to DTA_BUF   *
;************************

OK_BOOT1:
	mov	ah,20	
	mov	dx,OFFSET FCB_BUF1
	mov	WORD PTR DS:FCB_BUF1+14,256
	int	21h
	cmp	al,4
	jc	OK_BOOT2
	mov	dx,OFFSET ERR_MS2
	jmp	ERROR
	
;****************
;Close Ashes.bin*
;****************

OK_BOOT2:
	mov	ah,16
	mov	dx,OFFSET FCB_BUF1
	int	21h


;********************
;Write DTA to a Disk*
;********************

	mov	al,0 
	mov	cx,1
	mov	dx,0
	mov	bx,OFFSET DTA_BUFF
	int	26h
	add	sp,2

;*********************************
;Load the operating system kernal*
;*********************************


;**************************
;Open and load ashes.sys  *
;                         *
;**************************

	mov	ah,15
	mov	dx,OFFSET FCB_BUF2
	int	21h
	cmp	AL,0FFh
	je	OK_MINI1
	mov	dx,OFFSET ERR_MS1
	jmp	ERROR


;************************
;Read 256 bytes from    *
;Ashes.sys to DTA_BUF   *
;************************

OK_MINI1:

	mov	ah,20	
	mov	dx,OFFSET FCB_BUF2
	mov	WORD PTR DS:FCB_BUF2+14,1536
	int	21h
	cmp	al,4
	jc	OK_MINI2
	mov	dx,OFFSET ERR_MS2
	jmp	ERROR
	
;****************
;Close Ashes.sys*
;****************

OK_MINI2:
	mov	ah,16
	mov	dx,OFFSET FCB_BUF2
	int	21h


;********************
;Write DTA to a Disk*
;********************

	mov	al,0 
	mov	cx,3
	mov	dx,2
	mov	bx,OFFSET DTA_BUFF
	int	26h
	add	sp,2

	jmp	Dos_Exit

;***************
;Error stuff   *
;***************

ERROR:
	mov	ah,9
	int	21h
	
Dos_Exit:
	mov	ah,76
	mov	al,0
	int	21h

CODE	ENDS
	END	START
















