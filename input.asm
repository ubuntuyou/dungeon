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
    and #%10000000          ; If A button is not pressed then we're done
    beq readAdone

    lda oldButtons
    and #%10000000          ; If A button is pressed and was also pressed last frame then we're done
    bne readAdone

    lda #$00
    sta itemNo              ; Else initialize itemNo counter
    jsr checkItems          ;  and check items for collision

readAdone:
    rts

readB:
    lda buttons
    and #%01000000          ; If B button is not pressed then we're done
    beq readBdone

    lda oldButtons
    and #%01000000          ; If B button is pressed and was also pressed last frame then we're done
    bne readBdone

    ldx PS
    inx
    stx PS
    cpx #$04
    bne readBdone
    ldx #$01
    stx PS
readBdone:
    rts

readUp:
    lda buttons
    and #%00001000          ; If Up is not pressed then we're done
    beq readUpDone

    lda oldButtons
    and #%00001000          ; If Up is pressed and was pressed last frame then we're done
    bne @skip
    lda #$FF
    sta frameCounter        ; Else initialize frameCounter for movement animation in new direction

@skip
    lda playerY
    cmp #SCREEN_TOP
    bcc checkNametableUp    ; If (playerY <= SCREEN_TOP) nametable -= #$10;

    lda #$00
    sta downIsPressed       ; Else clear other directions
    sta leftIsPressed
    sta rightIsPressed
    lda #$01
    sta upIsPressed         ; Set upIsPressed flag, animation enable flag, and player direction
    sta animationEnable
    lda PS
    eor #$FF
    clc
    adc #$01
    sta playerSpeed
    lda #facingUp
    sta playerDir

    ldx #$03
    stx animConstNumber
    inx
    stx animConstNumber+1
    inx
    stx animConstNumber+2   ; Load constants for player animation frames
    rts                     ; Done
checkNametableUp:
    lda nametable
    sec
    sbc #$10
    sta nametable           ; nametable -= #$10
    inc needDraw            ; set needDraw flag and change gameState
    lda #$00
    sta gameState
    lda #SCREEN_BOTTOM
    sta playerY             ; Move player to other side of screen
readUpDone:
    rts

readDown:
    lda buttons
    and #%00000100          ; If Right is not pressed we're done
    beq readDownDone

    lda oldButtons
    and #%00000100          ; If Right is pressed and was pressed last frame then we're done
    bne @skip
    lda #$FF
    sta frameCounter        ; Else initialize frame counter for movement animation in new direction

@skip
    lda playerY
    cmp #SCREEN_BOTTOM
    bcs checkNametableDown  ; If (playerY >= SCREEN_BOTTOM) nametable += #$10;

    lda #$00
    sta upIsPressed         ; Else clear other directions
    sta leftIsPressed
    sta rightIsPressed
    lda #$01
    sta downIsPressed       ; Set downIsPressed flag, animationEnable flag, and player direction
    sta animationEnable
    lda PS
    sta playerSpeed
    lda #facingDown
    sta playerDir

    ldx #$00
    stx animConstNumber
    inx
    stx animConstNumber+1
    inx
    stx animConstNumber+2   ; Load constants for player animation frames
    rts                     ; Done
checkNametableDown:
    lda nametable
    clc
    adc #$10
    sta nametable           ; nametable += #$10
    inc needDraw            ; Set needDraw flag and change gamestate
    lda #$00
    sta gameState
    lda #SCREEN_TOP
    sta playerY             ; Move player to other side of screen
readDownDone:
    rts

readLeft:
    lda buttons
    and #%00000010          ; If left is not pressed then we're done
    beq readLeftDone

    lda oldButtons
    and #%00000010          ; If left is pressed and was pressed last frame then we're done
    bne @skip
    lda #$FF
    sta frameCounter        ; Else initialize frame counter for movement animation in new direction

@skip
    lda playerX             ; If (playerX <= SCREEN_LEFT) nametable -= #$01;
    cmp #SCREEN_LEFT
    bcc checkNametableLeft

    lda #$00
    sta upIsPressed
    sta downIsPressed
    sta rightIsPressed      ; Else clear other directions
    lda #$01
    sta leftIsPressed       ; Set leftIsPressed flag, animationEnable flag, and player direction
    sta animationEnable
    lda PS
    eor #$FF
    clc
    adc #$01
    sta playerSpeed
    lda #facingLeft
    sta playerDir

    ldx #$06
    stx animConstNumber
    inx
    stx animConstNumber+1
    inx
    stx animConstNumber+2   ; Load constants for player animation frames
    rts                     ; Done
checkNametableLeft:
    dec nametable           ; nametable -= #$01
    inc needDraw            ; Set needDraw flag and change gameState
    lda #$00
    sta gameState
    lda #SCREEN_RIGHT
    sta playerX             ; Move player to other side of screen
readLeftDone:
    rts

readRight:
    lda buttons
    and #%00000001          ; If Right is not pressed then we're done
    beq readRightDone

    lda oldButtons
    and #%00000001          ; If Right is pressed and was pressed last frame then we're done
    bne @skip
    lda #$FF
    sta frameCounter        ; Initialize frame counter for movement animation in new direction

@skip
    lda playerX             ; If (playerX >= SCREEN_RIGHT) nametable += 1;
    cmp #SCREEN_RIGHT
    bcs checkNametableRight

    lda #$00
    sta upIsPressed
    sta downIsPressed
    sta leftIsPressed       ; Else clear other directions
    lda #$01
    sta rightIsPressed      ; Set rightIsPressed flag, animationEnable flag, and player direction
    sta animationEnable
    lda PS
    sta playerSpeed
    lda #facingRight
    sta playerDir

    ldx #$09
    stx animConstNumber
    inx
    stx animConstNumber+1
    inx
    stx animConstNumber+2   ; Load constants for player animation frames
    rts                     ; Done
checkNametableRight
    inc nametable           ; nametable += 1
    inc needDraw            ; Set needDraw flag and change gameState
    lda #$00
    sta gameState
    lda #SCREEN_LEFT
    sta playerX             ; Move player to other side of the screen
readRightDone:
    rts

moveV:
    lda upIsPressed
    bne @move
    lda downIsPressed
    bne @move
    rts
@move
    lda leftIsPressed
    bne moveVDone          ; If neither Up or Down is pressed or anything other than Up is pressed then skip
    lda rightIsPressed
    bne moveVDone

    lda playerY
    clc
    adc playerSpeed
    sta playerY

    jsr checkPlayerColV     ; Check for collision with background
    lda #$00
    sta upIsPressed         ; And clear upIsPressed flag
    sta downIsPressed
moveVDone:
    rts

moveH:
    lda leftIsPressed
    bne @move
    lda rightIsPressed
    bne @move
    rts
@move
    lda upIsPressed
    bne moveHDone        ; If neither Left or Right is pressed or anything other than Left is pressed then skip
    lda downIsPressed
    bne moveHDone

    lda playerX
    clc
    adc playerSpeed
    sta playerX

    jsr checkPlayerColH     ; Check for collision with background
    lda #$00
    sta leftIsPressed       ; And clear leftIsPressed flag
    sta rightIsPressed
moveHDone:
    rts

updateSpriteLoc:            ; Moves all sprites relative to the X/Y position of the origin sprite
    lda playerY             ;  so only one X/Y location needs to be tracked.
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
