; checkCollision:
; up:
;     lda upIsPressed         ; Checks player's hotspots for collision with background.
;     beq down                ; Called in the moveUp, moveDown, moveLeft, moveRight routines.
;     lda playerY             ; Adds/subtracts a specific amount to playerX/Y
;     clc                     ;  so that instead of basing collision off of the player's top left corner
;     adc #$10                ;  it can check various points around the sprite similar to a bounding box.
;     sta spriteY
;     lda playerX
;     sec
;     sbc #$02
;     sta spriteX
;     jsr compareToBackground
; 
;     lda playerY
;     clc
;     adc #$10
;     sta spriteY
;     lda playerX
;     clc
;     adc #$07
;     sta spriteX
;     jmp compareToBackground
; down:
;     lda downIsPressed
;     beq left
;     lda playerY
;     clc
;     adc #$18
;     sta spriteY
;     lda playerX
;     sec
;     sbc #$02
;     sta spriteX
;     jsr compareToBackground
; 
;     lda playerY
;     clc
;     adc #$18
;     sta spriteY
;     lda playerX
;     clc
;     adc #$07
;     sta spriteX
;     jmp compareToBackground
; left:
;     lda leftIsPressed
;     beq right
;     lda playerY
;     clc
;     adc #$11
;     sta spriteY
;     lda playerX
;     sec
;     sbc #$03
;     sta spriteX
;     jsr compareToBackground
; 
;     lda playerY
;     clc
;     adc #$18
;     sta spriteY
;     lda playerX
;     sec
;     sbc #$03
;     sta spriteX
;     jmp compareToBackground
; right:
;     lda rightIsPressed
;     beq checkCollisionDone
;     lda playerY
;     clc
;     adc #$11
;     sta spriteY
;     lda playerX
;     clc
;     adc #$08
;     sta spriteX
;     jsr compareToBackground
; 
;     lda playerY
;     clc
;     adc #$18
;     sta spriteY
;     lda playerX
;     clc
;     adc #$08
;     sta spriteX
;     jmp compareToBackground
; checkCollisionDone:
;     rts

checkCollision:
cpUp:
	lda upIsPressed
	beq cpDown

	lda playerY
	sta spriteLoc
	clc
	adc #$10
	sta spriteY
	sta hotspot
	lda #$0F
	sta ejectMod

	lda playerX
	sta spriteX
	jsr compareToBkg
	lda spriteLoc
	cmp playerY
	beq @next
	sta playerY
	rts
@next
	lda playerX
	clc
	adc #$07
	sta spriteX
	jsr compareToBkg
	lda spriteLoc
	sta playerY
	rts
cpDown:
	lda downIsPressed
	beq cpLeft

	lda playerY
	sta spriteLoc
	clc
	adc #$18
	sta spriteY
	sta hotspot
	lda #$FF
	sta ejectMod

	lda playerX
	sta spriteX
	jsr compareToBkg
	lda spriteLoc
	cmp playerY
	beq @next
	sta playerY
	rts
@next
	lda playerX
	clc
	adc #$07
	sta spriteX
	jsr compareToBkg
	lda spriteLoc
	sta playerY
	rts
cpLeft:
	lda leftIsPressed
	beq cpRight

	lda playerX
	sta spriteLoc
	sec
	sbc #$01
	sta spriteX
	sta hotspot
	lda #$0F
	sta ejectMod

	lda playerY
	clc
	adc #$11
	sta spriteY
	jsr compareToBkg
	lda spriteLoc
	cmp playerX
	beq @next
	sta playerX
	rts
@next
	lda playerY
	clc
	adc #$18
	sta spriteY
	jsr compareToBkg
	lda spriteLoc
	sta playerX
	rts
cpRight:
	lda rightIsPressed
	beq checkCollisionDone

	lda playerX
	sta spriteLoc
	clc
	adc #$07
	sta spriteX
	sta hotspot
	lda #$FF
	sta ejectMod

	lda playerY
	clc
	adc #$11
	sta spriteY
	jsr compareToBkg
	lda spriteLoc
	cmp playerX
	beq @next
	sta playerX
	rts
