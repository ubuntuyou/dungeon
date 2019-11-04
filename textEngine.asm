;;;;;;;;;;;;;;;;;;
;;;   BUFFER   ;;;
;;;;;;;;;;;;;;;;;;

restorePPUbuffer:
    ldx textCounter
    cpx #$06
    bne @skip              ; Restores backgroung from buffer
    lda #$01
    sta needTextAttrib

@skip
    lda PPU_Status
    lda #$20
    sta PPU_Address
    lda textBoxL,x
    sta PPU_Address


    lda bkgBuffL,x
    tax

    ldy #$00
@loop:
    lda bkgBuffer,x
    sta PPU_Data
    inx
    iny
    cpy #$20
    bne @loop
    inc textCounter
restorePPUbufferDone:
    rts

;;;;;;;;;;;;;;;;;;;;;;
;;;   ATTRIBUTES   ;;;
;;;;;;;;;;;;;;;;;;;;;;

drawTextAttrib:
    lda PPU_Status
    lda #$23
    sta PPU_Address        ; Write #$00 to textbox attributes
    lda #$C0
    sta PPU_Address

    ldx #$10
    lda #$00
@loop
    sta PPU_Data
    dex
    bne @loop
    sta needTextAttrib
    sta needDraw
drawTextAttribDone:
    rts

restoreTextAttrib:
    lda PPU_Status
    lda #$23
    sta PPU_Address        ; Restores backgroung attributes from buffer
    lda #$C0
    sta PPU_Address

    ldx #$00
@loop:
    lda atbBuffer,x
    sta PPU_Data
    inx
    cpx #$10
    bne @loop
    lda #$00
    sta needTextAttrib
    sta needDraw
    sta prgNo
restoreTextAttribDone:
    rts

;;;;;;;;;;;;;;;;;;;;
;;;   TEXT BOX   ;;;
;;;;;;;;;;;;;;;;;;;;

drawTextBox:
    ldx textCounter
    cpx #$06
    bne @skip              ; Loads textbox attribute flag before drawing
    lda #$01               ;  last row of textbox.
    sta needTextAttrib

@skip
    lda PPU_Status
    lda #$20
    sta PPU_Address
    lda textBoxL,x         ; Load low byte of textbox rows from table
    sta PPU_Address

    lda textBoxLinesL,x
    sta textBoxPtr         ; Textbox tile data
    lda textBoxLinesH,x
    sta textBoxPtr+1

    ldy #$00
@loop
    lda (textBoxPtr),y
    sta PPU_Data           ; Draw the damned thing
    iny
    cpy #$20
    bne @loop
    inc textCounter
drawTextBoxDone:
    rts

;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;   LOOKUP MESSAGE   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;


lookupMessage:
    lda nametable
    asl
    tay
    lda itemHeaderTbls,y
    sta itemHdrTblPtr      ; Use nametable to find which table of
    iny                    ;  item headers to read from.
    lda itemHeaderTbls,y
    sta itemHdrTblPtr+1

    lda itemHdrNo
    asl
    tay
    lda (itemHdrTblPtr),y
    sta itemHdrPtr         ; Then use that offset to index into the
    iny                    ;  message table for that room.
    lda (itemHdrTblPtr),y
    sta itemHdrPtr+1

    ldx lineNo
    lda textLine,x
    sta textAddrL          ; Load addresses of textbox line beginnings
    lda #textBoxStartH
    sta textAddrH

    ldy #$00
@loop:
    lda (itemHdrPtr),y
    sta textBuffer,y       ; Store message in textBuffer
    beq lookupMessageDone
    iny
    bvc @loop
lookupMessageDone:
    rts

readStringBuff:
    dec textSpeed
    bne readStringBuffDone ; textSpeed counts down before displaying
    lda #$03               ;  each new character in string.
    sta textSpeed

    lda PPU_Status
    lda textAddrH
    sta PPU_Address        ; Addresses of textbox line beginnings
    lda textAddrL
    sta PPU_Address

    ldy stringCtr
@loop:
    lda textBuffer,y       ; If textBuffer byte is #$00 then string is done
    bne checkNewLine
    lda #$00
    sta stringCtr
    inc textIndirect
    rts
checkNewLine:
    bpl writeTextByte      ; Else if textBuffer byte is positive it's not an opcode
    and #$7F               ; If negative, mask out MSBit for text indirect
    sta textIndirect
    rts
