********************************
* Hi-Res Graphics Module       *
*    Nick Waun                 *
* Created                      *
*    01-21-2017                *
* Modified                     * 
*    05-04-2017                *
********************************

 REL
 DSK /TKS/BIN/HGR.L
 
HGRROWS EXT
HGRLINS EXT

VIDROWS EQU $80
VIDLINS EQU $82


SETHGR ENT
 LDA $C052 ;mixed mode off
 LDA $C057 ;hi-res mode on
 LDA $C050 ;text mode off
 
 * Set up display addressing
 LDA #<HGRROWS
 STA VIDROWS
 LDA #>HGRROWS
 STA VIDROWS+1
 
  * Set up display addressing 
 LDA #<HGRLINS
 STA VIDLINS
 LDA #>HGRLINS
 STA VIDLINS+1
 
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
