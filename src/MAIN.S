********************************
* TANKS Combat Game            *
* Main Entry Point             *
*    Nick Waun                 *
* Created                      *
*    05-02-2017                *
* Modified                     *
*    05-05-2017                *
********************************

 REL
 DSK /TKS/BIN/MAIN.L

COL80 EQU $C00D
TXTMOD EQU $C051
MLI EQU $BF00
ROW EQU $A2
COL EQU $A3
CHAR EQU $A4
CTR EQU $A5
STRA EQU $A6

* External calls

WAITRAND EXT ;Generate random seed while waiting
WAITKEY EXT ;Wait for keypress
TXTSPL EXT ;Show text splash screen
TITLSCRN EXT
SETHGR EXT ;Set HGR mode
CLRHGR EXT ;Clear HGR screen
DRWC EXT ;Draw single character
DRWS EXT ;Draw string
ROLL_D6 EXT ;Roll a D6
TOHEXS EXT ;Convert byte to ASCII hex
DRWTIL EXT ;Draw a tile on the screen

* Initialize/Clear Screen
 JSR INIT

* display the text splash screen
 JSR TXTSPL

* Generate a random seed
* from the keypress wait time
 JSR WAITRAND

* Back to HGR
 JSR TITLSCRN
 
 JSR WAITKEY

* Draw a message on the screen
 LDA #<MYSTR
 STA STRA
 LDA #>MYSTR
 STA STRA+1
 LDA #$00
 STA COL
 LDA #$00
 STA ROW
 JSR DRWS
 JSR WAITKEY

* Generate a random number
* and print it
 JSR PRINTD6
 JSR WAITKEY

* Draw the test alien

 LDA #$14
 STA $B0
 LDA #$00
 STA $B1

:MAINLOOP
 JSR CLRHGR
 LDA $B0
 LDY $B1
 LDX #$02 ;Tile 2
 JSR DRWTIL
 INC $B1
 LDA $B1
 CMP #$27
 BMI :MAINLOOP
 LDA #$00
 STA $B1
 JMP :MAINLOOP

 JSR WAITKEY
 
 STA COL80 ;Back to 80 columns
 LDA TXTMOD ;Back to text mode
 RTS ;for quitting to merlin



QUIT JSR MLI
 DFB $65
 DA QUITPARM
 BCS ERROR
 BRK $00

QUITPARM DFB 4
 DFB 0
 DA $0000
 DFB 0
 DA $0000

ERROR BRK $00


********************************

INIT
* Clear decimal
 CLD

* Switch to Hi-Res Graphics
* and clear the screen
 JSR CLRHGR
 JSR SETHGR
 RTS

PRINTD6
 JSR ROLL_D6
 JSR TOHEXS
 PHA
 STX CHAR
 JSR DRWC
 INC COL
 PLA
 STA CHAR
 JSR DRWC
 INC COL
 RTS

MYSTR ASC 'Hello, World!',0