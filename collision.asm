checkCollision:
up:
    lda upIsPressed
    beq down
    lda playerY
    clc
    adc #$10
    sta spriteY
    lda playerX
    sec
    sbc #$02
    sta spriteX
    jsr compareToBackground

    lda playerY
    clc
    adc #$10
    sta spriteY
    lda playerX
    clc
    adc #$09
    sta spriteX
    bvc compareToBackground
down:
    lda downIsPressed
    beq left
    lda playerY
    clc
    adc #$19
    sta spriteY
    lda playerX
    sec
    sbc #$02
    sta spriteX
    jsr compareToBackground

    lda playerY
    clc
    adc #$19
    sta spriteY
    lda playerX
    clc
    adc #$09
    sta spriteX
    bvc compareToBackground
left:
    lda leftIsPressed
    beq right
    lda playerY
    clc 
    adc #$11
    sta spriteY
    lda playerX
    sec
    sbc #$03
    sta spriteX
    jsr compareToBackground
    
    lda playerY
    clc
    adc #$18
    sta spriteY
    lda playerX
    sec
    sbc #$03
    sta spriteX
    bvc compareToBackground
right:
    lda rightIsPressed
    beq checkCollisionDone
    lda playerY
    clc 
    adc #$11
    sta spriteY
    lda playerX
    clc
    adc #$0A
    sta spriteX
    jsr compareToBackground

    lda playerY
    clc
    adc #$18
    sta spriteY
    lda playerX
    clc
    adc #$0A
    sta spriteX
    bvc compareToBackground
checkCollisionDone:
    rts
    
compareToBackground:
    jsr getBGtype
    bne cpUp
    rts
cpUp:
    lda upIsPressed
    beq cpDown
    lda playerY
    tay
    clc
    adc #$10
    and #$0F
    eor #$0F
    sta temp
    tya
    clc
    adc temp
    sta playerY
    rts
cpDown:
    lda downIsPressed
    beq cpLeft
    lda playerY
    tay
    clc
    adc #$19
    and #$0F
    sta temp
    tya
    sec
    sbc temp
    sta playerY
    rts
cpLeft:
    lda leftIsPressed
    beq cpRight
    lda playerX
    tax
    sec
    sbc #$03
    and #$0F
    eor #$0F
    sta temp
    txa
    clc
    adc temp
    sta playerX
    rts
cpRight:
    lda rightIsPressed
    beq compareToBackgroundDone
    lda playerX
    tax
    clc
    adc #$0A
    and #$0F
    sta temp
    txa
    sec
    sbc temp
    sta playerX
compareToBackgroundDone:
    rts

getBGtype:
    lda spriteX
    lsr A
    lsr A
    lsr A
    lsr A
    sta spriteXpos
    
    lda spriteY
    and #$F0
    clc
    adc spriteXpos
    sta spriteYpos

    ldx nametable
    lda bkgL,x
    sta collisionPtr
    lda bkgH,x
    sta collisionPtr+1
    
    ldy spriteYpos
    lda (collisionPtr),y
    tax
    lda metaAtb,x
    sta BGtype
getBGtypeDone:
    rts
    
updateSpriteCol:
updatePlayerCol:
    lda playerY
    clc
    adc #$06
    sta playerY0
    clc
    adc #$10
    sta playerY1
    
    lda playerX
    clc
    adc #$01
    sta playerX0
    clc
    adc #$07
    sta playerX1
updatePlayerColDone:
    rts

updateChestCol:
    lda playerDir
    cmp #facingUp
    beq chestColUp
    cmp #facingDown
    beq chestColDown
    cmp #facingLeft
    beq chestColLeft
    bvc chestColRight

chestColUp:
    lda chestConstants,x
    tax
    lda itemRAM,x
    clc
    adc #$08
    sta chestY0
    lda itemRAM+4,x
    clc
    adc #$08
    sta chestY1

    lda itemRAM+3,x
    clc
    adc #$09
    sta chestX0
    lda itemRAM+3,x
    clc
    adc #$09
    sta chestX1
    rts
    
chestColDown:
    lda chestConstants,x
    tax
    lda itemRAM,x
    sec
    sbc #$02
    sta chestY0
    lda itemRAM+4,x
    sec
    sbc #$02
    sta chestY1

    lda itemRAM+3,x
    clc
    adc #$08
    sta chestX0
    lda itemRAM+3,x
    clc
    adc #$08
    sta chestX1
    rts
    
chestColLeft:
    lda chestConstants,x
    tax
    lda itemRAM,x
    clc
    adc #$08
    sta chestY0
    lda itemRAM+4,x
    clc
    adc #$09
    sta chestY1

    lda itemRAM+3,x
    clc
    adc #$14
    sta chestX0
    lda itemRAM+3,x
    clc
    adc #$14
    sta chestX1
    rts
    
chestColRight:
    lda chestConstants,x
    tax
    lda itemRAM,x
    clc
    adc #$08
    sta chestY0
    lda itemRAM+4,x
    clc
    adc #$09
    sta chestY1

    lda itemRAM+3,x
    sec
    sbc #$03
    sta chestX0
    lda itemRAM+3,x
    sec
    sbc #$03
    sta chestX1
updateChestColDone:
    rts

itemCollision:
    lda playerX1
    cmp chestX0
    bcc @noHit

    lda playerY1
    cmp chestY0
    bcc @noHit

    lda chestX1
    cmp playerX0
    bcc @noHit

    lda chestY1
    cmp playerY0
    bcc @noHit

@hit:
    ldx #$00
    stx textCounter
    stx lineNo
    stx textIndirect
    inx
    stx textBoxActive
    inx
    stx gameState

    ldx chestNo
    stx chestHdrNo
    lda chestConstants,x
    tax
    inc itemRAM+1,x
    inc itemRAM+5,x

    ldx nametable
    ldy chestNo
    lda itemSoftFlags,x
    eor bitMask,y
    sta itemSoftFlags,x

    lda #$01
    sta prgNo
@noHit:
    rts
itemCollisionDone:
    
checkChests:
    ldx nametable
    lda itemSoftFlags,x
    sta itemFlagsTemp

@loop:
    ldx chestNo
    lda itemFlagsTemp
    and bitMask,x
    beq @skip

    jsr updateChestCol
    jsr itemCollision

@skip:
    inc chestNo
    lda chestNo
    cmp #$08
    bne @loop
checkChestsDone:
    rts