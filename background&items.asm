;;;;;;;;;;;;;;;;;;;;;
;;;   METATILES   ;;;
;;;;;;;;;;;;;;;;;;;;;

    ;;;  00   01   02   03   04   05   06   07   08   09
topLeft:
    .db $00, $02, $04, $0E, $22, $24, $26, $28, $EE, $0A

topRight:
    .db $01, $03, $05, $0F, $23, $25, $27, $29, $EF, $0B

bottomLeft:
    .db $10, $12, $14, $1E, $32, $25, $36, $38, $FE, $1A

bottomRight:
    .db $11, $13, $15, $1F, $33, $24, $37, $39, $FF, $1B
    
metaAtb:
    .db $01, $01, $01, $01, $00, $00, $00, $00, $01, $01

metaBackground:
    lda #$00
    sta metaTile
    eor #$0F
    sta rowCounter
@top:
    lda #$10
    sta counter

    ldy metaTile
@loop:
    lda (screenPtr),y
    tax
    lda topLeft,x
    sta PPU_Data
    lda topRight,x
    sta PPU_Data
    iny
    dec counter
    bne @loop

    tya
    sec
    sbc #$10
    tay

    lda #$10
    sta counter
@loop2:
    lda (screenPtr),y
    tax
    lda bottomLeft,x
    sta PPU_Data
    lda bottomRight,x
    sta PPU_Data
    iny
    dec counter
    bne @loop2
    
    sty metaTile

    dec rowCounter
    bne @top
metaBackgroundDone:
    rts

loadAttributes:
    ldy #$00                ; Load background attributes to PPU
@loop:
    lda (attributePtr),y
    sta PPU_Data
    iny
    cpy #$40
    bne @loop
loadAttributesDone:
    rts

drawBkg:
    lda #$00
    sta PPU_Mask

    lda PPU_Status
    lda #$20
    sta PPU_Address         ; First nametable address
    lda #$00
    sta PPU_Address

    ldx nametable
    lda bkgL,x
    sta screenPtr
    lda bkgH,x
    sta screenPtr+1

    lda atbL,x
    sta attributePtr
    lda atbH,x
    sta attributePtr+1

    lda itemHeadersL,x
    sta itemPtr
    lda itemHeadersH,x
    sta itemPtr+1
    
    lda enemyHeadersL,x
    sta enemyPtr
    lda enemyHeadersH,x
    sta enemyPtr+1

    jsr metaBackground      ; Draw the background and attributes, fill textbox buffer
    jsr loadAttributes      ; Check if chests need drawn and if they have already been opened
    jsr fillPPUbuffer       ; Copy background to buffer
    jsr loadItems           ; Load chests, tablets, etc.
    jsr loadEnemies		    ; Load enemies
;    jsr openChests          ; Open chests if present and flag is clear
    ldx #$00
    stx needDraw            ; Clear draw flag
    inx
    stx gameState           ; Now we're playing (with power)
drawBkgDone:
    rts

;   TODO: Convert chest sprites to backgroung tiles
;         Use system similar to loadItems to load enemies

loadItems:
    ldy #$00                  ; Loads item sprites to sprite ram
itemLoop:
    lda (itemPtr),y
    cmp #$FF
    beq @fillLoop
    sta itemRAM,y
    iny
    bvc itemLoop

@fillLoop
    lda #$FF
    sta itemRAM,y
    iny
    cpy #$40
    bne @fillLoop
loadItemsDone:
    rts

; openChests:
;     lda #$00                ; Opens chests if present and corresponding flag is clear
;     sta itemNo
;     ldx nametable
;     lda itemSoftFlags,x
;     sta itemFlagsTemp
; @loop:
;     ldx itemNo
;     lda itemFlagsTemp
;     and bitMask,x
;     bne @skip
; 
;     lda itemConstants,x
;     tax
;     inc itemRAM+1,x
;     inc itemRAM+5,x
; @skip
;     inc itemNo
;     lda itemNo
;     cmp #$04
;     bne @loop
; openChestsDone:
;     rts

loadFlags:
    ldx #$00
@loop:
    lda itemFlags,x
    sta itemSoftFlags,x
    inx
    cpx #$40
    bne @loop
    
    ldx #$00
@loop2
	lda enemyFlags,x
	sta enemySoftFlags,x
	inx
	cpx #$40
	bne @loop2
loadFlagsDone:
    rts

fillPPUbuffer:
    lda PPU_Status          ; Makes a copy of background information to restore after textbox
    lda #$20
    sta PPU_Address
    lda #$20
    sta PPU_Address
    lda PPU_Data

    ldx #$00
