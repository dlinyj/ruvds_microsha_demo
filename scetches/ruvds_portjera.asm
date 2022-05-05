video_area equ 76d0h	;ОЗУ. Видеопамять
video_area_end equ video_area + (78*30)
video_area_size equ (78*30)

puts    equ 0F818h

M_SCREEN_WIDTH equ 78
M_SCREEN_HEIGHT equ 30

	org 0
	lxi h, msg
	call puts
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

	lxi h, video_area
	mvi d, 0x17
	lxi b, video_area_size
	call memset
	call frame_delay
	call frame_delay
	call frame_delay
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
	mov b, h
	mov c, l
	mvi d, 0x17
	lxi h, video_area
	; bc: number of bytes to copy
	;  d: symbol to set
	; hl: target block
	call memset
	
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
	mov a, l
	sui lo(M_SCREEN_WIDTH)
	mov l, a
	mov a, h
	sbi hi(M_SCREEN_WIDTH)
	mov h, a
	shld clear_pos; схороним всё
	mvi d, ' '
	call memset
	call frame_delay
	jmp portjera

while_true:
	jmp while_true

memcpy_pos:
	dw msg
symbol_to_output:
	dw video_area_size
clear_size:
	dw 0
clear_pos:
	dw video_area_end       

msg:
	db 1fh, 0dh, 0ah
	db "   '########::'##::::'##:'##::::'##:'########:::'######:::::", 0dh, 0ah
	db "    ##.... ##: ##:::: ##: ##:::: ##: ##.... ##:'##... ##::::", 0dh, 0ah
	db "    ##:::: ##: ##:::: ##: ##:::: ##: ##:::: ##: ##:::..:::::", 0dh, 0ah
	db "    ########:: ##:::: ##: ##:::: ##: ##:::: ##:. ######:::::", 0dh, 0ah
	db "    ##.. ##::: ##:::: ##:. ##:: ##:: ##:::: ##::..... ##::::", 0dh, 0ah
	db "    ##::. ##:: ##:::: ##::. ## ##::: ##:::: ##:'##::: ##::::", 0dh, 0ah
	db "    ##:::. ##:. #######::::. ###:::: ########::. ######:::::", 0dh, 0ah
	db "   ..:::::..:::.......::::::...:::::........::::......::::::", 0dh, 0ah
	db 0dh, 0ah, 0dh, 0ah
	db "    specialxno dlq HABR", 0dh, 0ah
	db "    priwet ot DLINYJ"
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
