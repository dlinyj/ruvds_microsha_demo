video_area equ 76d0h	;ОЗУ. Видеопамять
video_area_end equ video_area + (78*30)

	org 0h

init_frame_start:
	lxi b, 8E8h ;размер
	lxi d, initial_frame
	lxi h, video_area
	call memcpy

next_frame:
	lxi d, 2000
frame_delay_loop:
	dcx d
	mov a, d
	ora e
	jnz frame_delay_loop

	lxi h, frame_001 ; тут по хорошему надо расчётное значение
	mov a, m
	inx h
	cpi 255
	jz init_frame_start
	cpi 0
	jz next_frame

	mov c, a
frame_loop:
	mov e, m
	inx h
	mov d, m
	inx h
	mov a, m
	inx h
	ldax d
	stax d
	dcr c
	jnz frame_loop
	jmp next_frame

	; bc: number of bytes to copy
	; de: source block
	; hl: target block
memcpy:
	mov     a,b         ;Copy register B to register A
	ora     c           ;Bitwise OR of A and C into register A
	rz                  ;Return if the zero-flag is set high.
loop:
	ldax    d          ;Load A from the address pointed by DE
	mov     m,a         ;Store A into the address pointed by HL
	inx     d          ;Increment DE
	inx     h          ;Increment HL
	dcx     b          ;Decrement BC   (does not affect Flags)
	mov     a,b         ;Copy B to A    (so as to compare BC with zero)
	ora     c           ;A = A | C      (set zero)
	jnz     loop        ;Jump to 'loop:' if the zero-flag is not set.
	ret                 ;Return

  include "frames.asm"
