loadEnemies:
    ldy #$00                ; Loads item sprites to sprite ram
enemyLoop:
    lda (enemyPtr),y
;    cmp #$FE
    beq @fillLoop
    sta enemyRAM,y
    iny
    cpy #$20
    bne enemyLoop

@fillLoop                   ; Clear unused enemyRAM
    lda #$FE
    sta enemyRAM,y
    iny
    cpy #$40
    bne @fillLoop

    lda enemyRAM+0          ; Populate enemy X and Y variables for collision
    sta enemyY+0
    lda enemyRAM+8
    sta enemyY+1
;    lda enemyRAM+16
;    sta enemyY+2
;    lda enemyRAM+24
;    sta enemyY+3

    lda enemyRAM+3
    sta enemyX+0
    lda enemyRAM+11
    sta enemyX+1
;    lda enemyRAM+19
;    sta enemyX+2
;    lda enemyRAM+27
;    sta enemyX+3
loadEnemiesDone:
    rts

enemyLogic:
    lda enemySpeed+1
    clc
    adc #$60
    sta enemySpeed+1

    lda #$00
    adc #$00
    sta temp

    ldx #$00                ; First need to calculate all of enemies next movements
vertical:                   ;  then update their individual enemyY and enemyX vars
    lda enemyY,x
    cmp playerY
    beq horizontal
    bcc @down
@up
    lda enemyY,x
    sbc temp
    sta enemyY,x
    jmp horizontal
@down
    lda enemyY,x
    adc temp
    sta enemyY,x

horizontal:
    lda enemyX,x
    cmp playerX
    beq @next
    bcc @right
@left
    lda enemyX,x
    sbc temp
    sta enemyX,x
    jmp @next
@right
    lda enemyX,x
    adc temp
    sta enemyX,x

@next
    inx
    cpx #$04
    bne vertical
enemyLogicDone:
    rts

enemyLoad:
    ldy #$00
    sty enemyY+0            ; Blank out enemy X/Y vars
    sty enemyY+1
    sty enemyY+2
    sty enemyY+3
    sty enemyX+0
    sty enemyX+1
    sty enemyX+2
    sty enemyX+3

    lda (enemyPtr),y
    sta enemyCtr            ; Store first element of enemy header in enemyCmp
    beq enemyLoadDone       ; If #$00 then we're done

@continue
    iny
    lda (enemyPtr),y
    sta enemyDefPtr+0
    iny                     ; Fill enemy definition pointer from second element of enemy header
    lda (enemyPtr),y
    sta enemyDefPtr+1
    iny

    ldx enemyCtr            ; Starting X/Y locations might eventually come from RNG rather than being hard coded
@loop
    lda (enemyPtr),y
    sta enemyY-1,x          ; Fill starting enemyY locations from enemy header
    iny
    dex
    bne @loop

    ldx enemyCtr
@loop2
    lda (enemyPtr),y
    sta enemyX-1,x          ; Fill starting enemyX locations from enemy header
    iny
    dex
    bne @loop2

    lda #$FF
    sta temp                ; Initialize temp to #$FF so that first loop sets it to #$00

@loop3
    ldy temp
    iny
    cpy enemyCtr
    beq enemyLoadDone       ; If temp == enemyCtr then we're done here
    sty temp                ; Otherwise store new value to temp and load a sprite
    ldy #$00
@loop4
    lda (enemyDefPtr),y     ; Load enemy def byte
    cmp #$FE                ; If #$FF then sprite is done
    beq @loop3              ; Back to loop for next enemy

    sta enemyRAM+1,x        ; Else store byte, load next byte and store it.
    iny
    lda (enemyDefPtr),y
    sta enemyRAM+2,x
    iny
    inx
    inx
    inx
    inx                     ; Increment X and Y counters
    bne @loop4              ; Always branch
enemyLoadDone:
    rts

    ; Still need to figure out enemyIndex

enemyDefsL:
    .dl slime, eBubble
enemyDefsH:
    .dh slime, eBubble

slime:
    .db $35,%00000011,$35,%01000011,$FE
eBubble
    .db $40,%00000011,$FE

enemyConstants:
    .db $00,$08,$10,$18

enemyHeadersL:
    .dl enemyHeader00, enemyHeader01, enemyHeader02, enemyHeader03, enemyHeader04
    .dsb $0B,$00
    .dl enemyHeader10, enemyHeader11, enemyHeader12, enemyHeader13
    .dsb $0C,$00
    .dl enemyHeader20, enemyHeader21, enemyHeader22, enemyHeader23
    .dsb $0C,$00
    .dl enemyHeader30, enemyHeader31, enemyHeader32, enemyHeader33
    .dsb $0C,$00

enemyHeadersH:
    .dh enemyHeader00, enemyHeader01, enemyHeader02, enemyHeader03, enemyHeader04
    .dsb $0B,$00
    .dh enemyHeader10, enemyHeader11, enemyHeader12, enemyHeader13
    .dsb $0C,$00
    .dh enemyHeader20, enemyHeader21, enemyHeader22, enemyHeader23
    .dsb $0C,$00
    .dh enemyHeader30, enemyHeader31, enemyHeader32, enemyHeader33
    .dsb $0C,$00

enemyFlags:
    .db %00000000, %00000011, %00000000, %00000000, %00000000
    .dsb $0B,$00
    .db %00000000, %00000000, %00000000, %00000000
    .dsb $0C,$00
    .db %00000000, %00000000, %00000000, %00000000
    .dsb $0C,$00
    .db %00000000, %00000000, %00000000, %00000001
    .dsb $0C,$00

enemyHeader00:
    .db $00

enemyHeader01:
    .db $04
    .dl slime
    .dh slime
    .db $20,$30,$40,$50
    .db $20,$30,$40,$50
    ;    Y, Tile No,  rotation & palette,  X
;    .db $5F,  $35,       %00000011,       $30  ; Enemy1 sprite 1
;    .db $5F,  $35,       %01000011,       $38  ; Enemy1 sprite 2

;    .db $67,  $35,       %00000011,       $48  ; Enemy2 sprite 1
;    .db $67,  $35,       %01000011,       $50  ; Enemy2 sprite 2
;    .db $00                                    ; No more enemy data for this room

enemyHeader02:
enemyHeader03:
enemyHeader04:
    .db $00

enemyHeader10:
    .db $01
    .dl eBubble
    .dh eBubble
    .db $20
    .db $20

enemyHeader11:
    .db $04
    .dl slime
    .dh slime
    .db $20,$30,$40,$50
    .db $20,$30,$40,$50


enemyHeader12:
    .db $00

enemyHeader13:
    .db $00

enemyHeader20:
    .db $00

enemyHeader21:
    .db $00

enemyHeader22:
    .db $00

enemyHeader23:
    .db $00

enemyHeader30:
    .db $00
enemyHeader31:
    .db $00
enemyHeader32:
    .db $00
enemyHeader33:
    .db $5F,$35,%00000011,$60
    .db $5F,$36,%00000011,$68
    .db $00
