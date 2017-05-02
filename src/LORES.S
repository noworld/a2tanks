********************************
* Low Res and Text Module      *
*    Nick Waun                 *
*    04-25-2017                *
********************************

 REL
 DSK /TKS/BIN/LORES.L

STRA EQU $A6
CLEAR EQU $A0

LORESTAB EXT

*-------------------------------
* Sets display to text mode
*-------------------------------
SETTXT ENT
 LDA $C051
 RTS

*-------------------------------
* Clear the screen as lores
*-------------------------------
CLRLO ENT
 LDA #$00 ;page 0
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

*-------------------------------
* Clear the screen as text
*-------------------------------
CLRTXT ENT
 CLC
 ADC #$04
 STA :LOOP+2

 LDA #CLEAR
 LDX #$04 ;clear 4 pages
 LDY #$00

:LOOP STA $0000,Y
 DEY
 BNE :LOOP

 INC :LOOP+2
 DEX
 BNE :LOOP
 RTS

*-------------------------------
* PRTSTR
* Prints a string into 40-Column
* text display memory
*     IN:
*        - Screen row is in A
*          (0-39)
*        - Screen column is in X
*          (0-24)
*        - String address is
*          in A6-A7
*     OUT:
*        - A holds the original row
*        - X holds the original col
*        - Y is undefined
*        - A6-A7 are undefined
*-------------------------------
PRTSTR ENT
 PHA ;Save row twice
 PHA
 LDA STRA
 STA :TXTLP+1
 LDA STRA+1
 STA :TXTLP+2
 TXA
 STA :COL+1
 PLA ;Restore row
 ASL ;Mult by 2 for indexing
 TAY
 LDA LORESTAB,Y
 CLC
:COL ADC #$00 ;Add in column
 STA STRA
 LDA LORESTAB+1,Y
 ADC #$00 ;Add in carry
 STA STRA+1
 LDY #$00
:TXTLP LDA $0000,Y
 BEQ :TXTDN ;End on 00
 STA (STRA),Y
 INY
 JMP :TXTLP
:TXTDN PLA ;Restore Row
 RTS
