enemyLogic:
    lda enemyFlagsTemp
    bne @next
    rts
@next
    lda enemySpeed+1
    clc
    adc #$20
    sta enemySpeed+1
    lda #$00
    adc #$00
    sta temp
    
    lda enemyBBmodY
	lsr
	sta temp+1
	lda enemyBBmodX
	lsr
	sta temp+2

    ldx enemyCtr                ; First need to calculate all of enemies next movements
vertical:                       ;  then update their individual enemyY and enemyX vars
	lda #$00
	sta enemyDir,x              ; Clear enemyDir
    lda enemyY,x
    sec
    sbc enemyBBmodY
    cmp playerY
    beq horizontal
    bcc @down
@up
    lda enemyY,x
    sec
    sbc temp
    sta enemyY,x
    lda enemyDir,x
    ora #facingUp
    sta enemyDir,x
    bne horizontal
@down
    lda enemyY,x
    clc
    adc temp
    sta enemyY,x
    lda enemyDir,x
    ora #facingDown
    sta enemyDir,x

horizontal:
    lda enemyX,x
    cmp playerX
    beq @next
    bcc @right
@left
    lda enemyX,x
    sec
    sbc temp
    sta enemyX,x
    lda enemyDir,x
    ora #facingLeft
    sta enemyDir,x
    bne @next
@right
    lda enemyX,x
    clc
    adc temp
    sta enemyX,x
    lda enemyDir,x
    ora #facingRight
    sta enemyDir,x

@next
	jsr checkEnemyCol
    dex
    bpl vertical
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

loadEnemies:
clearEnemyVars:
    ldx #$00
    stx enemyFlagsTemp
    stx enemyY+0            ; Blank out enemy X/Y vars
    stx enemyY+1
    stx enemyY+2
    stx enemyY+3
    stx enemyY+4
    stx enemyY+5
    stx enemyY+6
    stx enemyY+7

    stx enemyX+0
    stx enemyX+1
    stx enemyX+2
    stx enemyX+3
    stx enemyX+4
    stx enemyX+5
    stx enemyX+6
    stx enemyX+7

    dex
    txa
clearEnemyRAM:
    inx
@clr                        ; Clear enemyRAM
    sta enemyRAM,x
    inx
    cpx #$40
    bne @clr

    ldx #$00
    ldy #$00
loadEnemyHeaders:
    lda (enemyPtr),y
    sta enemyCtr            ; Store first element of enemy header in enemyCmp
    beq loadEnemiesDone     ; If #$00 then we're done

    iny
    lda (enemyPtr),y
    sta enemyDefPtr+0
    iny                     ; Fill enemy definition pointer from second element of enemy header
    lda (enemyPtr),y
    sta enemyDefPtr+1
    iny

    ldx #$00
@loop
    lda (enemyPtr),y
    sta enemyIndex,x        ; Fill enemyIndex for enemyRAM offsets
    iny
    inx
    cpx enemyCtr
    bne @loop

loadEnemyCoords:
    ldx enemyCtr
@loop
    jsr random
    tay
    lda colRAM,y
;    tay
;    lda metaAtb,y
    bne @loop

    lda RNG
    tay

    asl
    asl
    asl
    asl
    sta enemyX-1,x
    tya
    and #$F0
    sta enemyY-1,x
    dex
    bne @loop

loadEnemyDefs:
    lda enemyCtr
    sta temp                ; Initialize temp to #$FF so that first loop sets it to #$00
    ldx #$00
@loop
    sty temp+1
    ldy temp
    dey
    bmi loadEnemyBB         ; If temp == #$FF then we're done here
    sty temp                ; Otherwise store new value to temp and load a sprite
    sec
    rol enemyFlagsTemp

    ldy #$00
@loop1
    lda (enemyDefPtr),y     ; Load enemy def byte
    cmp #$FF                ; If #$FF then sprite is done
    beq @loop              ; Back to loop for next enemy

    sta enemyRAM+1,x        ; Else store byte, load next byte and store it.
    iny
    lda (enemyDefPtr),y
    sta enemyRAM+2,x
    iny
    inx
    inx
    inx
    inx                     ; Increment X and Y counters
    bne @loop1              ; Always branch

loadEnemyBB:
    ldy temp+1
    iny
    lda (enemyDefPtr),y
    sta enemyBBmodY
    iny
    lda (enemyDefPtr),y
    sta enemyBBmodX
loadEnemiesDone:
    rts

enemyDefsL:
    .dl slime, eBubble
enemyDefsH:
    .dh slime, eBubble

slime:
    .db $35,%00000011,$35,%01000011,$FF,$08,$0E
eBubble
    .db $40,%00000010,$FF,$08,$08

