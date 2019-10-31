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

@fillLoop
    lda #$FE
    sta enemyRAM,y
    iny
    cpy #$40
    bne @fillLoop

    lda enemyRAM+0
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
    .db $5F,$35,%00000011,$30
    .db $5F,$35,%01000011,$38

    .db $67,$35,%00000011,$48
    .db $67,$35,%01000011,$50
    .db $00
    
enemyHeader02:
enemyHeader03:
enemyHeader04:
    .db $00

enemyHeader10:
    .db $00

enemyHeader11:
    .db $00

enemyHeader12:
    .db $7F,$33,%00000010,$30
    .db $7F,$33,%01000010,$38
    .db $87,$34,%00000010,$30
    .db $87,$34,%01000010,$38

    .db $9F,$33,%00000010,$A0
    .db $9F,$33,%01000010,$A8
    .db $A7,$34,%00000010,$A0
    .db $A7,$34,%01000010,$A8
    .db $00

enemyHeader13:
    .db $00

enemyHeader20:
    .db $00

enemyHeader21:
    .db $9F,$33,%00000010,$A0
    .db $9F,$33,%01000010,$A8
    .db $A7,$34,%00000010,$A0
    .db $A7,$34,%01000010,$A8
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