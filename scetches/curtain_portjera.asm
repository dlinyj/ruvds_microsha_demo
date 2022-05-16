video_area equ 76d0h	;ОЗУ. Видеопамять
video_area_end equ video_area + (78*30)
video_area_size equ (78*30)

puts    equ 0F818h

M_SCREEN_WIDTH equ 78
M_SCREEN_HEIGHT equ 30

M_FULL_BLOCK equ 0x17

	org 0

	call curtain

	call frame_delay
	call frame_delay
	call frame_delay
	;init var
	;Нужно для многократного запуска, потом можно убрать.
	lxi h,start_msg
	shld memcpy_pos
	lxi h,video_area_size
	shld symbol_to_output
	lxi h,0
	shld clear_size
	lxi h,video_area_end
	shld clear_pos
portjera:
	;расчёт сколько символов нам осталось перелопатить
	lhld  symbol_to_output; загружаем
	mov a, l
	cmp h
	jz while_true; подошли к концу
	sui lo(M_SCREEN_WIDTH)
	mov l, a
	mov a, h
	sbi hi(M_SCREEN_WIDTH) ;надо сделать high low (но не помню как)
	mov h, a
	shld symbol_to_output; схороним всё
;	mov b, h
;	mov c, l
;	mvi d, 0x17
;	lxi h, video_area
;	call memset
	
;	lxi h, video_area
;	mvi d, ' '
;	lxi b, video_area_size
;	call memset
	
	lhld clear_size
	mov a, l
	adi lo(M_SCREEN_WIDTH)
	mov l, a
	mov a, h
	aci hi(M_SCREEN_WIDTH)
	mov h, a
	shld clear_size
	mov b, h
	mov c, l

	lhld clear_pos
;Высчитываем положение фрейма для копирования под портьеру
	mvi a, lo(frame_001)
	sub c
	mov e, a
	mvi a, hi(frame_001)
	sbb b
	mov d, a
	lxi b, M_SCREEN_WIDTH; чтобы не копировать лишнего
	call memcpy
	call frame_delay
	jmp portjera

while_true:
	jmp while_true

memcpy_pos:
	dw start_msg
symbol_to_output:
	dw video_area_size
clear_size:
	dw 0
clear_pos:
	dw video_area_end       

long_frame_delay:
	call frame_delay
	call frame_delay
	call frame_delay
	call frame_delay
	call frame_delay
	call frame_delay

	call frame_delay
	call frame_delay
	call frame_delay
	call frame_delay
	call frame_delay
	call frame_delay
	ret

curtain:
	lxi h,video_area
	mvi d, ' '
	mvi b, 0
	mvi c, M_SCREEN_WIDTH
	call memset
	lxi h,video_area + M_SCREEN_WIDTH
	shld curtain_video_pos
	mvi e, M_SCREEN_HEIGHT - 2
pr_loop:
	mvi d, ' '
	mvi c, 7
	call memset

	lhld curtain_video_pos
	mov a, l
	adi 7
	mov l, a
	mov a, h
	aci 0
	mov h, a
	shld curtain_video_pos

	mvi d, M_FULL_BLOCK
	mvi c, 64
	call memset

	lhld curtain_video_pos
	mov a, l
	adi 64
	mov l, a
	mov a, h
	aci 0
	mov h, a
	shld curtain_video_pos

	lhld curtain_video_pos
	mvi d, ' '
	mvi c, 7
	call memset

	lhld curtain_video_pos
	mov a, l
	adi 7
	mov l, a
	mov a, h
	aci 0
	mov h, a
	shld curtain_video_pos
	dcr e
	jnz pr_loop
	
	mvi d, ' '
	mvi b, 0
	mvi c, M_SCREEN_WIDTH
	call memset
	
	ret
curtain_video_pos:
	dw video_area