enemyHeadersL:
    .dl enemyHeader00, enemyHeader01, enemyHeader02, enemyHeader03
    .dl enemyHeader04, enemyHeader05, enemyHeader06, enemyHeader07
    .dl enemyHeader08, enemyHeader09, enemyHeader0A, enemyHeader0B
    .dl enemyHeader0C, enemyHeader0D, enemyHeader0E, enemyHeader0F

    .dl enemyHeader10, enemyHeader11, enemyHeader12, enemyHeader13
    .dl enemyHeader14, enemyHeader15, enemyHeader16, enemyHeader17
    .dl enemyHeader18, enemyHeader19, enemyHeader1A, enemyHeader1B
    .dl enemyHeader1C, enemyHeader1D, enemyHeader1E, enemyHeader1F

    .dl enemyHeader20, enemyHeader21, enemyHeader22, enemyHeader23
    .dl enemyHeader24, enemyHeader25, enemyHeader26, enemyHeader27
    .dl enemyHeader28, enemyHeader29, enemyHeader2A, enemyHeader2B
    .dl enemyHeader2C, enemyHeader2D, enemyHeader2E, enemyHeader2F

    .dl enemyHeader30, enemyHeader31, enemyHeader32, enemyHeader33
    .dl enemyHeader34, enemyHeader35, enemyHeader36, enemyHeader37
    .dl enemyHeader38, enemyHeader39, enemyHeader3A, enemyHeader3B
    .dl enemyHeader3C, enemyHeader3D, enemyHeader3E, enemyHeader3F

enemyHeadersH:
    .dh enemyHeader00, enemyHeader01, enemyHeader02, enemyHeader03
    .dh enemyHeader04, enemyHeader05, enemyHeader06, enemyHeader07
    .dh enemyHeader08, enemyHeader09, enemyHeader0A, enemyHeader0B
    .dh enemyHeader0C, enemyHeader0D, enemyHeader0E, enemyHeader0F

    .dh enemyHeader10, enemyHeader11, enemyHeader12, enemyHeader13
    .dh enemyHeader14, enemyHeader15, enemyHeader16, enemyHeader17
    .dh enemyHeader18, enemyHeader19, enemyHeader1A, enemyHeader1B
    .dh enemyHeader1C, enemyHeader1D, enemyHeader1E, enemyHeader1F

    .dh enemyHeader20, enemyHeader21, enemyHeader22, enemyHeader23
    .dh enemyHeader24, enemyHeader25, enemyHeader26, enemyHeader27
    .dh enemyHeader28, enemyHeader29, enemyHeader2A, enemyHeader2B
    .dh enemyHeader2C, enemyHeader2D, enemyHeader2E, enemyHeader2F

    .dh enemyHeader30, enemyHeader31, enemyHeader32, enemyHeader33
    .dh enemyHeader34, enemyHeader35, enemyHeader36, enemyHeader37
    .dh enemyHeader38, enemyHeader39, enemyHeader3A, enemyHeader3B
    .dh enemyHeader3C, enemyHeader3D, enemyHeader3E, enemyHeader3F

enemyHeader00:
    .db $00

enemyHeader01:
    .db $04                 ; Number of enemies in room
    .dl slime               ; Low byte of pointer to enemyDef
    .dh slime               ; High byte of pointer to enemyDef
    .db $00,$08,$10,$18     ; Index values for enemyRAM offsets
enemyHeader02:
enemyHeader03:
enemyHeader04:
enemyHeader05:
enemyHeader06:
enemyHeader07:
enemyHeader08:
enemyHeader09:
enemyHeader0A:
enemyHeader0B:
enemyHeader0C:
enemyHeader0D:
enemyHeader0E:
enemyHeader0F:
    .db $00

enemyHeader10:
    .db $05
    .dl eBubble
    .dh eBubble
    .db $00,$04,$08,$0C,$10

enemyHeader11:
    .db $04
    .dl slime
    .dh slime
    .db $00,$08,$10,$18

enemyHeader12:
enemyHeader13:
enemyHeader14:
enemyHeader15:
enemyHeader16:
enemyHeader17:
enemyHeader18:
enemyHeader19:
enemyHeader1A:
enemyHeader1B:
enemyHeader1C:
enemyHeader1D:
enemyHeader1E:
enemyHeader1F:
    .db $00

enemyHeader20:
enemyHeader21:
enemyHeader22:
enemyHeader23:
enemyHeader24:
enemyHeader25:
enemyHeader26:
enemyHeader27:
enemyHeader28:
enemyHeader29:
enemyHeader2A:
enemyHeader2B:
enemyHeader2C:
enemyHeader2D:
enemyHeader2E:
enemyHeader2F:
    .db $00


enemyHeader33:
    .db $01
    .dl eBubble
    .dh eBubble
    .db $00

enemyHeader30:
enemyHeader31:
enemyHeader32:
enemyHeader34:
enemyHeader35:
enemyHeader36:
enemyHeader37:
enemyHeader38:
enemyHeader39:
enemyHeader3A:
enemyHeader3B:
enemyHeader3C:
enemyHeader3D:
enemyHeader3E:
enemyHeader3F:
    .db $00
