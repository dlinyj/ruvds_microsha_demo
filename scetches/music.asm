prompt  equ 0F86Ch
puts    equ 0F818h
M1:     EQU 0F89Dh
portc_reg  equ 0c002h
timer2_reg equ 0d802h
    org 0

    lxi h, 0c003h; регистр управляющего слова для клавиатуры
    mvi m, 80h ;все на вывод

    lxi h, 0d803h; запись команды для таймера
    mvi m, 0b6h ;10110110 (0 - двоичный, *11 - режим 3, 11 мл, ст байт, 10 - канал 2)
    ;dcx h ;загрузка счётчика 2 d802h
start_music:
    ;mvi m, 10h
    ;mvi m, 20h
    lxi h, timer2_reg
    lxi b, melody
load:
    ldax b;младший байт
    mov e, a
    inx b
    ldax b
    cmp e
    jnz enabled
    call disable_sound;если нуль
    jmp pre_delay
enabled:
;    mov m, e
;    mov m, a
    mov m, a
    mov m, e
    call  enable_sound;если не нуль
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
    db 9
    dw 0
    db 9
    dw 10172
    db 9
    dw 0
    db 9
    dw 7596
    db 9
    dw 845
    db 9
    dw 798
    db 9
    dw 845
    db 9
    dw 949
    db 9
    dw 0
    db 9
    dw 10172
    db 9
    dw 0
    db 9
    dw 7596
    db 9
    dw 845
    db 9
    dw 798
    db 9
    dw 845
    db 9
    dw 949
    db 9
    dw 845
    db 9
    dw 798
    db 9
    dw 845
    db 9
    dw 949
    db 9
    dw 845
    db 9
    dw 798
    db 9
    dw 845
    db 9
    dw 949
    db 9
    dw 845
    db 9
    dw 798
    db 9
    dw 845
    db 9
    dw 949
    db 9
    dw 0
    db 9
    dw 1267
    db 9
    dw 0
    db 9
    dw 1065
    db 9
    dw 0
    db 9
    dw 13615
    db 9
    dw 0
    db 9
    dw 10172
    db 9
    dw 0
    db 9
    dw 13615
    db 9
    dw 0
    db 9
    dw 20344
    db 9
    dw 0
    db 9
    dw 13615
    db 9
    dw 0
    db 9
    dw 10172
    db 9
    dw 0
    db 9
    dw 13615
    db 9
    dw 0
    db 9
    dw 949
    db 9
    dw 0
    db 9
    dw 10172
    db 9
    dw 0
    db 9
    dw 7596
    db 9
    dw 845
    db 9
    dw 798
    db 9
    dw 845
    db 9
    dw 949
    db 9
    dw 0
    db 9
    dw 10172
    db 9
    dw 0
    db 9
    dw 7596
    db 9
    dw 845
    db 9
    dw 798
    db 9
    dw 845
    db 9
    dw 949
    db 9
    dw 845
    db 9
    dw 798
    db 9
    dw 845
    db 9
    dw 949
    db 9
    dw 845
    db 9
    dw 798
    db 9
    dw 845
    db 9
    dw 949
    db 9
    dw 845
    db 9
    dw 798
    db 9
    dw 845
    db 9
    dw 949
    db 9
    dw 0
    db 9
    dw 1267
    db 9
    dw 0
    db 9
    dw 1065
    db 9
    dw 0
    db 9
    dw 13615
    db 9
    dw 0
    db 9
    dw 10172
    db 9
    dw 0
    db 9
    dw 13615
    db 9
    dw 0
    db 9
    dw 20344
    db 9
    dw 0
    db 9
    dw 13615
    db 9
    dw 0
    db 9
    dw 10172
    db 9
    dw 0
    db 9
    dw 13615
    db 9
    dw 0
    db 9
    dw 1196
    db 9
    dw 0
    db 9
    dw 15258
    db 9
    dw 798
    db 9
    dw 11419
    db 9
    dw 711
    db 9
    dw 798
    db 9
    dw 845
    db 9
    dw 798
    db 9
    dw 0
    db 9
    dw 15258
    db 9
    dw 0
    db 9
    dw 11419
    db 9
    dw 711
    db 9
    dw 798
    db 9
    dw 845
    db 9
    dw 798
    db 9
    dw 711
    db 9
    dw 798
    db 9
    dw 845
    db 9
    dw 798
    db 9
    dw 711
    db 9
    dw 798
    db 9
    dw 845
    db 9
    dw 798
    db 9
    dw 711
    db 9
    dw 798
    db 9
    dw 845
    db 9
    dw 798
    db 9
    dw 0
    db 9
    dw 845
    db 9
    dw 0
    db 9
    dw 798
    db 4
    dw 845
    db 4
    dw 949
    db 4
    dw 0
    db 4
    dw 12826
    db 9
    dw 0
    db 9
    dw 9619
    db 9
    dw 0
    db 9
    dw 12826
    db 9
    dw 0
    db 9
    dw 1065
    db 9
    dw 0
    db 9
    dw 11419
    db 9
    dw 0
    db 9
    dw 8550
    db 9
    dw 0
    db 9
    dw 11419
    db 9
end_melody:
