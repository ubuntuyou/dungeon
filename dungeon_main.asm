;;;;;;;;;;;;;;;;;;;;;;;
;;;   iNES HEADER   ;;;
;;;;;;;;;;;;;;;;;;;;;;;

    .db  "NES", $1a     ;identification of the iNES header
    .db  PRG_COUNT      ;number of 16KB PRG-ROM pages
    .db  CHR_COUNT      ;number of 8KB CHR-ROM pages
    .db  $10|MIRRORING  ;mapper 0 and mirroring
    .dsb $09, $00       ;clear the remaining bytes

    .fillvalue $FF

;;;;;;;;;;;;;;;;;;;;;
;;;   VARIABLES   ;;;
;;;;;;;;;;;;;;;;;;;;;

    .enum $0000
    
screenPtr       .dsb 2
attributePtr    .dsb 2
itemPtr         .dsb 2
animationPtr    .dsb 2
collisionPtr    .dsb 2
itemHdrTblPtr   .dsb 2
itemHdrPtr      .dsb 2
textBoxPtr      .dsb 2
enemyPtr        .dsb 2
enemyDefPtr     .dsb 2
palettePtr      .dsb 2

    .enum $0040
gameState       .dsb 1
softPPU_Control .dsb 1
softPPU_Mask    .dsb 1
prgNo           .dsb 1
prgNoOld        .dsb 1
paletteCtr      .dsb 1
paletteCounter  .dsb 1

    .enum $0050

metatile        .dsb 1
rowCounter      .dsb 1
counter         .dsb 1
nametable       .dsb 1
nametableL		.dsb 1
nametableH		.dsb 1
needDraw        .dsb 1
needItems       .dsb 1

    .enum $0060
hrs             .dsb 1
mins            .dsb 1
secs            .dsb 1
tick            .dsb 1

sleeping        .dsb 1

RNG             .dsb 1
RNGseed         .dsb 1

    .enum $0070

buttons         .dsb 1
oldButtons      .dsb 1
moving          .dsb 1
upIsPressed     .dsb 1
downIsPressed   .dsb 1
leftIsPressed   .dsb 1
rightIsPressed  .dsb 1

    .enum $0080

playerDir       .dsb 1
playerDirOld    .dsb 1
playerSpeed     .dsb 2
playerX         .dsb 1
playerY         .dsb 1
player_TOP      .dsb 1
player_BOTTOM   .dsb 1
player_LEFT     .dsb 1
player_RIGHT    .dsb 1
spriteX         .dsb 1
spriteY         .dsb 1
spriteXpos      .dsb 1
spriteYpos		.dsb 1
PS				.dsb 1

    .enum $0090

item_TOP        .dsb 1
item_BOTTOM     .dsb 1
item_LEFT       .dsb 1
item_RIGHT      .dsb 1

messageNo       .dsb 1
itemNo          .dsb 1
itemHdrNo       .dsb 1
itemStrAddr     .dsb 1

    .enum $00A0

BGtype          .dsb 1
spriteLoc       .dsb 1
hotspot         .dsb 1
ejectMod        .dsb 1

itemFlagsTemp   .dsb 1
enemyFlagsTemp  .dsb 1
animationEnable .dsb 1
frameCounter    .dsb 2
animationNumber .dsb 1
animConstNumber .dsb 3

    .enum $00B0

textCounter     .dsb 1
needTextAttrib  .dsb 1
textBoxActive   .dsb 1
restoreTB       .dsb 1
textBoxRows     .dsb 1
textIndirect    .dsb 1
textSpeed       .dsb 1
stringLength    .dsb 1
stringCtr       .dsb 1
lineNo          .dsb 1
textAddrL       .dsb 1
textAddrH       .dsb 1
temp            .dsb 4

    .enum $04C0

enemyIndex      .dsb 8
enemyY          .dsb 8
enemyX          .dsb 8
enemyDir        .dsb 8
enemy_TOP       .dsb 1
enemy_BOTTOM    .dsb 1
enemy_LEFT      .dsb 1
enemy_RIGHT     .dsb 1
enemySpeed      .dsb 3
enemyNo         .dsb 1
enemyCtr        .dsb 1
enemyBBmodX     .dsb 8
enemyBBmodY     .dsb 8

    .ende

;;;;;;;;;;;;;;;;;;;;;
;;;   CONSTANTS   ;;;
;;;;;;;;;;;;;;;;;;;;;

PRG_COUNT       = 4       ;1 = 16KB, 2 = 32KB
CHR_COUNT       = 2
MIRRORING       = %0001   ;%0000 = horizontal, %0001 = vertical, %1000 = four-screen

