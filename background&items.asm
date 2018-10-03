;;;;;;;;;;;;;;;;;;;;;
;;;   METATILES   ;;;
;;;;;;;;;;;;;;;;;;;;;

    ;;;  00   01   02   03   04   05   06   07   08
topLeft:
    .db $00, $02, $04, $0E, $22, $24, $26, $28, $EE

topRight:
    .db $01, $03, $05, $0F, $23, $25, $27, $29, $EF

bottomLeft:
    .db $10, $12, $14, $1E, $32, $25, $36, $38, $FE

bottomRight:
    .db $11, $13, $15, $1F, $33, $24, $37, $39, $FF
    
metaAtb:
    .db $01, $01, $01, $01, $00, $00, $00, $00, $01

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
    ldy #$00
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
    lda backgroundL,x
    sta screenPtr
    lda backgroundH,x
    sta screenPtr+1

    lda attributeL,x
    sta attributePtr
    lda attributeH,x
    sta attributePtr+1

    lda itemHeadersL,x
    sta itemPtr
    lda itemHeadersH,x
    sta itemPtr+1

    jsr metaBackground      ; Draw the background and attributes, fill textbox buffer
    jsr loadAttributes      ; Check if chests need drawn and if they have already been opened
    jsr fillPPUbuffer       
    jsr loadItems           
    jsr openChests
    ldx #$00
    stx needDraw
    inx
    stx gameState
drawBkgDone:
    rts

;   TODO: Convert chest sprites to backgroung tiles
;         Use system similar to loadItems to load enemies

loadItems:
    ldy #$00
itemLoop:
    lda (itemPtr),y
    cmp #$FE
    beq fillLoop
    sta itemRAM,y
    iny
    bvc itemLoop

fillLoop:
    lda #$FE
    sta itemRAM,y
    iny
    cpy #$40
    bne fillLoop
loadItemsDone:
    rts

openChests:
    lda #$00
    sta chestNo
    ldx nametable
    lda itemSoftFlags,x
    sta itemFlagsTemp
@loop:
    ldx chestNo
    lda itemFlagsTemp
    and bitMask,x
    bne @skip

    lda chestConstants,x
    tax
    inc itemRAM+1,x
    inc itemRAM+5,x
@skip
    inc chestNo
    lda chestNo
    cmp #$04
    bne @loop
openChestsDone:
    rts
    
loadFlags:
    ldx #$00
@loop:
    lda itemFlags,x
    sta itemSoftFlags,x
    inx
    cpx #$40
    bne @loop
loadFlagsDone:
    rts
    
fillPPUbuffer:
    lda PPU_Status
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
    .dl itemHeader00, itemHeader01, itemHeader02, itemHeader03
    .dsb $0C,$00
    .dl itemHeader10, itemHeader11, itemHeader12, itemHeader13 
    .dsb $0C,$00
    .dl itemHeader20, itemHeader21, itemHeader22, itemHeader23
    .dsb $0C,$00
    .dl itemHeader30, itemHeader31, itemHeader32, itemHeader33
    .dsb $0C,$00

itemHeadersH:
    .dh itemHeader00, itemHeader01, itemHeader02, itemHeader03
    .dsb $0C,$00
    .dh itemHeader10, itemHeader11, itemHeader12, itemHeader13
    .dsb $0C,$00
    .dh itemHeader20, itemHeader21, itemHeader22, itemHeader23
    .dsb $0C,$00
    .dh itemHeader30, itemHeader31, itemHeader32, itemHeader33
    .dsb $0C,$00
    
itemFlags:
    .db %00000011, %00000001, %00000000, %00000000
    .dsb $0C,$00
    .db %00000111, %00000000, %00000011, %00000000
    .dsb $0C,$00
    .db %00000000, %00000001, %00000000, %00000000
    .dsb $0C,$00
    .db %00000000, %00000000, %00000000, %00000001
    .dsb $0C,$00

chestOffset:
    .db $00, $04, $08, $0C, $10, $14, $18, $1C

chestConstants:
    .db $00, $10, $20, $30, $40, $50, $60, $70

itemHeader00:
    .db $6F,$30,%00000001,$70
    .db $6F,$30,%01000001,$78
    .db $77,$32,%00000001,$70
    .db $77,$32,%01000001,$78

    .db $6F,$30,%00000001,$80
    .db $6F,$30,%01000001,$88
    .db $77,$32,%00000001,$80
    .db $77,$32,%01000001,$88
    .db $FE

itemHeader01:
    .db $5F,$30,%00000001,$70
    .db $5F,$30,%01000001,$78
    .db $67,$32,%00000001,$70
    .db $67,$32,%01000001,$78
    .db $FE
    
itemHeader02:
    .db $FE
itemHeader03:
    .db $FE

itemHeader10:
    .db $4F,$30,%00000001,$30
    .db $4F,$30,%01000001,$38
    .db $57,$32,%00000001,$30
    .db $57,$32,%01000001,$38

    .db $4F,$30,%00000001,$40
    .db $4F,$30,%01000001,$48
    .db $57,$32,%00000001,$40
    .db $57,$32,%01000001,$48
    
    .db $4F,$30,%00000001,$50
    .db $4F,$30,%01000001,$58
    .db $57,$32,%00000001,$50
    .db $57,$32,%01000001,$58
    .db $FE

itemHeader11:
    .db $FE

itemHeader12:
    .db $7F,$30,%00000001,$30
    .db $7F,$30,%01000001,$38
    .db $87,$32,%00000001,$30
    .db $87,$32,%01000001,$38

    .db $9F,$30,%00000001,$A0
    .db $9F,$30,%01000001,$A8
    .db $A7,$32,%00000001,$A0
    .db $A7,$32,%01000001,$A8
    .db $FE

itemHeader13:
    .db $FE

itemHeader20:
    .db $FE

itemHeader21:
    .db $9F,$30,%00000001,$A0
    .db $9F,$30,%01000001,$A8
    .db $A7,$32,%00000001,$A0
    .db $A7,$32,%01000001,$A8
    .db $FE

itemHeader22:
    .db $FE

itemHeader23:
    .db $FE

itemHeader30:
    .db $FE
itemHeader31:
    .db $FE
itemHeader32:
    .db $FE
itemHeader33:
    .db $9F,$30,%00000001,$A0
    .db $9F,$30,%01000001,$A8
    .db $A7,$32,%00000001,$A0
    .db $A7,$32,%01000001,$A8
    .db $FE