@next
	lda playerY
	clc
	adc #$18
	sta spriteY
	jsr compareToBkg
	lda spriteLoc
	sta playerX
checkCollisionDone:
	rts

compareToBkg:
	jsr getBGtype
	beq compareToBkgDone

	lda hotspot
	and #$0F
	eor ejectMod
	clc
	adc spriteLoc
	sta spriteLoc
compareToBkgDone:
	rts

; compareToBackground:
;   jsr getBGtype           ; Get current background metatile attribute byte for (spriteY & #$F0) + (spriteX / 16)
;   bne cpUp                ; If metatile type is passable then return
;   rts                     ; Else allow the movement into unpassable metatile
; cpUp:                       ;  then eject the player
;   lda upIsPressed
;   beq cpDown
; 	lda spriteY
; 	and #$0F
; 	eor #$0F
; 	clc
; 	adc playerY
; 	sta playerY
; 	rts
; cpDown:
;   lda downIsPressed
;   beq cpLeft
; 	lda spriteY
; 	and #$0F
; 	eor #$FF
; 	clc
; 	adc playerY
; 	sta playerY
; 	rts
; cpLeft:
;   lda leftIsPressed
;   beq cpRight
; 	lda spriteX
; 	and #$0F
; 	eor #$0F
; 	clc
; 	adc playerX
; 	sta playerX
;     rts
; cpRight:
;   lda rightIsPressed
;   beq compareToBackgroundDone
; 	lda spriteX
; 	and #$0F
; 	eor #$FF
; 	clc
; 	adc playerX
; 	sta playerX
; compareToBackgroundDone:
;     rts

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
    lda enemyIndex,x
    tax
    lda enemyRAM,x
    sta enemy_TOP
    clc
    adc enemyBBmodY
    sta enemy_BOTTOM

    lda enemyRAM+3,x
;    clc
;    adc #$02
    sta enemy_LEFT
    clc
    adc enemyBBmodX
    sta enemy_RIGHT
updateEnemyColDone:
    rts

updatePlayerCol:            ; Updates the players bounding box for sprite on sprite collision
    lda playerY
    clc
    adc #$0A
    sta player_TOP
    clc
    adc #$08
    sta player_BOTTOM

    lda playerX
    clc
    adc #$01
    sta player_LEFT
    clc
    adc #$05
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
    adc #$0A
    sta item_BOTTOM

    lda itemRAM+3,x
    clc
    adc #$04
    sta item_LEFT
    lda itemRAM+3,x
    clc
    adc #$0A
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
	ldx enemyNo

	lda playerDir
	cmp #facingUp
	beq @up
	cmp #facingDown
	beq @down
	cmp #facingLeft
	beq @left
@right
    lda playerX
    sec
    sbc #$02
    sta playerX

    lda enemyX,x
    clc
    adc #$04
    sta enemyX,x
    rts
@left
    lda playerX
    clc
    adc #$02
    sta playerX

    lda enemyX,x
    sec
    sbc #$04
    sta enemyX,x
    rts
@down
	lda playerY
    sec
    sbc #$02
    sta playerY

    lda enemyY,x
    clc
    adc #$04
    sta enemyY,x
    rts
@up
	lda playerY
    clc
    adc #$02
    sta playerY

    lda enemyY,x
    sec
    sbc #$04
    sta enemyY,x
@noHit:
enemyCollisionDone:
    rts

checkEnemies:
	lda enemyCtr
	beq checkEnemiesDone
    lda enemyCtr
    sta enemyNo

@loop:
    ldx enemyNo
    lda enemyFlagsTemp
    and bitMask,x
    beq @skip

    jsr updateEnemyCol
    jsr enemyCollision

@skip:
    dec enemyNo
    bpl @loop
checkEnemiesDone:
    rts
