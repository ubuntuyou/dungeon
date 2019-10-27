loadEnemies:
    ldy #$00                ; Loads item sprites to sprite ram
enemyLoop:
    lda (enemyPtr),y
;    cmp #$FE
    beq @fillLoop
    sta enemyRAM,y
    iny
    bvc enemyLoop

@fillLoop
    lda #$FE
    sta enemyRAM,y
    iny
    cpy #$40
    bne @fillLoop
loadEnemiesDone:
    rts

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
    .db %00000111, %00000001, %00000000, %00000000, %00000000
    .dsb $0B,$00
    .db %00000111, %00000000, %00000011, %00000000
    .dsb $0C,$00
    .db %00000000, %00000001, %00000000, %00000000
    .dsb $0C,$00
    .db %00000000, %00000000, %00000000, %00000001
    .dsb $0C,$00
    
enemyHeader00:
    .db $00

enemyHeader01:
    .db $5F,$35,%00000011,$30
    .db $5F,$36,%00000011,$38

    .db $67,$35,%00000011,$48
    .db $67,$36,%00000011,$50
    .db $00
    
enemyHeader02:
enemyHeader03:
enemyHeader04:
    .db $00

enemyHeader10:
    .db $4F,$33,%00000010,$30
    .db $4F,$33,%01000010,$38
    .db $57,$34,%00000010,$30
    .db $57,$34,%01000010,$38

    .db $4F,$33,%00000010,$40
    .db $4F,$33,%01000010,$48
    .db $57,$34,%00000010,$40
    .db $57,$34,%01000010,$48
    
    .db $4F,$33,%00000010,$50
    .db $4F,$33,%01000010,$58
    .db $57,$34,%00000010,$50
    .db $57,$34,%01000010,$58
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
    .db $5F,$35,%00000010,$60
    .db $5F,$36,%00000010,$68
    .db $00