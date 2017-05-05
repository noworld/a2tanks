********************************
* Improved Graphix             *
*      Drawing Routines        *
*    Nick Waun                 *
*    05-04-2017                *
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
 JMP :DRAWLINE ;Continue drawing
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
 LDA VIDLINS ;LSB
 STA VIDADR
 LDA VIDLINS+1 ;Store the MSB of video
 STA VIDADR+1 ; base address for later
 LDA TROW ;Get the destination row
 CLC ;Mult by 2 to index addr
 ASL
 BCC :NOCARRY0
 INC VIDADR+1
:NOCARRY0
 CLC
 ADC VIDADR ;Add to table base
 STA VIDADR ;Save the tile draw address
 BCC :NOCARRY1
 INC VIDADR+1 ;Carry to MSB
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
* 32 tiles per table. Tiles are
* numbered 0, 1, 2, 3...
*-------------------------------
TILTAB
 DA GRNTILE ;Even data
 DA GRNTILO ;Odd data
 DA THRGRNTILE
 DA THRGRNTILO

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
 DB $03,$16
 DB $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A
 DB $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
 DB $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A

THRGRNTILO
 DB $03,$16
 DB $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
 DB $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A
 DB $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
