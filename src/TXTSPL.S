********************************
* Text Splash Screen           *
*    Nick Waun                 *
*    04-25-2017                *
********************************

 REL
 DSK /EK/BIN/TXTSPL.L

COL40 EQU $C00C
COL80 EQU $C00D
STRA EQU $A6

PRTSTR EXT
SETTXT EXT
CLRTXT EXT

*-------------------------------
* Draw the text splash screen
*-------------------------------
TXTSPLASH ENT
 STA COL40
 LDA #$00 ;page 0
 JSR CLRTXT ;Clear text

 LDA #<MSG1_1
 STA STRA
 LDA #>MSG1_1
 STA STRA+1
 LDA #$04
 LDX #$04
 JSR PRTSTR

 LDA #<MSG1_2
 STA STRA
 LDA #>MSG1_2
 STA STRA+1
 LDA #$06
 JSR PRTSTR

 LDA #<MSG1_3
 STA STRA
 LDA #>MSG1_3
 STA STRA+1
 LDA #$08
 JSR PRTSTR

 LDA #<MSG1_4
 STA STRA
 LDA #>MSG1_4
 STA STRA+1
 LDA #$0A
 JSR PRTSTR

 LDA #<MSG1_5
 STA STRA
 LDA #>MSG1_5
 STA STRA+1
 LDA #$0C
 JSR PRTSTR

 LDA #<MSG1_6
 STA STRA
 LDA #>MSG1_6
 STA STRA+1
 LDA #$11
 JSR PRTSTR

 LDA #<MSG1_7
 STA STRA
 LDA #>MSG1_7
 STA STRA+1
 LDA #$16
 JSR PRTSTR

 LDA #<MSG1_8
 STA STRA
 LDA #>MSG1_8
 STA STRA+1
 LDA #$17
 JSR PRTSTR

 JSR SETTXT
 RTS

*-------------------------------
* Splash screen text
*-------------------------------
MSG1_1 ASC "------------------------------",00
MSG1_2 ASC "     E M B E R                ",00
MSG1_3 ASC "           K N I G H T        ",00
MSG1_4 ASC "------------------------------",00
MSG1_5 ASC "       Dungeon Fantasy        ",00
MSG1_6 ASC "            v 1.0             ",00
MSG1_7 ASC "    (C) 2017 Nicholas Waun    ",00
MSG1_8 ASC "     All rights reserved.     ",00
