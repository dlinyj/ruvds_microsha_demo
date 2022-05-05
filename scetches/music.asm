m55regcfg  equ 0c003h
portc_reg  equ 0c002h
tim_regcfg equ 0d803h
timer2_reg equ 0d802h

    org 0
    call init_sound
start_music:
    lxi h, timer2_reg
    lxi b, melody
load:
    ldax b ;младший байт
    mov e, a
    inx b
    ldax b
    cmp e
    jnz enabled
    call disable_sound;если нуль тишина
    jmp pre_delay
enabled:
    mov m, e
    mov m, a
    call enable_sound;если не нуль
pre_delay:
    inx b
    ldax b
delay_loop:
    sta counter_delay
    call frame_delay
    lda counter_delay
    dcr a
    jnz delay_loop
    inx b
    mvi a, hi(end_melody)
    cmp b
    jnz load
    mvi a, lo(end_melody)
    cmp c
    jnz load
    jmp start_music

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

melody:
    dw 949
    db 4
    dw 0
    db 4
    dw 10172
    db 4
    dw 0
    db 4
    dw 7596
    db 4
    dw 845
    db 4
    dw 798
    db 4
    dw 845
    db 4
    dw 949
    db 4
    dw 0
    db 4
    dw 10172
    db 4
    dw 0
    db 4
    dw 7596
    db 4
    dw 845
    db 4
    dw 798
    db 4
    dw 845
    db 4
    dw 949
    db 4
    dw 845
    db 4
    dw 798
    db 4
    dw 845
    db 4
    dw 949
    db 4
    dw 845
    db 4
    dw 798
    db 4
    dw 845
    db 4
    dw 949
    db 4
    dw 845
    db 4
    dw 798
    db 4
    dw 845
    db 4
    dw 949
    db 4
    dw 0
    db 4
    dw 1267
    db 4
    dw 0
    db 4
    dw 1065
    db 4
    dw 0
    db 4
    dw 13615
    db 4
    dw 0
    db 4
    dw 10172
    db 4
    dw 0
    db 4
    dw 13615
    db 4
    dw 0
    db 4
    dw 20344
    db 4
    dw 0
    db 4
    dw 13615
    db 4
    dw 0
    db 4
    dw 10172
    db 4
    dw 0
    db 4
    dw 13615
    db 4
    dw 0
    db 4
    dw 949
    db 4
    dw 0
    db 4
    dw 10172
    db 4
    dw 0
    db 4
    dw 7596
    db 4
    dw 845
    db 4
    dw 798
    db 4
    dw 845
    db 4
    dw 949
    db 4
    dw 0
    db 4
    dw 10172
    db 4
    dw 0
    db 4
    dw 7596
    db 4
    dw 845
    db 4
    dw 798
    db 4
    dw 845
    db 4
    dw 949
    db 4
    dw 845
    db 4
    dw 798
    db 4
    dw 845
    db 4
    dw 949
    db 4
    dw 845
    db 4
    dw 798
    db 4
    dw 845
    db 4
    dw 949
    db 4
    dw 845
    db 4
    dw 798
    db 4
    dw 845
    db 4
    dw 949
    db 4
    dw 0
    db 4
    dw 1267
    db 4
    dw 0
    db 4
    dw 1065
    db 4
    dw 0
    db 4
    dw 13615
    db 4
    dw 0
    db 4
    dw 10172
    db 4
    dw 0
    db 4
    dw 13615
    db 4
    dw 0
    db 4
    dw 20344
    db 4
    dw 0
    db 4
    dw 13615
    db 4
    dw 0
    db 4
    dw 10172
    db 4
    dw 0
    db 4
    dw 13615
    db 4
    dw 0
    db 4
    dw 1196
    db 4
    dw 0
    db 4
    dw 15258
    db 4
    dw 798
    db 4
    dw 11419
    db 4
    dw 711
    db 4
    dw 798
    db 4
    dw 845
    db 4
    dw 798
    db 4
    dw 0
    db 4
    dw 15258
    db 4
    dw 0
    db 4
    dw 11419
    db 4
    dw 711
    db 4
    dw 798
    db 4
    dw 845
    db 4
    dw 798
    db 4
    dw 711
    db 4
    dw 798
    db 4
    dw 845
    db 4
    dw 798
    db 4
    dw 711
    db 4
    dw 798
    db 4
    dw 845
    db 4
    dw 798
    db 4
    dw 711
    db 4
    dw 798
    db 4
    dw 845
    db 4
    dw 798
    db 4
    dw 0
    db 4
    dw 845
    db 4
    dw 0
    db 4
    dw 798
    db 2
    dw 845
    db 2
    dw 949
    db 2
    dw 0
    db 2
    dw 12826
    db 4
    dw 0
    db 4
    dw 9619
    db 4
    dw 0
    db 4
    dw 12826
    db 4
    dw 0
    db 4
    dw 1065
    db 4
    dw 0
    db 4
    dw 11419
    db 4
    dw 0
    db 4
    dw 8550
    db 4
    dw 0
    db 4
    dw 11419
    db 4
end_melody:
