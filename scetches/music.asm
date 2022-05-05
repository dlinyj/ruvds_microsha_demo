prompt  equ 0F86Ch
puts    equ 0F818h
M1:     EQU 0F89Dh
    org 0
    lxi h, msg
    call puts
    
    lxi h, 0d803h; запись команды для таймера
    mvi m, 0b6h ;10110110 (0 - двоичный, *11 - режим 3, 11 мл, ст байт, 10 - канал 2)
    dcx h ;загрузка счётчика 2 d802h
    mvi m, 10h
    mvi m, 20h
    lxi h, 0c003h; регистр управляющего слова для клавиатуры
    mvi m, 80h ;все на вывод
    dcx h
l1:
    mvi m, 06h
    call frame_delay
    call frame_delay
    call frame_delay
    call frame_delay
    mvi m, 0h
    call frame_delay
    call frame_delay
    call frame_delay
    call frame_delay
    jmp l1
    jmp prompt
    ;call M1

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

msg:
        db 1fh,'radio-86rk snowa s nami!',0dh,0ah,7,0
