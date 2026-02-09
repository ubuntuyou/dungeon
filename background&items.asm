
;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;   META-METATILES   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;  00   01   02   03   04   05   06   07   08   09   0A   0B   0C   0D   0E   0F
	;;;  10   11   12   13   14   15   16   17   18   19   1A   1B   1C   1D   1E   1F
	;;;  20   21   22   23   24   25   26   27   28   29   2A   2B   2C   2D   2E   2F
TL:      
	.db $08, $05, $01, $03, $01, $05, $01, $05, $01, $01, $08, $05, $03, $08, $02, $05
	.db $05, $05, $05, $05, $08, $03, $02, $05, $01, $03, $01, $02, $01, $02, $01, $08
    .db $01, $0F, $07, $08, $0E, $08, $08, $05, $05, $08, $01, $08, $01, $02, $08, $05
TR:
	.db $08, $05, $03, $01, $05, $01, $05, $01, $01, $01, $05, $08, $03, $08, $05, $02
	.db $05, $05, $05, $05, $03, $08, $05, $02, $01, $0F, $01, $02, $01, $02, $08, $01
    .db $01, $07, $03, $0E, $08, $08, $08, $05, $08, $05, $08, $01, $02, $01, $10, $05
BL:
	.db $08, $05, $01, $08, $01, $05, $02, $05, $01, $02, $05, $05, $08, $05, $05, $05
	.db $01, $05, $03, $05, $08, $08, $03, $05, $02, $08, $01, $05, $02, $03, $01, $08
    .db $0D, $08, $08, $08, $0E, $08, $05, $03, $05, $08, $02, $08, $01, $05, $08, $05
BR:
	.db $08, $05, $08, $01, $05, $01, $05, $02, $02, $01, $05, $05, $08, $05, $05, $05
	.db $05, $01, $05, $03, $08, $08, $05, $03, $0D, $08, $01, $05, $02, $03, $08, $01
    .db $02, $08, $08, $0E, $08, $05, $08, $03, $08, $05, $08, $02, $05, $01, $00, $11


;TL:      
;	.db $05, $08, $01, $03, $02, $01, $01, $05, $01, $01, $01, $03, $05, $08, $02, $05
;	.db $05, $05, $05, $05, $08, $03, $02, $05, $01, $05, $01, $02, $01, $02, $0C, $01
;   .db $01, $0F, $07, $08, $0E, $08, $08, $05, $08, $05, $05
;TR:
;	.db $05, $08, $03, $01, $01, $05, $08, $01, $01, $01, $05, $03, $01, $01, $05, $02
;	.db $05, $05, $05, $05, $03, $08, $05, $02, $05, $01, $01, $02, $01, $02, $0C, $08
;   .db $01, $07, $03, $0E, $08, $08, $08, $05, $05, $08, $05
;BL:
;	.db $05, $08, $01, $08, $05, $01, $02, $05, $01, $02, $02, $08, $05, $08, $05, $05
;	.db $01, $05, $03, $05, $08, $08, $03, $05, $02, $05, $01, $05, $02, $03, $0C, $01
;   .db $0D, $08, $08, $08, $0E, $08, $05, $03, $08, $05, $05
;BR:
;	.db $05, $08, $08, $01, $01, $05, $08, $02, $02, $01, $05, $08, $01, $02, $05, $05
;	.db $05, $01, $05, $03, $08, $08, $05, $03, $05, $02, $01, $05, $02, $03, $0C, $08
;   .db $02, $08, $08, $0E, $08, $05, $08, $03, $05, $08, $11

;;;;;;;;;;;;;;;;;;;;;
;;;   METATILES   ;;;
;;;;;;;;;;;;;;;;;;;;;

PEDESTAL    = $00   ; 00
TOP_BRICK   = $02   ; 01
SIDE_BRICK  = $04   ; 02
DARK_BRICK  = $06   ; 03
DECO_SQR    = $22   ; 04
FLOOR       = $24   ; 05
WATERFALL   = $26   ; 06
MOSS_BRICK  = $28   ; 07
HOLE        = $FE   ; 08
                    ; 09
SPIKES      = $08   ; 0A
VOID        = $FE   ; 0B
                    ; 0C
GRATE_BRICK = $04   ; 0D
STAIRS      = $2A   ; 0E
                    ; 0F

