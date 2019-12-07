checkEnemyCol:
@up
	lda enemyDir,x
	and #$08
	beq @down

	lda enemyY,x
	sta spriteLoc
	sta spriteY
	sta hotspot
	lda #$0F
	sta ejectMod
	bne @cmpV

@down
	lda enemyDir,x
	and #$04
	beq @left

	lda enemyY,x
	sta spriteLoc
	clc
	adc enemyBBmodY
	sta spriteY
	sta hotspot
	lda #$FF
	sta ejectMod

@cmpV
	lda enemyX,x
	clc
	adc temp+2
	sta spriteX

	jsr compareToBkg
	beq @left
	sta enemyY,x

@left
	lda enemyDir,x
	and #$02
	beq @right

	lda enemyX,x
	sta spriteLoc
	sta spriteX
	sta hotspot
	lda #$0F
	sta ejectMod
	bne @cmpH

@right
	lda enemyDir,x
	and #$01
	beq checkEnemyColDone

	lda enemyX,x
	sta spriteLoc
	clc
	adc enemyBBmodX
	sta spriteX
	sta hotspot
	lda #$FF
	sta ejectMod

@cmpH
	lda enemyY,x
	clc
	adc temp+1
	sta spriteY

	jsr compareToBkg
	beq checkEnemyColDone
	sta enemyX,x
checkEnemyColDone:
	rts

checkPlayerColV:
@up:
	lda upIsPressed
	beq @down

	lda playerY
	sta spriteLoc
	clc
	adc #$10
	sta spriteY
	sta hotspot
	lda #$0F
	sta ejectMod
	bne @checkColV
	
@down
	lda playerY
	sta spriteLoc
	clc
	adc #$18
	sta spriteY
	sta hotspot
	lda #$FF
	sta ejectMod

@checkColV
	lda playerX
	sec
	sbc #$01
	sta spriteX
	jsr compareToBkg
	bne @eject

	lda playerX
	clc
	adc #$08
	sta spriteX
	jsr compareToBkg
	beq checkPlayerColVdone
@eject
	sta playerY
checkPlayerColVdone:
	rts

checkPlayerColH:
@left
	lda leftIsPressed
	beq @right

	lda playerX
	sta spriteLoc
	sec
	sbc #$02
	sta spriteX
	sta hotspot
	lda #$0F
	sta ejectMod
	bne @checkColH

@right
    lda playerX
	sta spriteLoc
	clc
	adc #$08
	sta spriteX
	sta hotspot
	lda #$FF
	sta ejectMod

@checkColH
	lda playerY
	clc
	adc #$11
	sta spriteY
	jsr compareToBkg
	bne @eject

	lda playerY
	clc
	adc #$18
	sta spriteY
	jsr compareToBkg
	beq checkPlayerColHdone
@eject
	sta playerX
checkPlayerColHdone
	rts

compareToBkg:
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
    tay

    lda colRAM,y    	; Look up the metatile
;    tay
;    lda metaAtb,y        	; And use it to look up the metatile attribute
	beq compareToBkgDone    ; If tile is passable we're done

	lda hotspot
	and #$0F
	eor ejectMod
	clc
	adc spriteLoc
compareToBkgDone:
	rts

; compareToBkg:
;     lda spriteX             ; Divides spriteX by 32 so that it corresponds to metatile columns
; 	lsr
; 	lsr
; 	lsr
; 	lsr
; 	lsr
;     sta spriteXpos
; 
;     lda spriteY             ; Then add high nybble of spriteY to correspond to metatile rows
;     and #$E0
;     lsr
;     lsr
; 	clc
; 	adc spriteXpos
;     tay
;     lda (screenPtr),y       ; Look up the metatile
;     tay
; 
;     lda spriteY
;     and #$10
;     beq @bottom
; @top
; 	lda spriteX
; 	and #$10
; 	beq @TR
; @TL
; 	lda TL,y
; 	tay
; 	lda metaAtb,y
; 	beq compareToBkgDone    ; If tile is passable we're done
; 
; 	lda hotspot
; 	and #$0F
; 	eor ejectMod
; 	clc
; 	adc spriteLoc
; 	rts
; @TR
; 	lda TR,y
; 	tay
; 	lda metaAtb,y
; 	beq compareToBkgDone    ; If tile is passable we're done
; 
; 	lda hotspot
; 	and #$0F
; 	eor ejectMod
; 	clc
; 	adc spriteLoc
; 	rts
; 
; @bottom
; 	lda spriteX
; 	and #$10
; 	bne @BR
; @BL
; 	lda BL,y
; 	tay
; 	lda metaAtb,y
; 	beq compareToBkgDone    ; If tile is passable we're done
; 
; 	lda hotspot
; 	and #$0F
; 	eor ejectMod
; 	clc
; 	adc spriteLoc
; 	rts
; @BR
; 	lda BR,y
; 	tay
; 	lda metaAtb,y
; 	bne compareToBkgDone    ; If tile is passable we're done
; 
; 	lda hotspot
; 	and #$0F
; 	eor ejectMod
; 	clc
; 	adc spriteLoc
; compareToBkgDone:
;     rts

updateEnemyCol:             ; Updates the enemy bounding boxes for sprite on sprite collision
    lda enemyIndex,x
    tax
    lda enemyRAM,x
    sta enemy_TOP
    clc
    adc enemyBBmodY
    sta enemy_BOTTOM

    lda enemyRAM+3,x
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

	lda enemyDir,x
	cmp #facingUp
	beq @up
	cmp #facingDown
	beq @down
	cmp #facingLeft
	beq @left
@right
    lda playerX
    clc
    adc #$02
    sta playerX

    lda enemyX,x
    sec
    sbc #$04
    sta enemyX,x
    rts
@left
    lda playerX
    sec
    sbc #$02
    sta playerX

    lda enemyX,x
    clc
    adc #$04
    sta enemyX,x
    rts
@down
	lda playerY
    clc
    adc #$02
    sta playerY

    lda enemyY,x
    sec
    sbc #$04
    sta enemyY,x
    rts
@up
	lda playerY
    sec
    sbc #$02
    sta playerY

    lda enemyY,x
    clc
    adc #$04
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
