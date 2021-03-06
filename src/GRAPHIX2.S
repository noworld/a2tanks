********************************
* Improved Graphix             *
*      Drawing Routines        *
*    Nick Waun                 *
* Created                      *
*    05-04-2017                *
* Modified                     *
*    05-05-2017                *
********************************

 REL
 DSK /TKS/BIN/GRAPHIX.L

* AE, AF
TWID EQU $A7
THGT EQU $A6
TILADR EQU $A4
TCOL EQU $A3
TROW EQU $A2
VIDADR EQU $A0
VIDLINS EQU $82

*-------------------------------
* DRWTIL
* Draw Tile
*
* Routine to draw tiles of
* arbitrary width and height
*    IN:
*        - Screen row is in A
*        - Screen column is in Y
*        - Tile ID is in X
* Column is treated as unsigned
*-------------------------------
DRWTIL ENT

* Save the row
 STA TROW ; Save the row

* Mult the ID by 4 to index
* into tile table
 TXA
 ASL
 ASL
 TAX

* Store and work with the column
 TYA
 STA TCOL

* Get & store the address
* of the tile that we will
* be drawing

 CLC ;Draw to even or odd
 LSR ;column?
 BCC :ISEVEN
 INX ;Bump to next tile location
 INX ;for odd columns
:ISEVEN
 LDA TILTAB,X
 STA TILADR
 INX
 LDA TILTAB,X
 STA TILADR+1

* Set up the first location
* in video memory
 JSR CALCVID

* Load tile metadata
 LDX #$00
 LDA (TILADR,X) ;Load the tile width
 TAY ;Y = width
 STY TWID ;Save
 INC TILADR ;Next tile byte
 LDA (TILADR,X) ;Load the tile height
 TAX ;X = height
 STA THGT ;Save
 INC TILADR ;next tile byte

* Draw the tile to video memory
* TILADR --> VIDADR
 DEX
:DRAWLINE
 DEY
 LDA (TILADR),Y
 STA (VIDADR),Y
 CPY #$00 ;Is Y zero?
 BEQ :NEXTLINE ;continue drawing line y > 0
 JMP :DRAWLINE
:NEXTLINE
 DEX ;Decrement height
 BMI :DONE ;Done if X went negative
 INC TROW ;Increment the target row
 JSR CALCVID ;Set up for next row
 LDY TWID ;Reset width
 TYA
 CLC
 ADC TILADR
 STA TILADR
 BCC :DRAWLINE
 INC TILADR+1 
 CLV ;Trying out a forced branch
 BVC :DRAWLINE ;Continue drawing
:DONE RTS

*-------------------------------
* CALCVID
* Calculate Video Addresses
*
* Set up the target
* address in video memory
* to where we will copy the
* tile data.
* DO NOT MODIFY VIDLINS
* RESTORE X AND Y
*-------------------------------
CALCVID
* Save X and Y
 TYA
 PHA
 TXA
 PHA
* Calculate index into the table
* using row
 LDA VIDLINS+1 ;Store MSB for future use
 STA VIDADR+1
 LDA TROW ;Get the row
 CLC ;Mult by 2 to
 ASL ;index address
 BCC :NOCARRY0
 INC VIDADR+1
 CLC
:NOCARRY0
 ADC VIDLINS
 STA VIDADR
 BCC :NOCARRY1
 INC VIDADR+1
:NOCARRY1
* Get the address for that row
 LDY #$00
 LDA (VIDADR),Y
 TAX
 INY
 LDA (VIDADR),Y
 STA VIDADR+1
 TXA
 STA VIDADR
* Add in the column
 LDA TCOL
 CLC
 ADC VIDADR
 STA VIDADR
 BCC :NOCARRY2
 INC VIDADR+1 ;Carry to MSB
:NOCARRY2
* Restore X and Y
 PLA
 TAX
 PLA
 TAY
 RTS


*===============================
* Tile Definitions Section     *
*===============================

*-------------------------------
* Tile table entries point to a
* tile definition. Address for
* even tile is followed by addr
* for odd tile. This limits to
* 64 tiles per table. Tiles are
* numbered 0, 1, 2, 3... 63
*-------------------------------
TILTAB
 DA GRNTILE ;Even data
 DA GRNTILO ;Odd data
 DA THRGRNTILE
 DA THRGRNTILO
 DA GRALIENE
 DA GRALIENO
 
MASKTAB
 DA GRNTILM
 DA THRGRNTILM

*-------------------------------
* Tile Scanline data
* First byte is tile width in bytes
* Second byte is height in scanlines
*-------------------------------
GRNTILE
 DB $01,$08 ;width,height
 DB $2A
 DB $2A
 DB $2A
 DB $2A
 DB $2A
 DB $2A
 DB $2A
 DB $2A

GRNTILO
 DB $01,$08 ;width,height
 DB $55
 DB $55
 DB $55
 DB $55
 DB $55
 DB $55
 DB $55
 DB $55

THRGRNTILE
 DB $03,$10
 DB $2A,$55,$2A
 DB $2A,$55,$2A
 DB $2A,$55,$2A
 DB $2A,$55,$2A
 DB $2A,$55,$2A
 DB $2A,$55,$2A
 DB $2A,$55,$2A
 DB $2A,$55,$2A
 DB $2A,$55,$2A
 DB $2A,$55,$2A
 DB $2A,$55,$2A
 DB $2A,$55,$2A
 DB $2A,$55,$2A
 DB $2A,$55,$2A
 DB $2A,$55,$2A
 DB $2A,$55,$2A

THRGRNTILO
 DB $03,$10
 DB $55,$2A,$55
 DB $55,$2A,$55
 DB $55,$2A,$55
 DB $55,$2A,$55
 DB $55,$2A,$55
 DB $55,$2A,$55
 DB $55,$2A,$55
 DB $55,$2A,$55
 DB $55,$2A,$55
 DB $55,$2A,$55
 DB $55,$2A,$55
 DB $55,$2A,$55
 DB $55,$2A,$55
 DB $55,$2A,$55
 DB $55,$2A,$55
 DB $55,$2A,$55
 
GRALIENE
 DB $02,$08
 DB $28,$01
 DB $28,$01
 DB $08,$01
 DB $22,$04
 DB $22,$04
 DB $22,$04
 DB $22,$04
 DB $22,$04
 
GRALIENO
 DB $02,$08
 DB $54,$00
 DB $54,$00
 DB $44,$00
 DB $11,$02
 DB $11,$02
 DB $11,$02
 DB $11,$02
 DB $11,$02

*-------------------------------
* Tile Mask data
* Representation of the tile collision
* area in white
*
* First byte is tile width in bytes
* Second byte is height in scanlines
*-------------------------------
GRNTILM
 DB $01,$08 ;width,height
 DB $FF
 DB $FF
 DB $FF
 DB $FF
 DB $FF
 DB $FF
 DB $FF
 DB $FF
 
THRGRNTILM
 DB $03,$10
 DB $FF,$FF,$FF
 DB $FF,$FF,$FF
 DB $FF,$FF,$FF
 DB $FF,$FF,$FF
 DB $FF,$FF,$FF
 DB $FF,$FF,$FF
 DB $FF,$FF,$FF
 DB $FF,$FF,$FF
 DB $FF,$FF,$FF
 DB $FF,$FF,$FF
 DB $FF,$FF,$FF
 DB $FF,$FF,$FF
 DB $FF,$FF,$FF
 DB $FF,$FF,$FF
 DB $FF,$FF,$FF
 DB $FF,$FF,$FF