writeTextByte:
    sta PPU_Data           ; Write character to PPU and advance the engine
    inc stringCtr
    inc textAddrL
readStringBuffDone:
    rts

;;;;;;;;;;;;;;;;;;;
;;;   HEADERS   ;;;
;;;;;;;;;;;;;;;;;;;

newLine     .equ $84

textBoxL:
    .db $20, $40, $60, $80, $A0, $C0, $E0

bkgBuffL:
    .db $00, $20, $40, $60, $80, $A0, $C0

textBoxLinesL:
    .dl line0, line1_5, line1_5, line1_5, line1_5, line1_5, line6
textBoxLinesH:
    .dh line0, line1_5, line1_5, line1_5, line1_5, line1_5, line6

    .align $10

line0:
    .db $2C
    .dsb 30,$2D
    .db $2E
line1_5:
    .db $2F
    .dsb 30,$FF
    .db $3F
line6:
    .db $3C
    .dsb 30,$3D
    .db $3E

textLine:
    .db $41, $61, $81, $A1, $C1

itemHeaderTbls:
    .dw itemHdrTbl_00, itemHdrTbl_01, itemHdrTbl_02, itemHdrTbl_03
    .dsw $0C,$FFFF
    .dw itemHdrTbl_10, itemHdrTbl_11, itemHdrTbl_12, itemHdrTbl_13
    .dsw $0C,$FFFF
    .dw itemHdrTbl_20, itemHdrTbl_21, itemHdrTbl_22, itemHdrTbl_23
    .dsw $0C,$FFFF
    .dw itemHdrTbl_30, itemHdrTbl_31, itemHdrTbl_32, itemHdrTbl_33
    .dsw $0C,$FFFF

itemHdrTbl_00:
    .dw itemHdr_00_0, itemHdr_00_1
itemHdrTbl_01:
    .dw itemHdr_01_0
itemHdrTbl_02:
itemHdrTbl_03:

itemHdrTbl_10:
    .dw itemHdr_10_0, itemHdr_10_1, itemHdr_10_2
itemHdrTbl_11:
itemHdrTbl_12:
    .dw itemHdr_12_0, itemHdr_12_1
itemHdrTbl_13:

itemHdrTbl_20:
itemHdrTbl_21:
    .dw itemHdr_21_0
itemHdrTbl_22:
itemHdrTbl_23:

itemHdrTbl_30:
itemHdrTbl_31:
itemHdrTbl_32:
itemHdrTbl_33:
    .dw itemHdr_33_0

itemHdr_00_0:
    .db "MEADOW LARK OF FEATHER DARK"
    .db newLine          ; A new line
    .db "TOOK WING ON A SUMMER GLOOM",0
itemHdr_00_1:
    .db "DUSKEN SAIL FROM TIP TO TAIL"
    .db newLine
    .db "SAVE A SINGLE SILVER PLUME",0

itemHdr_01_0:
    .db "THIS TABLET HAS INTENTIONALLY"
    .db newLine
    .db "BEEN LEFT BLANK",$5B,0

itemHdr_10_0:
    .db "OVER GLEN AND MOOR SHE",$5E,"D SOAR"
    .db newLine
    .db "ACROSS THE EM",$5E,"RALD LAND",0
itemHdr_10_1:
    .db "SEEKING NIGH WITH EVERY HIE"
    .db newLine
    .db "TO LIGHT ON LOVE",$5E,"S SURE HAND",0
itemHdr_10_2:
    .db "BUT DANGERS LOOM IN UNDERDOOM"
    .db newLine
    .db "TO STEAL THE MORNING LIGHT",0

itemHdr_12_0:
    .db "TO SNATCH AWAY THE GOLDEN RAY"
    .db newLine
    .db "THE LARK WHO SINGS AT NIGHT",0
itemHdr_12_1:
    .db "MEET THE CALL OF FEATHERFALL"
    .db newLine
    .db "PREPARE THY WARRIOR",$5E,"S STEEL",0

itemHdr_21_0:
    .db "BE THE BANE TO BRING THE REIGN"
    .db newLine
    .db "OF AN EVIL DOG TO HEEL",0

itemHdr_33_0:
    .db "HEED THE CALL",$5D," FOR HERO",$5D," ALL"
    .db newLine
    .db "IS HANGING ON THE CUSP",$5B,$5B,$5B,0