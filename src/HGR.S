********************************
* Hi-Res Graphics Module       *
*    Nick Waun                 *
*    01-21-2017                *
********************************

 REL
 DSK /TKS/BIN/HGR.L

SETHGR ENT
 LDA $C052 ;mixed mode off
 LDA $C057 ;hi-res mode on
 LDA $C050 ;text mode off
 RTS

CLRHGR ENT
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
