********************************
* Utilty Routine Module        *
*    Nick Waun                 *
*    04-24-2017                *
********************************

 REL
 DSK /EK/BIN/UTIL.L

*-------------------------------
* Loops until a key is pressed
*-------------------------------
WAITKEY ENT
 LDA $C000
 BPL WAITKEY
 STA $C010
 RTS

*-------------------------------
* Converts lower 4 bits of
* accumulator to ASCII
* hexidecmal 0-F
* X asd Y registers are preserved
*-------------------------------
TOHEXL ENT
 AND #$0F
 CLC
 ADC #$30
 CMP #$3A
 BMI :DONE
 CLC
 ADC #$07
:DONE RTS

*-------------------------------
* Converts accumulator to ASCII
* hexidecmal 0-F. MSN is in A,
* and LSN is in X
*-------------------------------
TOHEX ENT
 PHA
 AND #$0F
 JSR TOHEXL
 TAX
 PLA
 LSR
 LSR
 LSR
 LSR
 JSR TOHEXL
 RTS

*-------------------------------
* Converts accumulator to ASCII
* hexidecmal 0-F. MSN is in X,
* and LSN is in A
* (A and X are swapped compared
* to above)
*-------------------------------
TOHEXS ENT
 PHA
 LSR
 LSR
 LSR
 LSR
 JSR TOHEXL
 TAX
 PLA
 AND #$0F
 JSR TOHEXL
 RTS