PPU_Control     .equ $2000
PPU_Mask        .equ $2001
PPU_Status      .equ $2002
PPU_Scroll      .equ $2005
PPU_Address     .equ $2006
PPU_Data        .equ $2007

;MAP_
MAP_Control     .equ $8000
MAP_CHR0        .equ $A000
MAP_CHR1        .equ $C000
MAP_PRG         .equ $E000

spriteRAM       .equ $0204
itemRAM         .equ $0220
enemyRAM        .equ $0260
colRAM			.equ $0700
itemSoftFlags   .equ $6000
enemySoftFlags  .equ $6100
bkgBuffer       .equ $6200
atbBuffer       .equ $62E0

textBuffer      .equ $0400
textBoxStartL   .equ $41
textBoxStartH   .equ $20
itemNumBuff     .equ $0580

controller1     .equ $4016

;;;;;;;;;;;;;;;;;;;;;
;;;               ;;;
;;;   BANK ZERO   ;;;
;;;               ;;;
;;;;;;;;;;;;;;;;;;;;;

    .base $8000

	.include "nametables.asm"

    .pad $C000


;;;;;;;;;;;;;;;;;;;;
;;;              ;;;
;;;   BANK ONE   ;;;
;;;              ;;;
;;;;;;;;;;;;;;;;;;;;

    .base $8000
    
    .include "textEngine.asm"
;    .include "animation.asm"

    .pad $C000

;;;;;;;;;;;;;;;;;;;;
;;;              ;;;
;;;   BANK TWO   ;;;
;;;              ;;;
;;;;;;;;;;;;;;;;;;;;

    .base $8000
;    .pad $C000

;;;;;;;;;;;;;;;;;;;;;;
;;;                ;;;
;;;   BANK THREE   ;;;
;;;                ;;;
;;;;;;;;;;;;;;;;;;;;;;

;    .base $8000
;    .pad $C000

;;;;;;;;;;;;;;;;;;;;;
;;;               ;;;
;;;   BANK FOUR   ;;;
;;;               ;;;
;;;;;;;;;;;;;;;;;;;;;

;    .base $8000
;    .pad $C000

;;;;;;;;;;;;;;;;;;;;;
;;;               ;;;
;;;   BANK FIVE   ;;;
;;;               ;;;
;;;;;;;;;;;;;;;;;;;;;

;    .base $8000
;    .pad $C000

;;;;;;;;;;;;;;;;;;;;;;
;;;                ;;;
;;;   BANK SEVEN   ;;;
;;;                ;;;
;;;;;;;;;;;;;;;;;;;;;;

;    .base $8000
;    .pad $C000

;;;;;;;;;;;;;;;;;;;;;;
;;;                ;;;
;;;   BANK EIGHT   ;;;
;;;                ;;;
;;;;;;;;;;;;;;;;;;;;;;

;    .base $8000
;    .pad $C000

;;;;;;;;;;;;;;;;;;;;;
;;;               ;;;
;;;   BANK NINE   ;;;
;;;               ;;;
;;;;;;;;;;;;;;;;;;;;;

;    .base $8000
;    .pad $C000

;;;;;;;;;;;;;;;;;;;;
;;;              ;;;
;;;   BANK TEN   ;;;
;;;              ;;;
;;;;;;;;;;;;;;;;;;;;

;    .base $8000
;    .pad $C000

;;;;;;;;;;;;;;;;;;;;;;;
;;;                 ;;;
;;;   BANK ELEVEN   ;;;
;;;                 ;;;
;;;;;;;;;;;;;;;;;;;;;;;

;    .base $8000
;    .pad $C000

;;;;;;;;;;;;;;;;;;;;;;;
;;;                 ;;;
;;;   BANK TWELVE   ;;;
;;;                 ;;;
;;;;;;;;;;;;;;;;;;;;;;;

;    .base $8000
;    .pad $C000

;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                   ;;;
;;;   BANK THIRTEEN   ;;;
;;;                   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;    .base $8000
;    .pad $C000

;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                   ;;;
;;;   BANK FOURTEEN   ;;;
;;;                   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;    .base $8000
;    .pad $C000

;;;;;;;;;;;;;;;;;;;;;;;;
;;;                  ;;;
;;;   BANK FIFTEEN   ;;;
;;;                  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;

;    .base $8000
    .pad $C000
;;;;;;;;;;;;;;;;;
;;;   RESET   ;;;
;;;;;;;;;;;;;;;;;

RESET:
    sei
    cld
    lda #$40
    sta $4017
    ldx #$FF
    txs
    stx MAP_Control
    inx
    stx PPU_Control
    stx PPU_Mask
    stx $4010

