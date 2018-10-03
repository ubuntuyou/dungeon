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
    lda chestHeaderTbls,y
    sta chestHdrTblPtr     ; Use nametable to find which table of
    iny                    ;  chest headers to read from.
    lda chestHeaderTbls,y
    sta chestHdrTblPtr+1

    lda chestHdrNo
    asl
    tay
    lda (chestHdrTblPtr),y
    sta chestHdrPtr        ; Then use that offset to index into the
    iny                    ;  message table for that room.
    lda (chestHdrTblPtr),y
    sta chestHdrPtr+1

    ldx lineNo
    lda textLine,x
    sta textAddrL          ; Load addresses of textbox line beginnings
    lda #textBoxStartH
    sta textAddrH

    ldy #$00
@loop:
    lda (chestHdrPtr),y
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

chestHeaderTbls:
    .dw chestHdrTbl_00, chestHdrTbl_01, chestHdrTbl_02, chestHdrTbl_03
    .dsw $0C,$FFFF
    .dw chestHdrTbl_10, chestHdrTbl_11, chestHdrTbl_12, chestHdrTbl_13
    .dsw $0C,$FFFF
    .dw chestHdrTbl_20, chestHdrTbl_21, chestHdrTbl_22, chestHdrTbl_23
    .dsw $0C,$FFFF
    .dw chestHdrTbl_30, chestHdrTbl_31, chestHdrTbl_32, chestHdrTbl_33
    .dsw $0C,$FFFF

chestHdrTbl_00:
    .dw chestHdr_00_0, chestHdr_00_1
chestHdrTbl_01:
    .dw chestHdr_01_0
chestHdrTbl_02:
chestHdrTbl_03:

chestHdrTbl_10:
    .dw chestHdr_10_0, chestHdr_10_1, chestHdr_10_2
chestHdrTbl_11:
chestHdrTbl_12:
    .dw chestHdr_12_0, chestHdr_12_1
chestHdrTbl_13:

chestHdrTbl_20:
chestHdrTbl_21:
    .dw chestHdr_21_0
chestHdrTbl_22:
chestHdrTbl_23:

chestHdrTbl_30:
chestHdrTbl_31:
chestHdrTbl_32:
chestHdrTbl_33:
    .dw chestHdr_33_0

chestHdr_00_0:
    .db "MEADOW LARK OF FEATHER DARK"
    .db newLine          ; A new line
    .db "TOOK WING ON A SUMMER GLOOM",0
chestHdr_00_1:
    .db "DUSKEN SAIL FROM TIP TO TAIL"
    .db newLine
    .db "SAVE A SINGLE SILVER PLUME",0

chestHdr_01_0:
    .db "THIS CHEST HAS INTENTIONALLY"
    .db newLine
    .db "BEEN LEFT BLANK",$5B,0

chestHdr_10_0:
    .db "OVER GLEN AND MOOR SHE",$5E,"D SOAR"
    .db newLine
    .db "ACROSS THE EM",$5E,"RALD LAND",0
chestHdr_10_1:
    .db "SEEKING NIGH WITH EVERY HIE"
    .db newLine
    .db "TO LIGHT ON LOVE",$5E,"S SURE HAND",0
chestHdr_10_2:
    .db "BUT DANGERS LOOM IN UNDERDOOM"
    .db newLine
    .db "TO STEAL THE MORNING LIGHT",0

chestHdr_12_0:
    .db "TO SNATCH AWAY THE GOLDEN RAY"
    .db newLine
    .db "THE LARK WHO SINGS AT NIGHT",0
chestHdr_12_1:
    .db "MEET THE CALL OF FEATHERFALL"
    .db newLine
    .db "PREPARE THY WARRIOR",$5E,"S STEEL",0

chestHdr_21_0:
    .db "BE THE BANE TO BRING THE REIGN"
    .db newLine
    .db "OF AN EVIL DOG TO HEEL",0

chestHdr_33_0:
    .db "HEED THE CALL",$5D," FOR HERO",$5D," ALL"
    .db newLine
    .db "IS HANGING ON THE CUSP",$5B,$5B,$5B,0