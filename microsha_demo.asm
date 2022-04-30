video_area equ 76d0h	;ОЗУ. Видеопамять
video_area_end equ video_area + (78*30)

	org 0h

init_frame_start:
	lxi b, 8E8h;размер
	lxi d, initial_frame
	lxi h, video_area
	call memcpy
	lxi h, frame_001 ; тут по хорошему надо расчётное значение

next_frame:
	call frame_delay
	mov a, m
	inx h
	cpi 255
	jz init_frame_start
	mov c, a
	cpi 0
	jz cmp_0_too
	mov b, m
	inx h
	jmp frame_loop
cmp_0_too:
	mov a, m
	inx h
	cpi 0
	jz next_frame
	mov b, a
frame_loop:
	mov e, m
	inx h
	mov d, m
	inx h
	mov a, m
	inx h
	stax d
	dcx b
	jnz frame_loop
	jmp next_frame

frame_delay:
	lxi d, 2000
frame_delay_loop:
	dcx d
	mov a, d
	ora e
	jnz frame_delay_loop
	ret
	
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