vblank1:
    bit PPU_Status
    bpl vblank1

clrmem:
    lda #$00
    sta $0000,x
    sta $0100,x
    sta $0300,x
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    sta $6000,x
    sta $6100,x
    sta $6200,x
    sta $6300,x
    lda #$FF
    sta $0200,x
    inx
    bne clrmem

    lda #%00011110
    jsr setMapperControl

    lda #%00000000
    jsr setMapperCHR0
    
    lda #%00000001
    jsr setMapperCHR1

    lda #%00000000
    jsr setMapperPRG

loadSprite1:
    ldx #$00
@loop:
    lda sprite1,x
    sta spriteRAM,x
    inx
    cpx #$14
    bne @loop
loadSprite1done:

loadNametable:
    lda #$01
    sta needDraw
    lda #$00
    sta nametable
loadNametableDone:

    lda #$00
    sta secs
    lda #$00
    sta mins
    lda #$0C
    sta hrs

    lda #$85
    sta playerX
    lda #$A0
    sta playerY
    
    lda #$07
    sta textCounter

    lda #$00
    sta gameState
    lda #$08
    sta textSpeed
    lda #$61
    sta textAddrL
    lda #$20
    sta textAddrH

    lda #$01
    sta PS
    sta playerSpeed
    sta enemySpeed

    lda #$FF
    sta RNGseed
    
    lda #$18
    sta paletteCounter
    lda #$04
    sta paletteCtr
    
    lda #$30
    sta frameCounter

    jsr loadFlags

vblank2:
    bit PPU_Status
    bpl vblank2

loadPalettes:
    lda PPU_Status
    lda #$3F
    sta PPU_Address
    lda #$00
    sta PPU_Address

    ldx #$00
@loop:
    lda palette,x
    sta PPU_Data
    inx
    cpx #$20
    bne @loop
loadPalettesDone:

    lda #%10010000
    sta softPPU_Control
    sta PPU_Control
    lda #%00011110
    sta softPPU_Mask
    sta PPU_Mask

    jmp MAIN

timeKeeping:
    inc tick
    lda tick
    cmp #$3C
    beq seconds
    bvc timeKeepingDone
seconds:
    lda #$00
    sta tick
    inc secs
    lda secs
    cmp #$3C
    beq minutes
    bvc timeKeepingDone
minutes:
    lda #$00
    sta secs
    inc mins
    lda mins
    cmp #$3C
    beq hours
    bvc timeKeepingDone
hours:
    lda #$00
    sta mins
    inc hrs
    lda hrs
    cmp #$0D
    bne timeKeepingDone
    lda #$01
    sta hrs
timeKeepingDone:
    rts
    
setMapperControl:
    sta MAP_Control
    lsr A
    sta MAP_Control
    lsr A
    sta MAP_Control
    lsr A
    sta MAP_Control
    lsr A
    sta MAP_Control
setMapperControlDone:
    rts
    
setMapperCHR0:
    sta MAP_CHR0
    lsr A
    sta MAP_CHR0
    lsr A
    sta MAP_CHR0
    lsr A
    sta MAP_CHR0
    lsr A
    sta MAP_CHR0
setMapperCHR0done:
    rts
    
setMapperCHR1:
    sta MAP_CHR1
    lsr A
    sta MAP_CHR1
    lsr A
    sta MAP_CHR1
    lsr A
    sta MAP_CHR1
    lsr A
    sta MAP_CHR1
setMapperCHR1done:
    rts
    
setMapperPRG:
    sta MAP_PRG
    lsr A
    sta MAP_PRG
    lsr A
    sta MAP_PRG
    lsr A
    sta MAP_PRG
    lsr A
    sta MAP_PRG
setMapperPRGdone:
    rts

random:
    lda RNG
    asl A
    asl A
    clc
    adc RNG
    clc
    adc RNGseed
    sta RNG
    
    tay
    and #$F0
    cmp #$40
    bcc random
    cmp #$B0
    bcs random

    tya
    and #$0F
    cmp #$04
    bcc random
    cmp #$0C
    bcs random

    tya
randomDone:
    rts
    
waitForInput:
    lda RNGseed
    cmp #$FF
    bne waitForInputDone

    inc tick
    jsr latchController
    lda buttons
    beq waitForInputDone
    lda tick
    ora #$01
    sta RNGseed
waitForInputDone:
    rts

    
;;;;;;;;;;;;;;;;;;;;
;;;   INCLUDES   ;;;
;;;;;;;;;;;;;;;;;;;;

    .include "background&items.asm"
    
    .include "enemies.asm"

    .include "input.asm"

    .include "collision.asm"

    .include "animation.asm"
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;   MAIN INDIRECTION   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mainStatesL:
    .dl blank-1
    .dl playingMAIN-1
    .dl textBoxMAIN-1
