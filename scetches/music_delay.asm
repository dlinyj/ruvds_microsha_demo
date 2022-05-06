m55regcfg  equ 0c003h
portc_reg  equ 0c002h
tim_regcfg equ 0d803h
timer2_reg equ 0d802h

    org 0
    call init_sound
while_true:
    call frame_delay
    jmp while_true

play_music:
    lda counter_delay; загружем счётчик задержки
    ana a; проверяем A на нуль
    jz next_note
    dcr a
    sta counter_delay
    ret
next_note:
    lxi b,music_pos
    ldax b ;младший байт
    mov e, a
    inx b
    ldax b
    cmp e
    jnz enabled
    call disable_sound;если нуль тишина
    jmp pre_delay
enabled:
    lxi h, timer2_reg
    mov m, e
    mov m, a
    call enable_sound;если не нуль
pre_delay:
    inx b
    ldax b
    sta counter_delay
    inx b
    mvi a, hi(end_melody)
    cmp b
    jnz not_end_melody
    mvi a, lo(end_melody)
    cmp c
    jnz not_end_melody
    lxi b, melody
not_end_melody:
    mov h, b
    mov l, c
    shld music_pos
    ret

init_sound:
    lxi h, m55regcfg; регистр управляющего слова для клавиатуры
    mvi m, 80h ;все на вывод
    lxi h, tim_regcfg; запись команды для таймера
    mvi m, 0b6h ;10110110 (0 - двоичный, *11 - режим 3, 11 мл, ст байт, 10 - канал 2)
    ret

disable_sound:
    mvi a, 0
    sta portc_reg
    ret
enable_sound:
    mvi a, 06h
    sta portc_reg
    ret

counter_delay:
    db 0
music_pos:
    dw melody

frame_delay:
	lxi d, 2000
	;lxi d, 6000;10
	;lxi d, 12000;30
frame_delay_loop:
	dcx d
	mov a, d
	ora e
	jnz frame_delay_loop
	ret

	include "melody.asm"

