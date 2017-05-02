********************************
* Random Number Module         *
*    Nick Waun                 *
*    04-24-2017                *
* RANDSEED :=                  *
*  (5 * RANDSEED + 23) mod 256 *
********************************

 REL
 DSK /EK/BIN/RAND.L

RANDSEED EQU $A8
RANDW EQU $B8
DIE6 EQU $15

DIV8 EXT

*-------------------------------
* Wait for a keypress, and
* generate a random seed using
* the wait time
*-------------------------------
WAITRAND ENT
 INC RANDSEED
 LDA $C000
 BPL WAITRAND
 STA $C010
 RTS

*-------------------------------
* Pseudorandom sequence 0
*-------------------------------
RAND0 ENT
 LDA RANDSEED
 ASL
 ASL
 CLC
 ADC RANDSEED
 CLC
 ADC #23
 STA RANDSEED
 RTS

*-------------------------------
* Pseudorandom sequence 1
*-------------------------------
RAND1 ENT
 LDA RANDSEED
 LSR
 BCC _DONE
 EOR #RANDW
_DONE STA RANDSEED
 RTS

*-------------------------------
* Returns a D6 roll in A
*-------------------------------
ROLL_D6 ENT
 JSR RAND1
 AND #$7C
 LDY #DIE6
 JSR DIV8
 TAY
 INY
 TYA
 RTS
