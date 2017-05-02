********************************
* Text Splash Screen           *
*    Nick Waun                 *
*    04-25-2017                *
********************************

 REL
 DSK /TKS/BIN/TXTSPL.L

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

 LDA #<MSG1_01
 STA STRA
 LDA #>MSG1_01
 STA STRA+1
 LDA #$04
 LDX #$02
 JSR PRTSTR

 LDA #<MSG1_02
 STA STRA
 LDA #>MSG1_02
 STA STRA+1
 LDA #$05
 JSR PRTSTR

 LDA #<MSG1_03
 STA STRA
 LDA #>MSG1_03
 STA STRA+1
 LDA #$06
 JSR PRTSTR

 LDA #<MSG1_04
 STA STRA
 LDA #>MSG1_04
 STA STRA+1
 LDA #$07
 JSR PRTSTR

 LDA #<MSG1_05
 STA STRA
 LDA #>MSG1_05
 STA STRA+1
 LDA #$08
 JSR PRTSTR

 LDA #<MSG1_06
 STA STRA
 LDA #>MSG1_06
 STA STRA+1
 LDA #$09
 JSR PRTSTR

 LDA #<MSG1_07
 STA STRA
 LDA #>MSG1_07
 STA STRA+1
 LDA #$0A
 JSR PRTSTR

 LDA #<MSG1_08
 STA STRA
 LDA #>MSG1_08
 STA STRA+1
 LDA #$0B
 JSR PRTSTR
 
  LDA #<MSG1_09
  STA STRA
  LDA #>MSG1_09
  STA STRA+1
  LDA #$0C
 JSR PRTSTR
 
  LDA #<MSG1_10
  STA STRA
  LDA #>MSG1_10
  STA STRA+1
  LDX #$04
  LDA #$11
 JSR PRTSTR
 
  LDA #<MSG1_11
  STA STRA
  LDA #>MSG1_11
  STA STRA+1
  LDA #$13
 JSR PRTSTR
 
  LDA #<MSG1_12
  STA STRA
  LDA #>MSG1_12
  STA STRA+1
  LDA #$15
 JSR PRTSTR
 
  LDA #<MSG1_13
  STA STRA
  LDA #>MSG1_13
  STA STRA+1
  LDA #$17
 JSR PRTSTR

 JSR SETTXT
 RTS

*-------------------------------
* Splash screen text
*-------------------------------
MSG1_01 ASC "----------------------------------",00
MSG1_02 ASC " _____ ___   _   _  _   __ _____  ",00
MSG1_03 ASC "|_   _/ _ \ | \ | || | / //  ___| ",00
MSG1_04 ASC "  | |/ /_\ \|  \| || |/ / \ `--.  ",00
MSG1_05 ASC "  | ||  _  || . ` ||    \  `--. \ ",00
MSG1_06 ASC "  | || | | || |\  || |\  \/\__/ / ",00
MSG1_07 ASC "  \_/\_| |_/\_| \_/\_| \_/\____/  ",00
MSG1_08 ASC "                                  ",00
MSG1_09 ASC "----------------------------------",00
MSG1_10 ASC "        APPLE 2 TANKS         ",00
MSG1_11 ASC "            v 1.0             ",00
MSG1_12 ASC "    (C) 2017 Nicholas Waun    ",00
MSG1_13 ASC "     All rights reserved.     ",00