DEATHORB    = $80   ; 10
CRACK_FLOOR = $20   ; 11


    ;;;  00   01   02   03   04   05   06   07   08   09   0A   0B   0C   0D   0E   0F
topLeft:
    .db PEDESTAL+0
    .db TOP_BRICK+0
    .db SIDE_BRICK+0
    .db DARK_BRICK+0
    .db DECO_SQR+0
    .db FLOOR+0
    .db WATERFALL+0
    .db MOSS_BRICK
    .db HOLE
    .db $0A, SPIKES+0, VOID, VOID, GRATE_BRICK+0, STAIRS, $26
    .db DEATHORB+0
    .db CRACK_FLOOR+4

topRight:
    .db PEDESTAL+1
    .db TOP_BRICK+1
    .db SIDE_BRICK+1
    .db DARK_BRICK+1
    .db DECO_SQR+1
    .db FLOOR+1
    .db WATERFALL+1
    .db MOSS_BRICK+1
    .db HOLE
    .db $0B, SPIKES+1, VOID, VOID, GRATE_BRICK+1, STAIRS, $27
    .db DEATHORB+1
    .db CRACK_FLOOR+1


bottomLeft:
    .db PEDESTAL+16
    .db TOP_BRICK+16
    .db SIDE_BRICK+16
    .db DARK_BRICK+16
    .db DECO_SQR+16
    .db FLOOR+16
    .db WATERFALL+16
    .db MOSS_BRICK+16
    .db HOLE
    .db $1A, SPIKES+16, VOID, VOID, GRATE_BRICK+6, STAIRS, $36
    .db DEATHORB+16
    .db CRACK_FLOOR+16


bottomRight:
    .db PEDESTAL+17
    .db TOP_BRICK+17
    .db SIDE_BRICK+17
    .db DARK_BRICK+17
    .db DECO_SQR+17
    .db FLOOR+17
    .db WATERFALL+17
    .db MOSS_BRICK+17
    .db HOLE
    .db $1B, VOID, VOID, VOID, GRATE_BRICK+7, STAIRS, $37
    .db DEATHORB+17
    .db CRACK_FLOOR+17


atbData:
    .db $00, $00, $00, $00, $01, 01, $02, $03, $00, $00, $00, $00, $00, $00, $00, $00

metaAtb:
    .db $01, $01, $01, $01, $00, $00, $00, $00, $01, $01, $01, $01, $00, $01, $00, $01

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
    .dl itemHeader00, itemHeader01, itemHeader02, itemHeader03
    .dl itemHeader04, itemHeader05, itemHeader06, itemHeader07
    .dl itemHeader08, itemHeader09, itemHeader0A, itemHeader0B
    .dl itemHeader0C, itemHeader0D, itemHeader0E, itemHeader0F

    .dl itemHeader10, itemHeader11, itemHeader12, itemHeader13
    .dl itemHeader14, itemHeader15, itemHeader16, itemHeader17
    .dl itemHeader18, itemHeader19, itemHeader1A, itemHeader1B
    .dl itemHeader1C, itemHeader1D, itemHeader1E, itemHeader1F

    .dl itemHeader20, itemHeader21, itemHeader22, itemHeader23
    .dl itemHeader24, itemHeader25, itemHeader26, itemHeader27
    .dl itemHeader28, itemHeader29, itemHeader2A, itemHeader2B
    .dl itemHeader2C, itemHeader2D, itemHeader2E, itemHeader2F

    .dl itemHeader30, itemHeader31, itemHeader32, itemHeader33
    .dl itemHeader34, itemHeader35, itemHeader36, itemHeader37
    .dl itemHeader38, itemHeader39, itemHeader3A, itemHeader3B
    .dl itemHeader3C, itemHeader3D, itemHeader3E, itemHeader3F