mainStatesH:
    .dh blank-1
    .dh playingMAIN-1
    .dh textBoxMAIN-1

mainIndirect:
    ldx gameState

    lda mainStatesH,x
    pha
    lda mainStatesL,x
    pha

    lda prgNo
    cmp prgNoOld
    beq mainIndirectDone
    sta prgNoOld
    jsr setMapperPRG
mainIndirectDone:
    rts

playingMAIN:
    jsr waitForInput

updateLoc:
    lda playerDir
    sta playerDirOld

    jsr updateSpriteLoc
    jsr updateEnemyLoc
    jsr updatePlayerCol
    jsr checkEnemies

readInput:
    jsr readRight
    jsr readLeft
    jsr readDown
    jsr readUp
    jsr readB
    jsr readA
readInputDone:

processInput:
    jsr moveH
    jsr moveV
processInputDone:
    jsr enemyLogic

;    lda #$01
;	sta prgNo
;	jsr setMapperPRG
    jsr updateFrames
;    lda #$00
;    sta prgNo
;    jsr setMapperPRG
playingMAINdone:
    rts

textBoxMAIN:
    ldx textIndirect

    lda textMAINindH,x
    pha
    lda textMAINindL,x
    pha

    rts

    fillTextBuffer:
        jsr lookupMessage
        inc textIndirect
    fillTextBufferDone:
        rts

    speedUp:
        lda buttons
        and #%10000000
        beq speedUpDone

        lda #$01
        cmp textSpeed
        beq speedUpDone

        sta textSpeed
    speedUpDone:
        rts

    advanceTB:
        lda buttons
        and #%10000000
        beq advanceTBdone

        lda oldButtons
        and #%10000000
        bne advanceTBdone

        lda #$05
        sta textIndirect
        lda #$00
        sta stringCtr
        sta textCounter
    advanceTBdone:
        rts

    startNewLine:
        inc lineNo
        ldx lineNo
        lda textLine,x
        sta textAddrL
        inc stringCtr
        lda #$02
        sta textIndirect
    startNewLineDone:
        rts
textBoxMAINdone:


;;;;;;;;;;;;;;;;;;;;;;;;;
;;;   NMI INDIRECTS   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;

nmiStatesL:
    .dl blank-1
    .dl blank-1
    .dl textBoxNMI-1
nmiStatesH:
    .dh blank-1
    .dh blank-1
    .dh textBoxNMI-1

nmiIndirect:
    ldx gameState

    lda nmiStatesH,x
    pha
    lda nmiStatesL,x
    pha

    lda prgNo
    cmp prgNoOld
    beq nmiIndirectDone
    sta prgNoOld
    jsr setMapperPRG
nmiIndirectDone:
    rts

textBoxNMI:
    ldx textIndirect

    lda textNMIindH,x
    pha
    lda textNMIindL,x
    pha
    rts

    drawTB:
        lda textCounter
        cmp #$07
        bne @skip
        lda #$01
        sta textIndirect
        rts

    @skip
        jsr drawTextBox

        lda needTextAttrib
        beq textBoxNMIdone
        jsr drawTextAttrib
    drawTBdone:
        rts

    writeString:
        jsr readStringBuff
    writeStringDone:
        rts
        
    restoreBkg:
        lda textCounter
        cmp #$07
        bne @skip
        lda #$01
        sta gameState
        rts

    @skip
        jsr restorePPUbuffer

        lda needTextAttrib
        beq textBoxNMIdone
        jsr restoreTextAttrib
    restoreBkgDone:
        rts

textBoxNMIdone:


blank:
    rts

textMAINindL:
    .dl blank-1
    .dl fillTextBuffer-1
    .dl speedUp-1
    .dl advanceTB-1
    .dl startNewLine-1
    .dl blank-1
textMAINindH:
    .dh blank-1
    .dh fillTextBuffer-1
    .dh speedUp-1
    .dh advanceTB-1
    .dh startNewLine-1
    .dh blank-1

textNMIindL:
    .dl drawTB-1
    .dl blank-1
    .dl writeString-1
    .dl blank-1
    .dl blank-1
    .dl restoreBkg-1
textNMIindH:
    .dh drawTB-1
    .dh blank-1
    .dh writeString-1
    .dh blank-1
    .dh blank-1
    .dh restoreBkg-1

;;;;;;;;;;;;;;;;
;;;   MAIN   ;;;
;;;;;;;;;;;;;;;;

    .align $100

