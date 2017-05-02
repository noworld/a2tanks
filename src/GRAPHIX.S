********************************
* Graphics Drawing Routines    *
*    Nick Waun                 *
*    02-01-2017                *
*    02-21-2017                *
********************************

 REL
 DSK /EK/BIN/GRAPHIX.L

HGRROWS EXT  ;Table of HGR screen rows
HGRLINS EXT  ;Table of HGR scanlines

VIDADR EQU $80
VIDIDX EQU $AC
GRVAR EQU $A0
TEMP EQU $AE

*-------------------------------
* DRWTIL
* Draw Tile
*
* Routine to draw 8x8 tiles
* at specified coordinates
*    IN:
*        - Screen column is in A
*        - Screen row is in Y
*        - Tile ID is in X
*-------------------------------
DRWTIL ENT
 PHA ;Save column (3)
 STY TEMP ;Save row (3)
 JSR GETTIL ;Get tile data
 PLA ;Load column
 TAY  ;Column in Y
 LDA TEMP ;Load row in A
 LDX GRVAR+3 ; Load tile height
 JSR CALCADR ;Set up screen addresses
:LOOP LDX GRVAR+3 ; Load tile height again
 JSR DODRAW ;Draw the tile
 LDY GRVAR+3 ; Load tile height again
 JSR INCVID
 DEC GRVAR+2 ;Decrement width
 BNE :LOOP ; Loop until zero
 RTS

*-------------------------------
* GETTIL
* Loads the tile data into zero
* page locations
*     IN:
*        - Screen column is in A
*        - Tile ID is in X
*        - Y is undefined
*     OUT:
*        - GRVAR is Tile Address
*        - GRVAR+2 is Tile Width
*        - GRVAR+3 is Tile Height
*        - A,X,Y are undefined
*-------------------------------
GETTIL PHA ;Save column number to stack
* Load the address of the tile data
 TXA ;Transfer in the tile ID
 ASL ;Multiply by 2 to index an address
 TAX
 LDA TILTAB,X ; Get the address of the
 STA GRVAR ; tile data
 INX
 LDA TILTAB,X
 STA GRVAR+1
* Load the tile data
 PLA ;Load the column number into the acc
 TAX ; Col # is now in X
 LDY #$00 ;Clear Y
 LDA (GRVAR),Y ;Load the tile width
 STA GRVAR+2
 INY
 LDA (GRVAR),Y ;Load the tile height
 STA GRVAR+3
 INY
 CLC
 TXA ;Load the column number into A
 LSR ;Test if the column number is even or odd
 BCC :ISEVEN
 INY ;If carry is set, col is odd
 INY ;and go after odd address
:ISEVEN LDA (GRVAR),Y ;Load tile data address
 TAX
 INY
 LDA (GRVAR),Y
 STA GRVAR+1 ;Store in GRVAR
 TXA
 STA GRVAR
 RTS

*-------------------------------
* CALCADR
* Loads the screen scanline data
*     IN:
*        - A is row #
*        - Tile height is in X
*        - Y is column #
*     OUT:
*        - VIDADR contains up to
*          16 sequential scan
*          line addresses
*        - A,X,Y are undefined
*-------------------------------
CALCADR STY TEMP ; Save off the column
 CLC
 ASL ; Mult row by 2 to index addr
 TAY ; Index off of Y
* Get video address table location
 LDA #<HGRLINS
 STA VIDIDX
 LDA #>HGRLINS
 STA VIDIDX+1 ;VIDIDX now holds base address into table
 TYA ; Put row index back in A
* Index into video address table
 CLC
 ADC VIDIDX ;Add to table base
 STA VIDIDX ;Store back
 BCC :NOCARRY
 INC VIDIDX+1 ;Increment if there was a carry
:NOCARRY LDY #$00 ;Clear Y
* Load each address, adding in the column
:LOOP LDA (VIDIDX),Y ;Get next Y (LSB)
 CLC
 ADC TEMP ;Add in column
 STA VIDADR,Y ; Store in VIDADR
 INY ; Next address
 LDA (VIDIDX),Y ;Get next Y (MSB)
 ADC #$00 ; Add in carry
 STA VIDADR,Y
 INY
 DEX ;Decrement the tile height counter
 BNE :LOOP ; Loop through all scanlines
 RTS

*-------------------------------
* DODRAW
* Draws the tile
*     IN:
*        - GRVAR contains Tile Address
*        - X contains tile height
*        - A and Y are undefined
*        - VIDADR contains up to
*          16 sequential scan
*          line addresses
*     OUT:
*        - A,X,Y are undefined
*        - Video memory contains
*          graphics data
*-------------------------------
DODRAW
 CLC
 TXA
 TAY
 ASL ;Multiply X by two to index addr
 TAX ;Index off of both X and Y
:DRAWLP
 DEY
 DEX
 DEX
 BMI :DONE
 LDA (GRVAR),Y ;Load tile data from table
 STA (VIDADR,X); Store tile data to video mem
 JMP :DRAWLP
