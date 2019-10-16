latchController:
    lda #$01
    sta controller1
    lda #$00
    sta controller1

    lda buttons
    sta oldButtons

    ldx #$08
@loop
    lda controller1
    lsr
    rol buttons
    dex
    bne @loop
latchControllerDone:
    rts

SCREEN_TOP      = $10
SCREEN_BOTTOM   = $C0
SCREEN_LEFT     = $09
SCREEN_RIGHT    = $F0

facingUp        = $08
facingDown      = $04
facingLeft      = $02
facingRight     = $01

readA:
    lda buttons
    and #%10000000
    beq readAdone
    
    lda oldButtons
    and #%10000000
    bne readAdone

    lda #$00
    sta chestNo
    jsr checkChests
readAdone:
    rts

readB:
    lda buttons
    and #%01000000
    beq readBdone

    lda oldButtons
    and #%01000000
    bne readBdone
readBdone:
    rts

readUp:
    lda buttons
    and #%00001000
    beq readUpDone
    
    lda oldButtons
    and #%00001000
    bne @skip
    lda #$FF
    sta frameCounter

@skip
    lda playerY
    cmp #SCREEN_TOP
    bcc checkNametableUp

    lda #$00
    sta downIsPressed
    sta leftIsPressed
    sta rightIsPressed
    lda #$01
    sta upIsPressed
    sta animationEnable
    lda #facingUp
    sta playerDir

    ldx #$03
    stx animConstNumber
    inx
    stx animConstNumber+1
    inx
    stx animConstNumber+2
    rts
checkNametableUp:
;    lda nametable
;    and #$F0
;    beq readUpDone
    lda nametable
    sec
    sbc #$10
    sta nametable
    inc needDraw
    lda #$00
    sta gameState
    lda #SCREEN_BOTTOM
    sta playerY
readUpDone:
    rts

readDown:
    lda buttons
    and #%00000100
    beq readDownDone
    
    lda oldButtons
    and #%00000100
    bne @skip
    lda #$FF
    sta frameCounter

@skip
    lda playerY
    cmp #SCREEN_BOTTOM
    bcs checkNametableDown

    lda #$00
    sta upIsPressed
    sta leftIsPressed
    sta rightIsPressed
    lda #$01
    sta downIsPressed
    sta animationEnable
    lda #facingDown
    sta playerDir

    ldx #$00
    stx animConstNumber
    inx
    stx animConstNumber+1
    inx
    stx animConstNumber+2
    rts
checkNametableDown:
;    lda nametable
;    and #$F0
;    cmp #$30
;    beq readDownDone
    lda nametable
    clc
    adc #$10
    sta nametable
    inc needDraw
    lda #$00
    sta gameState
    lda #SCREEN_TOP
    sta playerY
readDownDone:
    rts

readLeft:
    lda buttons
    and #%00000010
    beq readLeftDone
    
    lda oldButtons
    and #%00000010
    bne @skip
    lda #$FF
    sta frameCounter

@skip
    lda playerX
    cmp #SCREEN_LEFT
    bcc checkNametableLeft

    lda #$00
    sta upIsPressed
    sta downIsPressed
    sta rightIsPressed
    lda #$01
    sta leftIsPressed
    sta animationEnable
    lda #facingLeft
    sta playerDir

    ldx #$06
    stx animConstNumber
    inx
    stx animConstNumber+1
    inx
    stx animConstNumber+2
    rts
checkNametableLeft:
;    lda nametable
;    and #$0F
;    beq readLeftDone
    dec nametable
    inc needDraw
    lda #$00
    sta gameState
    lda #SCREEN_RIGHT
    sta playerX
readLeftDone:
    rts

readRight:
    lda buttons
    and #%00000001
    beq readRightDone
    
    lda oldButtons
    and #%00000001
    bne @skip
    lda #$FF
    sta frameCounter

@skip
    lda playerX
    cmp #SCREEN_RIGHT
    bcs checkNametableRight

    lda #$00
    sta upIsPressed
    sta downIsPressed
    sta leftIsPressed
    lda #$01
    sta rightIsPressed
    sta animationEnable
    lda #facingRight
    sta playerDir

    ldx #$09
    stx animConstNumber
    inx
    stx animConstNumber+1
    inx
    stx animConstNumber+2
    rts
checkNametableRight
    ;lda nametable
    ;and #$0F
    ;cmp #$03
    ;beq readRightDone
    inc nametable
    inc needDraw
    lda #$00
    sta gameState
    lda #SCREEN_LEFT
    sta playerX
readRightDone:
    rts
    
moveUp:
    lda upIsPressed
    beq moveUpDone
    lda leftIsPressed
    bne moveUpDone
    lda rightIsPressed
    bne moveUpDone
    lda playerSpeed+1
    sec
    sbc #$00;40
    sta playerSpeed+1
    lda playerY
    sbc playerSpeed
    sta playerY
    jsr checkCollision
    lda #$00
    sta upIsPressed
moveUpDone:
    rts

moveDown:
    lda downIsPressed
    beq moveDownDone
    lda leftIsPressed
    bne moveDownDone
    lda rightIsPressed
    bne moveDownDone
    lda playerSpeed+1
    clc
    adc #$00;40
    sta playerSpeed+1
    lda playerY
    adc playerSpeed
    sta playerY
    jsr checkCollision
    lda #$00
    sta downIsPressed
moveDownDone:
    rts

moveLeft:
    lda leftIsPressed
    beq moveLeftDone
    lda upIsPressed
    bne moveLeftDone
    lda downIsPressed
    bne moveLeftDone
    lda playerSpeed+1
    sec
    sbc #$00;40
    sta playerSpeed+1
    lda playerX
    sbc playerSpeed
    sta playerX
    jsr checkCollision
    lda #$00
    sta leftIsPressed
moveLeftDone:
    rts

moveRight:
    lda rightIsPressed
    beq moveRightDone
    lda upIsPressed
    bne moveRightDone
    lda downIsPressed
    bne moveRightDone
    lda playerSpeed+1
    clc
    adc #$00;40
    sta playerSpeed+1
    lda playerX
    adc playerSpeed
    sta playerX
    jsr checkCollision
    lda #$00
    sta rightIsPressed
moveRightDone:
    rts
    
updateSpriteLoc
    lda playerY
    sta spriteRAM+0
    clc
    adc #$08
    sta spriteRAM+4
    sta spriteRAM+8
    clc
    adc #$08
    sta spriteRAM+12
    sta spriteRAM+16

    lda playerX
    sta spriteRAM+3
    sec
    sbc #$04
    sta spriteRAM+7
    sta spriteRAM+15
    clc
    adc #$08
    sta spriteRAM+11
    sta spriteRAM+19
updateSpriteLocDone:
    rts
