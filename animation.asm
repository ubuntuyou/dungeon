updateFrames:
    lda #<spriteAnim         ; Load animation pointers
    sta animationPtr
    lda #>spriteAnim
    sta animationPtr+1

    lda buttons
    and #$0F
    bne frameCheck
    lda frameCounter
    bne playingFrame2
    lda #$00
    sta animationEnable
    rts

frameCheck:
    lda playerDir
    cmp playerDirOld
    bne playingFrame1

    ldx frameCounter          ; Load frameCounter
    beq playingFrame1         ; Determine which frame to setup
    cpx #$0C
    beq playingFrame2
    cpx #$18
    beq playingFrame3
    cpx #$24
    beq playingFrame2
    rts                       ; If no change needed then skip setup

playingFrame1:
    lda animConstNumber+0     ; Load animation constant number
    sta animationNumber       ; and store in animationNumber
    jmp animateSprites        ; Jump to end

playingFrame2:                ; Same as playingFrame1
    lda animConstNumber+1
    sta animationNumber
    jmp animateSprites

playingFrame3:                ; Same as playingFrame1
    lda animConstNumber+2
    sta animationNumber

animateSprites:
    lda animationEnable       ; Check if animation enabled
    beq animateSpritesDone    ; If not then do nothing

    ldx animationNumber       ; Use animationNumber as offset to 
    ldy animationConstants,x  ;  load correct animationConstant

    ldx #$00
@loop
    inx
    lda (animationPtr),y
    sta spriteRAM,x
    iny
    inx
    lda (animationPtr),y      ; Fill in spriteRAM with new frame 
    sta spriteRAM,x
    iny
    inx
    inx
    cpx #$14
    bne @loop
animateSpritesDone:
    rts
