********************************
* Disk I/O Module              *
*    Nick Waun                 *
*    04-25-2017                *
********************************

 REL
 DSK /TKS/BIN/DISKIO.L
 
MLI EQU $BF00
COL40 EQU $C00C
COL80 EQU $C00D

CLRTXT EXT

QUIT JSR MLI
 DB $65
 DA QUITPARM
 BCS ERROR
 BRK $00

QUITPARM DB 4
 DB 0
 DA $0000
 DB 0
 DA $0000

ERROR STA $AE
 BRK $00

********************************

WAITKEY LDA $C000
 BPL WAITKEY
 STA $C010
 RTS

*-------------------------------
* Sets display to HGR mode
*-------------------------------
SETHGR LDA $C052
 LDA $C057
 LDA $C050
 RTS

*-------------------------------
* Sets display to text mode
*-------------------------------
SETTXT LDA $C051
 RTS

*-------------------------------
* Open File
*-------------------------------
OPENF ENT
 JSR MLI
 DB #$C8
 DA OFPARM
 STA $AA
 BCS ERROR
 RTS

OFPARM DB 3
 DA OFPATH
 DA $9000
OFREF ENT
 DB 0

OFPATH STR "/EK/RES/TITLE.BIN"

*-------------------------------
* Read File
*-------------------------------
READF ENT
 JSR MLI
 DB #$CA
 DA RFPARM
 STA $AB
 BCS ERROR
 RTS

RFPARM DB 4
RDREF ENT
 DB 0
RDADR ENT
 DA $2000
BUFLEN ENT
 DA $0400
RDLEN DA $0000

*-------------------------------
* Close File
*-------------------------------
CLOSEF ENT
 JSR MLI
 DB #$CC
 DA CFPARM
 STA $AC
 BCS ERROR
 RTS

CFPARM DB 1
CFREF ENT
 DB 0

*-------------------------------
* Clear the screen
*-------------------------------
CLRSCR LDA #$00 ;page 0
 CLC
 ADC #$20
 STA :LOOP+2
 ADC #$10
 STA :SMOD+2

 LDA #$80 ;clear color
 LDX #$10
 LDY #0

:LOOP STA $2000,Y
:SMOD STA $3000,Y
 INY
 BNE :LOOP

 INC :LOOP+2
 INC :SMOD+2

 DEX
 BNE :LOOP
 RTS