:DONE RTS

*-------------------------------
* INCVID
* Increments the columns of the
* graphics page addresses stored
* in VIDADR. Increments the tile
* address stored in GRVAR by the
* tile height.
*     IN:
*        - Y contains tile height
*        - VIDADR contains up to
*          16 sequential scan
*          line addresses
*     OUT:
*        - A, X, and Y are undefined
*        - VIDADR contains up to
*          16 sequential scan
*          line addresses,
*          incremented
*-------------------------------
INCVID TYA
 CLC
 ADC GRVAR ;Add to GRVAR LSB
 STA GRVAR
 LDA GRVAR+1 ;Add carry to MSB
 ADC #$00
 STA GRVAR+1
 LDX #$00
:LOOP INC VIDADR,X ;Up the LSB
 BNE :CONT ;If not zero, continue
 INC VIDADR+1,X ;Else, up the MSB
:CONT INX ;Increment X to next address
 INX
 DEY ;Decrement counter
 BNE :LOOP ;Loop until zero
 RTS

*===============================
* Tile Definitions Section     *
*===============================

*-------------------------------
* Tile table entries point to a
* tile definition
*-------------------------------
TILTAB DA GRNTILD
 DA PURTILD
 DA BLUTILD
 DA ORATILD
 DA WHITILD
 DA BLKTILD
 DA THREEWTILD

*-------------------------------
* Green tile definition
* Specifies:
*     - width in bytes (1-3)
*     - height in scanlines (1-16)
*     - even tile data address
*     - odd tile data address
*-------------------------------
GRNTILD ;Tile definitions
 DB $01 ;1 byte x 8 scanline tile
 DB $08
 DA GRNTILE ;Even data
 DA GRNTILO ;Odd data

*-------------------------------
* Purple tile definition
*-------------------------------
PURTILD ;Tile definitions
 DB $01 ;1 byte x 8 scanline tile
 DB $08
 DA PURTILE ;Even data
 DA PURTILO ;Odd data

*-------------------------------
* Blue tile definition
*-------------------------------
BLUTILD ;Tile definitions
 DB $01 ;1 byte x 8 scanline tile
 DB $08
 DA BLUTILE ;Even data
 DA BLUTILO ;Odd data

*-------------------------------
* Orange tile definition
*-------------------------------
ORATILD ;Tile definitions
 DB $01 ;1 byte x 8 scanline tile
 DB $08
 DA ORATILE ;Even data
 DA ORATILO ;Odd data

*-------------------------------
* White tile definition
*-------------------------------
WHITILD ;Tile definitions
 DB $01 ;1 byte x 8 scanline tile
 DB $08
 DA WHITILE ;Even data
 DA WHITILO ;Odd data

*-------------------------------
* Black tile definition
*-------------------------------
BLKTILD ;Tile definitions
 DB $01 ;1 byte x 8 scanline tile
 DB $08
 DA BLKTILO ;Even data
 DA BLKTILO ;Odd data

THREEWTILD
 DB $03 ;3 byte x 16 scanline tile
 DB $10
 DA THRGRNTILE
 DA THRGRNTILO


*-------------------------------
* Tile Scanline data
*-------------------------------
PURTILE DB $55 ;even purple tile
 DB $55
 DB $55
 DB $55
 DB $55
 DB $55
 DB $55
 DB $55

PURTILO DB $2A ;Odd purple tile
 DB $2A
 DB $2A
 DB $2A
 DB $2A
 DB $2A
 DB $2A
 DB $2A

GRNTILE DB $2A
 DB $2A
 DB $2A
 DB $2A
 DB $2A
 DB $2A
 DB $2A
 DB $2A

GRNTILO DB $55
 DB $55
 DB $55
 DB $55
 DB $55
 DB $55
 DB $55
 DB $55

BLUTILE DB $D5
 DB $D5
 DB $D5
 DB $D5
 DB $D5
 DB $D5
 DB $D5
 DB $D5

BLUTILO DB $AA
 DB $AA
 DB $AA
 DB $AA
 DB $AA
 DB $AA
 DB $AA
 DB $AA

ORATILE DB $AA
 DB $AA
 DB $AA
 DB $AA
 DB $AA
 DB $AA
 DB $AA
 DB $AA

ORATILO DB $D5
 DB $D5
 DB $D5
 DB $D5
 DB $D5
 DB $D5
 DB $D5
 DB $D5

WHITILE DB $FF
 DB $7F
 DB $FF
 DB $7F
 DB $FF
 DB $7F
 DB $FF
 DB $7F

WHITILO DB $7F
 DB $FF
 DB $7F
 DB $FF
 DB $7F
 DB $FF
 DB $7F
 DB $FF

BLKTILO DB $00
 DB $00
 DB $00
 DB $00
 DB $00
 DB $00
 DB $00
 DB $00

THRGRNTILE
 DB $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A
 DB $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
 DB $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A

THRGRNTILO
 DB $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
 DB $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A
 DB $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
