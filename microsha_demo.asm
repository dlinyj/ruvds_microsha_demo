video_area equ 76d0h	;ОЗУ. Видеопамять
video_area_end equ video_area + (78*30)

	org 0h
	call init_sound
	call monitor_config
init_frame_start:
	lxi b, (78*30);размер
	lxi d, initial_frame
	lxi h, video_area
	call memcpy
	lxi h, frame_001 ;7C52
next_frame:
	push h
	call long_frame_delay
	pop h
	mov a, m
	inx h
	mov c, a
	mov b, m
	inx h
	ora b ; если всё по нулям, значит следующий фрейм
	jz next_frame
	cpi 0ffh
	jz init_frame_start; подошли к концу
frame_loop:
	mov e, m
	inx h
	mov d, m
	inx h
	mov a, m
	inx h
	stax d
	dcx b
	mov a, c
	ora b
	jnz frame_loop
	jmp next_frame

monitor_config:
	lxi h, 0d001h	; регистр признаков
	mvi m, 00h		; сброс
	dcx h			; регистр команд
	mvi m, 4dh		; 0.1001101  77 (77+1 знакомест)
	mvi m, 1dh		; 00.011101  29 (29+1 строк)
	mvi m, 08h		; 7 линий без подчёркивания, 7 линий в знакоместе
	mvi m, 0b3h		; немерцающее подчёркивание**
	inx h
	mvi m, 27h
	ret

long_frame_delay:
	call frame_delay
	call frame_delay
	call frame_delay
	call frame_delay
	call frame_delay
	call frame_delay
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
	include "scetches/music_delay.asm"
