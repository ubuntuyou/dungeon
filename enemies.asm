enemyLogic:
    lda enemyFlagsTemp
    beq enemyLogicDone
    lda enemySpeed+1
    clc
    adc #$20
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
    cpx enemyCtr
    bne vertical
enemyLogicDone:
    rts

updateEnemyLoc:
	lda enemyCtr
	beq updateEnemyLocDone  ; Moves all sprites in each enemy relative to the X/Y position of it's origin sprite
    ldy #$00                ;  so only one X/Y location needs to be tracked for each enemy.
    ldx #$00
    stx temp

@loop
    lda enemyIndex,x
    tax
    lda enemyY,y
    sta enemyRAM+0,x
    sta enemyRAM+4,x
    lda enemyX,y
    sta enemyRAM+3,x
    clc
    adc #$08
    sta enemyRAM+7,x
    inc temp
    ldx temp
    iny
    cpy enemyCtr
    bne @loop
updateEnemyLocDone:
    rts

enemyLoad:
    ldx #$00
    stx enemyFlagsTemp
    stx enemyY+0            ; Blank out enemy X/Y vars
    stx enemyY+1
    stx enemyY+2
    stx enemyY+3
    stx enemyX+0
    stx enemyX+1
    stx enemyX+2
    stx enemyX+3

    dex
    txa
    inx
@clr                        ; Clear enemyRAM
    sta enemyRAM,x
    inx
    cpx #$40
    bne @clr

    ldx #$00
    ldy #$00

    lda (enemyPtr),y
    sta enemyCtr            ; Store first element of enemy header in enemyCmp
    bne @continue	        ; If #$00 then we're done
	rts

@continue
    iny
    lda (enemyPtr),y
    sta enemyDefPtr+0
    iny                     ; Fill enemy definition pointer from second element of enemy header
    lda (enemyPtr),y
    sta enemyDefPtr+1
    iny

    ldx #$00 	          	; Starting X/Y locations might eventually come from RNG rather than being hard coded
@loop
    lda (enemyPtr),y
    sta enemyY,x          	; Fill starting enemyY locations from enemy header
    iny
    inx
    cpx enemyCtr
    bne @loop

    ldx #$00
@loop2
    lda (enemyPtr),y
    sta enemyX,x          	; Fill starting enemyX locations from enemy header
    iny
    inx
    cpx enemyCtr
    bne @loop2

    ldx #$00
@loop3
    lda (enemyPtr),y
    sta enemyIndex,x      	; Fill enemyIndex for enemyRAM offsets
    iny
    inx
    cpx enemyCtr
    bne @loop3

    lda #$FF
    sta temp                ; Initialize temp to #$FF so that first loop sets it to #$00
	ldx #$00
@loop4
    ldy temp
    iny
    cpy enemyCtr
    beq enemyLoadDone       ; If temp == enemyCtr then we're done here
    sty temp                ; Otherwise store new value to temp and load a sprite
    sec
    rol enemyFlagsTemp
	ldy #$00
@loop5
    lda #$00
    sta enemyRAM+0,x
    sta enemyRAM+3,x
    lda (enemyDefPtr),y     ; Load enemy def byte
    cmp #$FF                ; If #$FF then sprite is done
    beq @loop4              ; Back to loop for next enemy

    sta enemyRAM+1,x        ; Else store byte, load next byte and store it.
    iny
    lda (enemyDefPtr),y
    sta enemyRAM+2,x
    iny
    inx
    inx
    inx
    inx                     ; Increment X and Y counters
    bne @loop5              ; Always branch
enemyLoadDone:
    rts

    ; Still need to figure out enemyIndex

enemyDefsL:
    .dl slime, eBubble
enemyDefsH:
    .dh slime, eBubble

slime:
    .db $35,%00000011,$35,%01000011,$FF
eBubble
    .db $40,%00000011,$FF

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

enemyHeader00:
    .db $00

enemyHeader01:
    .db $04                 ; Number of enemies in room
    .dl slime               ; Low byte of pointer to enemyDef
    .dh slime               ; High byte of pointer to enemyDef
    .db $20,$30,$40,$50     ; Enemy starting Y locations ; These will be changed to packed hex
    .db $20,$30,$40,$50     ; Enemy starting X locations ; Y = ($nn & $F0) >> 4; X = ($nn & $0F)
    .db $00,$08,$10,$18     ; Index values for enemyRAM offsets

enemyHeader02:
enemyHeader03:
enemyHeader04:
    .db $00

enemyHeader10:
    .db $05
    .dl eBubble
    .dh eBubble
    .db $40,$60,$80,$A0,$C0
    .db $68,$80,$98,$30,$50
    .db $00,$04,$08,$0C,$10

enemyHeader11:
    .db $04
    .dl slime
    .dh slime
    .db $20,$30,$40,$50
    .db $20,$30,$40,$50
	.db $00,$08,$10,$18

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
    .db $01
    .dl eBubble
    .dh eBubble
    .db $40
    .db $68
    .db $00