MAIN:
    inc sleeping        ; MAIN jumps here after one iteration. Increments sleeping so loop is active.
loop:
    lda sleeping        ; Do-nothing routine. NMI returns here with sleeping set to 0.
    bne loop

    jsr mainIndirect

; showCPUusageBar:
;     ldx #%00011111      ; sprites + background + monochrome (i.e. WHITE)
;     stx PPU_Mask
;     ldy #$08            ; add about 23 for each additional line (leave it on WHITE for one scan line)
; -   dey
;     bne -
;     dex                 ; sprites + background + NO monochrome  (i.e. #%00011110)
;     stx PPU_Mask

    jmp MAIN

;;;;;;;;;;;;;;;
;;;   NMI   ;;;
;;;;;;;;;;;;;;;

NMI:
    pha
    txa
    pha
    tya
    pha

    lda #$00
    sta $2003
    lda #$02
    sta $4014

drawBkgRoutine:
    lda needDraw
    beq NMIroutine

	lda softPPU_Control
	eor #$80
	sta PPU_Control

    jsr drawBkg
    lda softPPU_Control
    sta PPU_Control

	jmp NMIend
NMIroutine:
    jsr nmiIndirect

frame:
    dec frameCounter
    lda frameCounter
    bne frameDone
    ora #$30
    sta frameCounter
frameDone:

PRGswap:
    dec paletteCounter
    lda paletteCounter
    bne PRGswapDone
    ora #$0A
    sta paletteCounter
    
    dec paletteCtr
    lda paletteCtr
    bne @skip
    lda #$03
    sta paletteCtr
@skip
    jsr setMapperCHR1
PRGswapDone:

    jsr latchController

    lda #$00
    sta sleeping
    sta PPU_Address
    sta PPU_Address
    sta PPU_Scroll
    sta PPU_Scroll
PPU:
    lda softPPU_Control
    sta PPU_Control
    lda softPPU_Mask
    sta PPU_Mask

NMIend:
    pla
    tay
    pla
    tax
    pla
    rti

;;;;;;;;;;;;;;;;;;;
;;;   VECTORS   ;;;
;;;;;;;;;;;;;;;;;;;

bitMask:
    .db %00000001, %00000010, %000000100, %00001000, %00010000, %00100000, %01000000, %10000000

sprite1:
    .db $00,$06,%00000001,$00
    .db $00,$0E,%00000000,$00
    .db $00,$0E,%01000000,$00
    .db $00,$10,%00000000,$00
    .db $00,$10,%01000000,$00


spriteAnim:
    .db $06,$01, $02,$00, $03,$00, $12,$00, $13,$00
    .db $06,$01, $0E,$00, $0E,$40, $10,$00, $10,$40
    .db $06,$01, $03,$40, $02,$40, $13,$40, $12,$40

    .db $16,$01, $04,$00, $05,$00, $14,$00, $15,$00
    .db $16,$01, $01,$00, $01,$40, $11,$00, $11,$40
    .db $16,$01, $05,$40, $04,$40, $15,$40, $14,$40

    .db $07,$01, $08,$00, $09,$00, $18,$00, $19,$00
    .db $07,$01, $0A,$00, $0B,$00, $1A,$00, $1B,$00
    .db $07,$01, $0C,$00, $0D,$00, $1C,$00, $1D,$00

    .db $17,$01, $09,$40, $08,$40, $19,$40, $18,$40
    .db $17,$01, $0B,$40, $0A,$40, $1B,$40, $1A,$40
    .db $17,$01, $0D,$40, $0C,$40, $1D,$40, $1C,$40

animationConstants:
    .db $00,$0A,$14,$1E,$28,$32
    .db $3C,$46,$50,$5A,$64,$6E
    
palettesL:
    .dl water0, water1, water2

palettesH:
    .dh water0, water1, water2
    
water0:
    .db $0F, $01, $21, $11
water1:
    .db $0F, $21, $11, $01
water2:
    .db $0F, $11, $01, $21


palette:
    .db $0F,$2D,$10,$20,  $0F,$08,$0A,$0C,  $0F,$01,$11,$21,  $0F,$2D,$09,$1A   ;;background palette
    .db $0F,$17,$00,$10,  $0F,$17,$28,$39,  $0F,$20,$10,$00,  $0F,$17,$1A,$29   ;;sprite palette

    .pad $FFFA

    .dw NMI
    .dw RESET
    .dw 0
    
;;;;;;;;;;;;;;;;;;;
;;;   CHR-ROM   ;;;
;;;;;;;;;;;;;;;;;;;

    .incbin "screenchange&sprite.chr"
    .incbin "META.chr"
