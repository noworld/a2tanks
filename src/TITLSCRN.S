********************************
* Display Main Title Screen    *
*    Nick Waun                 *
*    04-25-2017                *
********************************

 REL
 DSK /EK/BIN/TITLSCRN.L

COL40 EQU $C00C
COL80 EQU $C00D

OPENF EXT
OFREF EXT
RDREF EXT
CFREF EXT
RDADR EXT
READF EXT
CLOSEF EXT
SETHGR EXT

TITLSCRN ENT

 JSR OPENF ;Open file

 LDA OFREF ;Store the ref num
 STA RDREF ;for reading and
 STA CFREF ;for closing the file

 LDA #$00
 STA RDADR

 LDA #$20
 STA RDADR+1
 JSR  READF ;Read the file

 LDA #$24
 STA RDADR+1
 JSR READF

 LDA #$28
 STA RDADR+1
 JSR READF

 LDA #$2C
 STA RDADR+1
 JSR READF

 LDA #$30
 STA RDADR+1
 JSR READF

 LDA #$34
 STA RDADR+1
 JSR READF

 LDA #$38
 STA RDADR+1
 JSR READF

 LDA #$3C
 STA RDADR+1
 JSR READF

DOCLOSE JSR CLOSEF ;Close file

 JSR SETHGR

 RTS
 