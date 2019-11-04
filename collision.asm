checkCollision:
up:
    lda upIsPressed         ; Checks player's hotspots for collision with background.
    beq down                ; Called in the moveUp, moveDown, moveLeft, moveRight routines.
    lda playerY             ; Adds/subtracts a specific amount to playerX/Y
    clc                     ;  so that instead of basing collision off of the player's top left corner
    adc #$10                ;  it can check various points around the sprite similar to a bounding box.
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
    jmp compareToBackground
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
    jmp compareToBackground
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
    jmp compareToBackground
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
    jmp compareToBackground
checkCollisionDone:
    rts

compareToBackground:
    jsr getBGtype           ; Get current background metatile attribute byte for (spriteY & #$F0) + (spriteX / 16)
    bne cpUp                ; If metatile type is passable then return
    rts                     ; Else allow the movement into unpassable metatile
cpUp:                       ;  then eject the player
    lda upIsPressed
    beq cpDown
    lda playerY
    tay
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
    adc #$09
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
    lda spriteX             ; Divides spriteX by 16 so that it corresponds to metatile columns
    lsr A
    lsr A
    lsr A
    lsr A
    sta spriteXpos

    lda spriteY             ; Then add high nybble of spriteY to correspond to metatile rows
    and #$F0
    clc
    adc spriteXpos
;    sta spriteYpos
	tay

    ldx nametable           ; Load pointers to get correct background
    lda bkgL,x
    sta collisionPtr
    lda bkgH,x
    sta collisionPtr+1

;    ldy spriteYpos
    lda (collisionPtr),y    ; Look up the metatile
    tax
    lda metaAtb,x           ; And use it to look up the metatile attribute
    sta BGtype              ; Store in BGtype for further use
getBGtypeDone:
    rts

updateEnemyCol:             ; Updates the enemy bounding boxes for sprite on sprite collision
    lda enemyConstants,x
    tax
    lda enemyRAM,x
;    clc
;    adc #$08
    sta enemy_TOP
;    lda enemyRAM+4,x
    clc
    adc #$08
    sta enemy_BOTTOM

    lda enemyRAM+3,x
    clc
    adc #$02
    sta enemy_LEFT
;    lda enemyRAM+3,x
    clc
    adc #$0F
    sta enemy_RIGHT
updateEnemyColDone:
	rts

updatePlayerCol:            ; Updates the players bounding box for sprite on sprite collision
    lda playerY
    clc
    adc #$06
    sta player_TOP
    clc
    adc #$10
    sta player_BOTTOM

    lda playerX
    clc
    adc #$01
    sta player_LEFT
    clc
    adc #$07
    sta player_RIGHT
updatePlayerColDone:
    rts


updateItemCol:
;     lda playerDir           ; Determines direction of player then loads bounding box info
;     cmp #facingUp           ; for items using chestConstants and X register to know which
;     beq itemColUp           ; item is currently being loaded
;     cmp #facingDown
;     beq itemColDown
;     cmp #facingLeft
;     beq itemColLeft
;     bvc itemColRight

; itemColUp:
    lda itemConstants,x
    tax
    lda itemRAM,x
    clc
    adc #$08
    sta item_TOP
    lda itemRAM+4,x
    clc
    adc #$08
    sta item_BOTTOM

    lda itemRAM+3,x
    clc
    adc #$09
    sta item_LEFT
    lda itemRAM+3,x
    clc
    adc #$09
    sta item_RIGHT
    rts

; itemColDown:
;     lda itemConstants,x
;     tax
;     lda itemRAM,x
;     sec
;     sbc #$02
;     sta itemY0
;     lda itemRAM+4,x
;     sec
;     sbc #$02
;     sta itemY1
;
;     lda itemRAM+3,x
;     clc
;     adc #$08
;     sta itemX0
;     lda itemRAM+3,x
;     clc
;     adc #$08
;     sta itemX1
;     rts
;
; itemColLeft:
;     lda itemConstants,x
;     tax
;     lda itemRAM,x
;     clc
;     adc #$08
;     sta itemY0
;     lda itemRAM+4,x
;     clc
;     adc #$09
;     sta itemY1
;
;     lda itemRAM+3,x
;     clc
;     adc #$14
;     sta itemX0
;     lda itemRAM+3,x
;     clc
;     adc #$14
;     sta itemX1
;     rts
;
; itemColRight:
;     lda itemConstants,x
;     tax
;     lda itemRAM,x
;     clc
;     adc #$08
;     sta itemY0
;     lda itemRAM+4,x
;     clc
;     adc #$09
;     sta itemY1
;
;     lda itemRAM+3,x
;     sec
;     sbc #$03
;     sta itemX0
;     lda itemRAM+3,x
;     sec
;     sbc #$03
;     sta itemX1
updateItemColDone:
    rts

itemCollision:
   lda player_RIGHT         ; Checks player bounding box for collision with item bounding box
   cmp item_LEFT            ; If hit is detected then switch to textbox state and process
   bcc @noHit               ; the appropriate message

   lda player_BOTTOM
   cmp item_TOP
   bcc @noHit

   lda item_RIGHT
   cmp player_LEFT
   bcc @noHit

   lda item_BOTTOM
   cmp player_TOP
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

    ldx itemNo
    stx itemHdrNo
;    lda itemConstants,x
;    tax
;    inc itemRAM+1,x
;    inc itemRAM+5,x

;    ldx nametable
;    ldy itemNo
;    lda itemSoftFlags,x
;    eor bitMask,y
;    sta itemSoftFlags,x

    lda #$01
    sta prgNo               ; Change prgNo for bank switch
@noHit:
itemCollisionDone:
    rts

enemyCollision:
   lda player_RIGHT         ; Checks player bounding box for collision with item bounding box
   cmp enemy_LEFT           ; If hit is detected then switch to textbox state and process
   bcc @noHit               ; the appropriate message

   lda player_BOTTOM
   cmp enemy_TOP
   bcc @noHit

   lda enemy_RIGHT
   cmp player_LEFT
   bcc @noHit

   lda enemy_BOTTOM
   cmp player_TOP
   bcc @noHit

@hit:
    lda playerX
    sec
    sbc #$10
    sta playerX

@noHit:
enemyCollisionDone:
    rts


checkItems:
    ldx nametable           ; Checks each item for collision with player
    lda itemSoftFlags,x
    sta itemFlagsTemp

@loop:
    ldx itemNo
    lda itemFlagsTemp
    and bitMask,x
    beq @skip

    jsr updateItemCol
    jsr itemCollision

@skip:
    inc itemNo
    lda itemNo
    cmp #$08
    bne @loop
checkItemsDone:
    rts

checkEnemies:
    ldx nametable           ; Checks each enemy for collision with player
    lda enemySoftFlags,x
    sta enemyFlagsTemp
    lda #$00
    sta enemyNo

@loop:
    ldx enemyNo
    lda enemyFlagsTemp
    and bitMask,x
    beq @skip

    jsr updateEnemyCol
    jsr enemyCollision

@skip:
    inc enemyNo
    lda enemyNo
    cmp #$08
    bne @loop
checkEnemiesDone:
    rts