start_msg:
	db 1fh, 0dh, 0ah
	db ' ', ' ', ' ', 14h, 17h, 17h, 17h, 17h, 17h, 17h, 17h, 17h, ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', 17h, 14h, ' ', ' ', ' ', 14h, 17h, ' ', ' ', ' ', ' ', 17h, 14h, ' ', ' ', 17h, 17h, 17h, 17h, 17h, 17h, 17h, 17h, 14h, ' ', ' ', ' ', ' ', ' ', 14h, 17h, 17h, 17h, 17h, 17h, 17h, 17h, 17h, 0dh, 0ah
	db ' ', ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', 17h, 17h, 17h, ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', 17h, 17h, 17h, ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', 17h, 17h, 17h, ' ', 17h, 17h, 17h, ' ', ' ', ' ', 03h, 17h, 17h, 17h, ' ', ' ', ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', 17h, 17h, 17h, 0dh, 0ah
	db ' ', ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', 17h, 17h, 17h, ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', 17h, 17h, 17h, ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', 17h, 17h, 17h, ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', 17h, 17h, 17h, ' ', ' ', ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', 17h, 03h, ' ', 0dh, 0ah
	db ' ', 14h, 17h, 17h, 17h, 14h, 14h, 14h, 14h, 17h, 17h, 03h, ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', 17h, 17h, 17h, ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', 17h, 17h, 17h, ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', 17h, 17h, 17h, ' ', ' ', ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', ' ', ' ', ' ', 0dh, 0ah
	db 03h, 03h, 17h, 17h, 17h, 03h, 03h, 03h, 03h, 03h, ' ', ' ', ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', 17h, 17h, 17h, ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', 17h, 17h, 17h, ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', 17h, 17h, 17h, ' ', 03h, 17h, 17h, 17h, 17h, 17h, 17h, 17h, 17h, 17h, 17h, 17h, 0dh, 0ah
	db 03h, 17h, 17h, 17h, 17h, 17h, 17h, 17h, 17h, 17h, 17h, 17h, ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', 17h, 17h, 17h, ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', 17h, 17h, 17h, ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 17h, 17h, 17h, 0dh, 0ah
	db ' ', ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', 17h, 17h, 17h, ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', 17h, 17h, 17h, ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', 17h, 17h, 17h, ' ', 17h, 17h, 17h, ' ', ' ', ' ', 14h, 17h, 17h, 17h, ' ', ' ', ' ', ' ', 14h, 17h, ' ', ' ', ' ', ' ', 17h, 17h, 17h, 0dh, 0ah
	db ' ', ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', 17h, 17h, 17h, ' ', 17h, 17h, 17h, 17h, 17h, 17h, 17h, 17h, 03h, ' ', ' ', ' ', 03h, 17h, 17h, 17h, 17h, 17h, 17h, 03h, ' ', ' ', 17h, 17h, 17h, 17h, 17h, 17h, 17h, 17h, 03h, ' ', ' ', ' ', 14h, 17h, 17h, 17h, 17h, 17h, 17h, 17h, 17h, 03h, ' ', 0dh, 0ah
	db ' ', ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', 17h, 17h, 17h, ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 0dh, 0ah
	db 0dh, 0ah, 0dh, 0ah
	db "demka specialxno dlq HABR", 0dh, 0ah
	db "ideq i realizaciq DLINYJ", 0dh, 0ah, 0dh, 0ah
    db "bolx{aq blagodarnostx MAN OF LETTERS", 0dh, 0ah
	db 0dh, 0ah, 0dh, 0ah, 0dh, 0ah,0dh, 0ah, 0dh, 0ah, 0dh, 0ah, 0dh, 0ah,0dh, 0ah
	db 0
endmsg:

frame_delay:
	;lxi d, 2000
	;lxi d, 6000;10
	lxi d, 12000;30
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
loop_memcpy:
	ldax    d          ;Load A from the address pointed by DE
	mov     m,a         ;Store A into the address pointed by HL
	inx     d          ;Increment DE
	inx     h          ;Increment HL
	dcx     b          ;Decrement BC   (does not affect Flags)
	mov     a,b         ;Copy B to A    (so as to compare BC with zero)
	ora     c           ;A = A | C      (set zero)
	jnz     loop_memcpy ;Jump to 'loop:' if the zero-flag is not set.
	ret                 ;Return


	; bc: number of bytes to copy
	;  d: symbol to set
	; hl: target block
memset:
	mov     a,b         ;Copy register B to register A
	ora     c           ;Bitwise OR of A and C into register A
	rz                  ;Return if the zero-flag is set high.
loop_memset:
	mov     m,d         ;Store A into the address pointed by HL
	inx     h          ;Increment HL
	dcx     b          ;Decrement BC   (does not affect Flags)
	mov     a,b         ;Copy B to A    (so as to compare BC with zero)
	ora     c           ;A = A | C      (set zero)
	jnz     loop_memset ;Jump to 'loop:' if the zero-flag is not set.
	ret                 ;Return