@loop:
    lda PPU_Data
    sta bkgBuffer,x
    inx
    cpx #$E0
    bne @loop

    lda #$23
    sta PPU_Address
    lda #$C0
    sta PPU_Address
    lda PPU_Data

    ldx #$00
@loop2:
    lda PPU_Data
    sta atbBuffer,x
    inx
    cpx #$10
    bne @loop2
fillPPUbufferDone:
    rts

itemHeadersL:
    .dl itemHeader00, itemHeader01, itemHeader02, itemHeader03, itemHeader04
    .dsb $0B,$00
    .dl itemHeader10, itemHeader11, itemHeader12, itemHeader13 
    .dsb $0C,$00
    .dl itemHeader20, itemHeader21, itemHeader22, itemHeader23
    .dsb $0C,$00
    .dl itemHeader30, itemHeader31, itemHeader32, itemHeader33
    .dsb $0C,$00

itemHeadersH:
    .dh itemHeader00, itemHeader01, itemHeader02, itemHeader03, itemHeader04
    .dsb $0B,$00
    .dh itemHeader10, itemHeader11, itemHeader12, itemHeader13
    .dsb $0C,$00
    .dh itemHeader20, itemHeader21, itemHeader22, itemHeader23
    .dsb $0C,$00
    .dh itemHeader30, itemHeader31, itemHeader32, itemHeader33
    .dsb $0C,$00
    
itemFlags:
    .db %00000111, %00000001, %00000000, %00000000, %00000000
    .dsb $0B,$00
    .db %00000111, %00000000, %00000011, %00000000
    .dsb $0C,$00
    .db %00000000, %00000001, %00000000, %00000000
    .dsb $0C,$00
    .db %00000000, %00000000, %00000000, %00000001
    .dsb $0C,$00

;chestOffset:
;    .db $00, $04, $08, $0C, $10, $14, $18, $1C


; Offsets for top left positions of item metasprites
itemConstants:
    .db $00, $10, $20, $30

itemHeader00:
    .db $6F,$33,%00000000,$70
    .db $6F,$33,%01000000,$78
    .db $77,$34,%00000000,$70
    .db $77,$34,%01000000,$78

    .db $6F,$33,%00000000,$80
    .db $6F,$33,%01000000,$88
    .db $77,$34,%00000000,$80
    .db $77,$34,%01000000,$88

    .db $FF

itemHeader01:
    .db $5F,$33,%00000000,$70
    .db $5F,$33,%01000000,$78
    .db $67,$34,%00000000,$70
    .db $67,$34,%01000000,$78
    .db $FF
    
itemHeader02:
itemHeader03:
itemHeader04:
    .db $FF

itemHeader10:
    .db $4F,$33,%00000000,$30
    .db $4F,$33,%01000000,$38
    .db $57,$34,%00000000,$30
    .db $57,$34,%01000000,$38

    .db $4F,$33,%00000000,$40
    .db $4F,$33,%01000000,$48
    .db $57,$34,%00000000,$40
    .db $57,$34,%01000000,$48
    
    .db $4F,$33,%00000000,$50
    .db $4F,$33,%01000000,$58
    .db $57,$34,%00000000,$50
    .db $57,$34,%01000000,$58
    .db $FF

itemHeader11:
    .db $FF

itemHeader12:
    .db $7F,$33,%00000000,$30
    .db $7F,$33,%01000000,$38
    .db $87,$34,%00000000,$30
    .db $87,$34,%01000000,$38

    .db $9F,$33,%00000000,$A0
    .db $9F,$33,%01000000,$A8
    .db $A7,$34,%00000000,$A0
    .db $A7,$34,%01000000,$A8
    .db $FF

itemHeader13:
    .db $FF

itemHeader20:
    .db $FF

itemHeader21:
    .db $9F,$33,%00000000,$A0
    .db $9F,$33,%01000000,$A8
    .db $A7,$34,%00000000,$A0
    .db $A7,$34,%01000000,$A8
    .db $FF

itemHeader22:
    .db $FF

itemHeader23:
    .db $FF

itemHeader30:
    .db $FF
itemHeader31:
    .db $FF
itemHeader32:
    .db $FF
itemHeader33:
    .db $9F,$33,%00000000,$A0
    .db $9F,$33,%01000000,$A8
    .db $A7,$34,%00000000,$A0
    .db $A7,$34,%01000000,$A8
    .db $FF
