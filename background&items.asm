;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;   META-METATILES   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;  00   01   02   03   04   05   06   07   08   09   0A   0B   0C   0D   0E   0F
	;;;  10   11   12   13   14   15   16   17   18   19   1A   1B   1C   1D   1E   1F
TL:      
	.db $05, $08, $01, $02, $02, $01, $02, $05, $01, $01, $01, $03, $05, $05, $02, $05
	.db $05, $05, $05, $05, $0C, $03, $02, $05, $01, $05, $01, $02, $01, $02, $0C, $01
TR:
	.db $05, $08, $02, $02, $01, $05, $05, $01, $01, $01, $05, $03, $01, $02, $05, $02
	.db $05, $05, $05, $05, $03, $0C, $05, $02, $05, $01, $01, $05, $01, $02, $0C, $08
BL:
	.db $05, $08, $01, $05, $05, $01, $03, $05, $01, $02, $02, $08, $05, $03, $05, $05
	.db $01, $05, $03, $05, $0C, $03, $03, $05, $02, $05, $01, $05, $02, $03, $0C, $01
BR:
	.db $05, $08, $05, $05, $01, $05, $03, $02, $02, $01, $05, $08, $01, $03, $05, $05
	.db $05, $01, $05, $03, $0C, $03, $05, $03, $05, $02, $01, $05, $02, $03, $0C, $08

;;;;;;;;;;;;;;;;;;;;;
;;;   METATILES   ;;;
;;;;;;;;;;;;;;;;;;;;;

    ;;;  00   01   02   03   04   05   06   07   08   09   0A   0B   0C   0D   0E
topLeft:
    .db $00, $02, $04, $06, $22, $24, $26, $28, $FE, $0A, $08, $FE, $FE, $04, $2A

topRight:
    .db $01, $03, $05, $07, $23, $25, $27, $29, $FE, $0B, $09, $FE, $FE, $05, $2A

bottomLeft:
    .db $10, $12, $14, $16, $32, $34, $36, $38, $FE, $1A, $18, $1A, $FE, $0A, $2A

bottomRight:
    .db $11, $13, $15, $17, $33, $35, $37, $39, $FE, $1B, $FE, $1B, $FE, $0B, $2A

metaAtb:
    .db $01, $01, $01, $01, $00, $00, $00, $00, $01, $01, $01, $01, $00, $01, $00

; metaBackground:
;     lda #$00
;     sta metatile
;     eor #$0F
;     sta rowCounter
; @top:
;     lda #$10
;     sta counter
; 
;     ldy metatile
; @loop:
;     lda (screenPtr),y
;     tax
;     lda topLeft,x
;     sta PPU_Data
;     lda topRight,x
;     sta PPU_Data
;     iny
;     dec counter
;     bne @loop
; 
;     tya
;     sec
;     sbc #$10
;     tay
; 
;     lda #$10
;     sta counter
; @loop2:
;     lda (screenPtr),y
;     tax
;     lda bottomLeft,x
;     sta PPU_Data
;     lda bottomRight,x
;     sta PPU_Data
;     lda metaAtb,x
;     sta colRAM,y
;     iny
;     dec counter
;     bne @loop2
;     
;     sty metatile
; 
;     dec rowCounter
;     bne @top
; metaBackgroundDone:
;     rts

metaBackground:
    lda #$00
    sta metatile
    sta temp+1
    eor #$0F
    sta rowCounter
@top:
    lda #$08
    sta counter
    ldy metatile
@loop:
	lda (screenPtr),y
    tax
    stx temp
    lda TL,x
    tax
    lda topLeft,x           ; Load top left tile
    sta PPU_Data
    lda topRight,x          ; Load top right tile
    sta PPU_Data
    
    lda metaAtb,x
    ldx temp+1
    inc temp+1
    sta colRAM,x

	ldx temp
    lda TR,x	            ; Get meta-metatile again
    tax
    lda topLeft,x           ; Load top left tile
    sta PPU_Data
    lda topRight,x          ; Load top right tile
    sta PPU_Data
    
    lda metaAtb,x
    ldx temp+1
    inc temp+1
    sta colRAM,x

    iny                     ; INY for next meta-metatile
    dec counter             ;
    bne @loop               ; If we've done 8 meta-metatiles we're done

    lda #$08
    sta counter
    ldy metatile
@loop2:
    lda (screenPtr),y
    tax
    stx temp
    lda TL,x
	tax
    lda bottomLeft,x
    sta PPU_Data
    lda bottomRight,x
    sta PPU_Data

    ldx temp
    lda TR,x
    tax
    lda bottomLeft,x
    sta PPU_Data
    lda bottomRight,x
    sta PPU_Data

    iny
    dec counter
    bne @loop2
    
    dec rowCounter
    beq metaBackgroundDone

    lda #$08
    sta counter
    ldy metatile
@loop3:
	lda (screenPtr),y
    tax
    stx temp
    lda BL,x
    tax
    lda topLeft,x           ; Load top left tile
    sta PPU_Data
    lda topRight,x          ; Load top right tile
    sta PPU_Data
    
    lda metaAtb,x
    ldx temp+1
    inc temp+1
    sta colRAM,x

	ldx temp
    lda BR,x	            ; Get meta-metatile again
    tax
    lda topLeft,x           ; Load top left tile
    sta PPU_Data
    lda topRight,x          ; Load top right tile
    sta PPU_Data

    lda metaAtb,x
    ldx temp+1
    inc temp+1
    sta colRAM,x

    iny                     ; INY for next meta-metatile
    dec counter             ;
    bne @loop3              ; If we've done 8 meta-metatiles we're done

    lda #$08
    sta counter
    ldy metatile
@loop4:
    lda (screenPtr),y
    tax
    stx temp
    lda BL,x
	tax
    lda bottomLeft,x
    sta PPU_Data
    lda bottomRight,x
    sta PPU_Data

    ldx temp
    lda BR,x
    tax
    lda bottomLeft,x
    sta PPU_Data
    lda bottomRight,x
    sta PPU_Data

    iny
    dec counter
    bne @loop4
    
    sty metatile

    dec rowCounter
    jmp @top
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
;    jsr openChests          ; Open chests if present and flag is clear
    jsr loadEnemies
    ldx #$00
    stx needDraw            ; Clear draw flag
    inx
    stx gameState           ; Now we're playing (with power)
drawBkgDone:
    rts

loadItems:
    ldy #$00                  ; Loads item sprites to sprite ram
itemLoop:
    lda (itemPtr),y
    cmp #$FF
    beq @fillLoop
    sta itemRAM,y
    iny
    bvc itemLoop

@fillLoop                     ; Blanks out unused itemRAM
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

loadFlags:                  ; Loads itemFlags to RAM so they can be read and modified
    ldx #$00                ;  such as for checking if chests should be open or closed
@loop:
    lda itemFlags,x
    sta itemSoftFlags,x
    inx
    cpx #$40
    bne @loop
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
    .db $7F,$33,%00000000,$78
    .db $7F,$33,%01000000,$80
    .db $87,$34,%00000000,$78
    .db $87,$34,%01000000,$80
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
