********************************
* Math Module                  *
*    Nick Waun                 *
*    04-24-2017                *
********************************

 REL
 DSK /EK/BIN/MATH.L

QUOT EQU $AA
DIVS EQU $A9

*-------------------------------
* Dividend is in A
* Divisor in in Y
*-------------------------------
DIV8 ENT
 PHA
 LDA #$00
 STA QUOT
 STA QUOT+1
 PLA
 STY DIVS
 LDY #$00

NEXT   SEC
 INY
 SBC DIVS
 BPL NEXT

RESTOR CLC
 ADC DIVS
 STA QUOT+1         REMAINDER
 DEY
 TYA
 STA QUOT           QUOTIENT
 RTS