itemHeadersH:
    .dh itemHeader00, itemHeader01, itemHeader02, itemHeader03
    .dh itemHeader04, itemHeader05, itemHeader06, itemHeader07
    .dh itemHeader08, itemHeader09, itemHeader0A, itemHeader0B
    .dh itemHeader0C, itemHeader0D, itemHeader0E, itemHeader0F

    .dh itemHeader10, itemHeader11, itemHeader12, itemHeader13
    .dh itemHeader14, itemHeader15, itemHeader16, itemHeader17
    .dh itemHeader18, itemHeader19, itemHeader1A, itemHeader1B
    .dh itemHeader1C, itemHeader1D, itemHeader1E, itemHeader1F

    .dh itemHeader20, itemHeader21, itemHeader22, itemHeader23
    .dh itemHeader24, itemHeader25, itemHeader26, itemHeader27
    .dh itemHeader28, itemHeader29, itemHeader2A, itemHeader2B
    .dh itemHeader2C, itemHeader2D, itemHeader2E, itemHeader2F

    .dh itemHeader30, itemHeader31, itemHeader32, itemHeader33
    .dh itemHeader34, itemHeader35, itemHeader36, itemHeader37
    .dh itemHeader38, itemHeader39, itemHeader3A, itemHeader3B
    .dh itemHeader3C, itemHeader3D, itemHeader3E, itemHeader3F
    
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

    ; Y, Sprite, Rotation, X
itemHeader00:
    .db $71,$33,%00000000,$80
    .db $71,$33,%01000000,$88
    .db $79,$34,%00000000,$80
    .db $79,$34,%01000000,$88

    .db $71,$33,%00000000,$90
    .db $71,$33,%01000000,$98
    .db $79,$34,%00000000,$90
    .db $79,$34,%01000000,$98

    .db $FF

itemHeader01:
    .db $61,$33,%00000000,$70
    .db $61,$33,%01000000,$78
    .db $69,$34,%00000000,$70
    .db $69,$34,%01000000,$78
    .db $FF
    
itemHeader02:
itemHeader03:
itemHeader04:
itemHeader05:
itemHeader06:
itemHeader07:
itemHeader08:
itemHeader09:
itemHeader0A:
itemHeader0B:
itemHeader0C:
itemHeader0D:
itemHeader0E:
itemHeader0F:
    .db $FF

itemHeader10:
    .db $51,$33,%00000000,$30
    .db $51,$33,%01000000,$38
    .db $59,$34,%00000000,$30
    .db $59,$34,%01000000,$38

    .db $51,$33,%00000000,$40
    .db $51,$33,%01000000,$48
    .db $59,$34,%00000000,$40
    .db $59,$34,%01000000,$48
    
    .db $51,$33,%00000000,$50
    .db $51,$33,%01000000,$58
    .db $59,$34,%00000000,$50
    .db $59,$34,%01000000,$58
    .db $FF


itemHeader12:
    .db $81,$33,%00000000,$30
    .db $81,$33,%01000000,$38
    .db $89,$34,%00000000,$30
    .db $89,$34,%01000000,$38

    .db $A1,$33,%00000000,$A0
    .db $A1,$33,%01000000,$A8
    .db $A9,$34,%00000000,$A0
    .db $A9,$34,%01000000,$A8
    .db $FF

itemHeader11:
itemHeader13:
itemHeader14:
itemHeader15:
itemHeader16:
itemHeader17:
itemHeader18:
itemHeader19:
itemHeader1A:
itemHeader1B:
itemHeader1C:
itemHeader1D:
itemHeader1E:
itemHeader1F:
    .db $FF


itemHeader21:
    .db $71,$33,%00000000,$78
    .db $71,$33,%01000000,$80
    .db $79,$34,%00000000,$78
    .db $79,$34,%01000000,$80
    .db $FF

itemHeader20:
itemHeader22:
itemHeader23:
itemHeader24:
itemHeader25:
itemHeader26:
itemHeader27:
itemHeader28:
itemHeader29:
itemHeader2A:
itemHeader2B:
itemHeader2C:
itemHeader2D:
itemHeader2E:
itemHeader2F:
    .db $FF


itemHeader33:
    .db $A1,$33,%00000000,$92
    .db $A1,$33,%01000000,$9A
    .db $A9,$34,%00000000,$92
    .db $A9,$34,%01000000,$9A
    .db $FF
    
itemHeader30:
itemHeader31:
itemHeader32:
itemHeader34:
itemHeader35:
itemHeader36:
itemHeader37:
itemHeader38:
itemHeader39:
itemHeader3A:
itemHeader3B:
itemHeader3C:
itemHeader3D:
itemHeader3E:
itemHeader3F:
    .db $FF
