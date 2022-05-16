video_area equ 76d0h	;ОЗУ. Видеопамять
;размеры экрана в символах
M_SCREEN_WIDTH equ 78
M_SCREEN_HEIGHT equ 30

video_area_end equ video_area + (M_SCREEN_WIDTH * M_SCREEN_HEIGHT)
video_area_size equ (M_SCREEN_WIDTH * M_SCREEN_HEIGHT)

puts    equ 0F818h; Процедура монитора для печати сообщения

M_TOP_LEFT_POINT_B	equ	0x16
M_FULL_BLOCK		equ	0x17
M_DIAGONAL_FRTL		equ	0x12

	org 0h
	call init_var
	call video_config
	call splash_screen
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

init_var: ;Нужно для многократного запуска.
	;Иницициализация переменных музыки
	lxi h, melody
	shld music_pos
	;Стартовая позиция первого сообщения
	lxi h,start_msg

	;Для анимации подъёма шторы
	shld memcpy_pos
	lxi h,video_area_size
	shld symbol_to_output
	lxi h,0
	shld clear_size
	lxi h,video_area_end
	shld clear_pos
	ret

video_config:;Настраиваем "бесшовное" отображение символов
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

splash_screen:
	lxi h, start_msg
	call puts
	call long_long_frame_delay
	lxi h, video_area
;	Вариант шторы для "бедных"
;	mvi d, '*'
;	mvi d, 0x16
;	lxi b, video_area_size
;	call memset
;	Вариант нормальной шторы
	call curtain
	call long_frame_delay
	call long_frame_delay
	call long_frame_delay

portjera:
;расчёт сколько символов нам осталось перелопатить
	lhld  symbol_to_output; загружаем
	mov a, l
	cmp h
	rz ; подошли к концу
	sui lo(M_SCREEN_WIDTH)
	mov l, a
	mov a, h
	sbi hi(M_SCREEN_WIDTH)
	mov h, a
	shld symbol_to_output; схороним всё

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
	mov a, l
	sui lo(M_SCREEN_WIDTH)
	mov l, a
	mov a, h
	sbi hi(M_SCREEN_WIDTH)
	mov h, a
	shld clear_pos; схороним всё
;Высчитываем положение фрейма для копирования под портьеру
	mvi a, lo(frame_001)
	sub c
	mov e, a
	mvi a, hi(frame_001)
	sbb b
	mov d, a
	lxi b, M_SCREEN_WIDTH; чтобы не копировать лишнего
	call memcpy
	call long_frame_delay
	jmp portjera

;Переменные для заставки
memcpy_pos:
	dw start_msg
symbol_to_output:
	dw video_area_size
clear_size:
	dw 0
clear_pos:
	dw video_area_end

curtain:; Процедура "сплошной" заливки, с отступами, для корректного отображения
	lxi h,video_area
	mvi d, ' '
	mvi b, 0
	mvi c, M_SCREEN_WIDTH
	call memset
	lxi h,video_area + M_SCREEN_WIDTH
	shld curtain_video_pos
	mvi e, M_SCREEN_HEIGHT - 2
pr_loop:
	;первые семь пробелов в строке
	mvi d, ' '
	mvi c, 7
	call memset

	; заливка 64 символа
	lhld curtain_video_pos
	mov a, l
	adi 7
	mov l, a
	mov a, h
	aci 0
	mov h, a
	shld curtain_video_pos

	mvi d, M_DIAGONAL_FRTL; диагональ
	;mvi d, M_TOP_LEFT_POINT_B ; неполный блок с отсутствующим элементом
	;mvi d, '*' ; либо звёздочка
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

	;последние 7 символов в строке
	lhld curtain_video_pos
	mvi d, ' '
	mvi c, 7
	call memset

	;не достигли ли дна
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

	;последняя строка тёмная
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
	db 0dh, 0ah, 0dh, 0ah, 0dh, 0ah, 0dh, 0ah
	db 0dh, 0ah, 0dh, 0ah, 0dh, 0ah,0dh, 0ah, 0dh
	db "bolx{aq blagodarnostx MAN OF LETTERS", 0dh, 0ah
	db 0

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

long_long_frame_delay:
	call long_frame_delay
	call long_frame_delay
	call long_frame_delay
	call long_frame_delay
	call long_frame_delay
	call long_frame_delay

	call long_frame_delay
	call long_frame_delay
	call long_frame_delay
	call long_frame_delay
	call long_frame_delay
	call long_frame_delay

	call long_frame_delay
	call long_frame_delay
	call long_frame_delay
	call long_frame_delay
	call long_frame_delay
	call long_frame_delay
	ret

long_frame_delay:
	call frame_delay
	call frame_delay
	call frame_delay
	call frame_delay
	call frame_delay
	call frame_delay
	ret

	include "include/frames.asm"
	include "include/music_delay.asm"