initial_frame:
  db 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h
  db 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 014h, 014h, 014h, 014h, 014h, 014h, 014h, 014h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h
  db 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 004h, 016h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 015h, 010h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h
  db 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 004h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 010h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h
  db 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 004h, 017h, 017h, 017h, 017h, 017h, 003h, 003h, 003h, 003h, 017h, 017h, 017h, 017h, 015h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h
  db 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 016h, 017h, 017h, 017h, 003h, 020h, 020h, 020h, 020h, 020h, 020h, 007h, 017h, 017h, 017h, 011h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h
  db 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 006h, 017h, 017h, 017h, 001h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 006h, 017h, 017h, 017h, 014h, 014h, 014h, 014h, 010h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h
  db 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 006h, 017h, 017h, 013h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 007h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 015h, 010h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h
  db 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 017h, 017h, 017h, 001h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 002h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 010h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h
  db 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 017h, 017h, 017h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 010h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h
  db 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 004h, 014h, 015h, 017h, 017h, 017h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 007h, 003h, 020h, 020h, 020h, 020h, 002h, 017h, 017h, 017h, 015h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h
  db 020h, 020h, 020h, 020h, 020h, 020h, 020h, 014h, 017h, 017h, 017h, 017h, 017h, 017h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 012h, 017h, 017h, 017h, 010h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h
  db 020h, 020h, 020h, 020h, 020h, 012h, 016h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 006h, 017h, 017h, 015h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h
  db 020h, 020h, 020h, 020h, 020h, 016h, 017h, 017h, 017h, 017h, 013h, 003h, 003h, 003h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 002h, 017h, 017h, 017h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h
  db 020h, 020h, 020h, 020h, 006h, 017h, 017h, 017h, 013h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h
  db 020h, 020h, 020h, 004h, 017h, 017h, 017h, 013h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 014h, 014h, 014h, 014h, 014h, 014h, 020h, 020h, 020h, 020h, 014h, 014h, 014h, 020h, 020h, 020h, 020h, 004h, 014h, 014h, 020h, 020h, 020h, 020h, 014h, 010h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 004h, 014h, 010h, 020h, 014h, 014h, 014h, 014h, 014h, 010h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 014h, 014h, 014h, 014h, 020h, 020h, 020h, 020h, 020h
  db 020h, 020h, 020h, 006h, 017h, 017h, 017h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 006h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 014h, 020h, 006h, 017h, 017h, 017h, 020h, 020h, 020h, 020h, 017h, 017h, 017h, 011h, 020h, 020h, 020h, 017h, 017h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 017h, 017h, 011h, 020h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 014h, 004h, 020h, 020h, 020h, 020h, 016h, 017h, 017h, 017h, 017h, 017h, 011h, 020h, 020h, 020h
  db 020h, 020h, 020h, 006h, 017h, 017h, 013h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 006h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 015h, 006h, 017h, 017h, 017h, 020h, 020h, 020h, 020h, 017h, 017h, 017h, 011h, 020h, 020h, 020h, 007h, 017h, 010h, 020h, 020h, 020h, 020h, 020h, 020h, 017h, 017h, 020h, 020h, 017h, 017h, 003h, 003h, 017h, 017h, 017h, 017h, 015h, 001h, 020h, 020h, 016h, 017h, 017h, 003h, 003h, 017h, 017h, 011h, 020h, 020h, 020h
  db 020h, 020h, 020h, 006h, 017h, 017h, 011h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 006h, 017h, 017h, 013h, 003h, 003h, 007h, 017h, 017h, 017h, 006h, 017h, 017h, 017h, 020h, 020h, 020h, 020h, 017h, 017h, 017h, 011h, 020h, 020h, 020h, 002h, 017h, 015h, 020h, 020h, 020h, 020h, 020h, 004h, 017h, 013h, 020h, 020h, 017h, 017h, 020h, 020h, 020h, 020h, 001h, 007h, 017h, 015h, 020h, 020h, 017h, 017h, 001h, 020h, 020h, 020h, 003h, 020h, 020h, 020h, 020h
  db 020h, 020h, 020h, 006h, 017h, 017h, 011h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 006h, 017h, 017h, 011h, 020h, 020h, 020h, 017h, 017h, 017h, 006h, 017h, 017h, 017h, 020h, 020h, 020h, 020h, 017h, 017h, 017h, 011h, 020h, 020h, 020h, 020h, 017h, 017h, 010h, 020h, 020h, 020h, 020h, 016h, 017h, 001h, 020h, 020h, 017h, 017h, 020h, 020h, 020h, 020h, 020h, 020h, 017h, 017h, 010h, 020h, 017h, 017h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h
  db 020h, 020h, 020h, 006h, 017h, 017h, 011h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 006h, 017h, 017h, 011h, 020h, 020h, 020h, 016h, 017h, 017h, 006h, 017h, 017h, 017h, 020h, 020h, 020h, 020h, 017h, 017h, 017h, 011h, 020h, 020h, 020h, 020h, 007h, 017h, 011h, 020h, 020h, 020h, 004h, 017h, 013h, 020h, 020h, 020h, 017h, 017h, 020h, 020h, 020h, 020h, 020h, 020h, 007h, 017h, 011h, 020h, 017h, 017h, 015h, 010h, 020h, 020h, 020h, 020h, 020h, 020h, 020h
  db 020h, 020h, 020h, 006h, 017h, 017h, 011h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 006h, 017h, 017h, 011h, 020h, 020h, 004h, 017h, 017h, 017h, 006h, 017h, 017h, 017h, 020h, 020h, 020h, 020h, 017h, 017h, 017h, 011h, 020h, 020h, 020h, 020h, 002h, 017h, 017h, 020h, 020h, 020h, 006h, 017h, 011h, 020h, 020h, 020h, 017h, 017h, 020h, 020h, 020h, 020h, 020h, 020h, 006h, 017h, 017h, 020h, 002h, 017h, 017h, 017h, 015h, 010h, 020h, 020h, 020h, 020h, 020h
  db 020h, 020h, 020h, 006h, 017h, 017h, 017h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 006h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 006h, 017h, 017h, 017h, 020h, 020h, 020h, 020h, 017h, 017h, 017h, 011h, 020h, 020h, 020h, 020h, 020h, 017h, 017h, 011h, 020h, 020h, 017h, 017h, 020h, 020h, 020h, 020h, 017h, 017h, 020h, 020h, 020h, 020h, 020h, 020h, 006h, 017h, 017h, 020h, 020h, 002h, 003h, 017h, 017h, 017h, 014h, 020h, 020h, 020h, 020h
  db 020h, 020h, 020h, 002h, 017h, 017h, 017h, 011h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 006h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 013h, 001h, 006h, 017h, 017h, 017h, 020h, 020h, 020h, 020h, 017h, 017h, 017h, 011h, 020h, 020h, 020h, 020h, 020h, 006h, 017h, 017h, 020h, 006h, 017h, 015h, 020h, 020h, 020h, 020h, 017h, 017h, 020h, 020h, 020h, 020h, 020h, 020h, 006h, 017h, 017h, 020h, 020h, 020h, 020h, 020h, 003h, 017h, 017h, 011h, 020h, 020h, 020h
  db 020h, 020h, 020h, 020h, 007h, 017h, 017h, 017h, 010h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 006h, 017h, 017h, 011h, 017h, 017h, 017h, 017h, 020h, 020h, 006h, 017h, 017h, 017h, 020h, 020h, 020h, 020h, 017h, 017h, 017h, 011h, 020h, 020h, 020h, 020h, 020h, 020h, 017h, 017h, 020h, 016h, 017h, 011h, 020h, 020h, 020h, 020h, 017h, 017h, 020h, 020h, 020h, 020h, 020h, 020h, 016h, 017h, 011h, 020h, 020h, 020h, 020h, 020h, 020h, 006h, 017h, 011h, 020h, 020h, 020h
  db 020h, 020h, 020h, 020h, 002h, 017h, 017h, 017h, 017h, 015h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 002h, 017h, 017h, 011h, 002h, 017h, 017h, 017h, 015h, 020h, 006h, 017h, 017h, 017h, 020h, 020h, 020h, 020h, 017h, 017h, 017h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 006h, 017h, 014h, 017h, 017h, 020h, 020h, 020h, 020h, 020h, 017h, 017h, 020h, 020h, 020h, 020h, 020h, 020h, 017h, 017h, 001h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 017h, 011h, 020h, 020h, 020h
  db 020h, 020h, 020h, 020h, 020h, 002h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 011h, 020h, 002h, 017h, 017h, 017h, 015h, 020h, 017h, 017h, 017h, 015h, 014h, 014h, 016h, 017h, 017h, 013h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 002h, 017h, 017h, 017h, 011h, 020h, 020h, 020h, 020h, 020h, 017h, 017h, 020h, 020h, 020h, 020h, 004h, 016h, 017h, 011h, 020h, 020h, 014h, 020h, 020h, 020h, 020h, 006h, 017h, 011h, 020h, 020h, 020h
  db 020h, 020h, 020h, 020h, 020h, 020h, 020h, 007h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 011h, 020h, 020h, 006h, 017h, 017h, 017h, 010h, 002h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 001h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 007h, 017h, 017h, 001h, 020h, 020h, 020h, 020h, 020h, 017h, 017h, 016h, 017h, 017h, 017h, 017h, 017h, 013h, 020h, 020h, 006h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 011h, 020h, 020h, 020h
  db 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 002h, 007h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 011h, 020h, 020h, 020h, 007h, 017h, 017h, 017h, 020h, 002h, 007h, 017h, 017h, 017h, 017h, 013h, 001h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 006h, 017h, 013h, 020h, 020h, 020h, 020h, 020h, 020h, 017h, 017h, 017h, 017h, 017h, 017h, 013h, 001h, 020h, 020h, 020h, 002h, 007h, 017h, 017h, 017h, 017h, 017h, 001h, 020h, 020h, 020h, 020h
  db 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h, 020h

frame_001:
