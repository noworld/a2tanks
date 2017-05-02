********************************
* FONT.S                       *
* Simple Font Drawing          *
*    Nick Waun                 *
*    01-28-2017                *
*    02-21-2017                *
*                              *
* Zero Page Use:               *
*   $A0: Address of bitmap     *
*        of the current char   *
*        (16 Bit)              *
*   $A2: Cursor Column         *
*   $A3: Cursor Row            *
*   $A4: ASCII Character Code  *
*                              *
********************************

 REL
 DSK /EK/BIN/FONT.L

HGRROWS EXT

DOTS EQU $A0 ;Character scanline dots
ROW EQU $A2
COL EQU $A3
CHAR EQU $A4
STRA EQU $A6

* DRWS
* Draw String
* (Null Terminated)
* $A6: Address of String
* Other Params - See DRWC

DRWS ENT
 PHA  ;Save registers
 TXA
 PHA
 TYA
 PHA
 LDY #$00

:NEXTC   LDA (STRA),Y ;load character
 BEQ :STRDON ;Finish if 0x00
 STA CHAR ;Save to char
 JSR DRWC ;Draw it
 INC COL ;Increment column
 LDA COL
 CMP #$28
 BPL :STRDON
 INC  STRA  ;Next char address
 BCC  :NEXTC  ;Go to NEXTC if no carry
 LDA  STRA+1  ;else, add carry
 ADC  #$00  ;if needed
 STA  STRA+1
 JMP :NEXTC ;Continue with string

:STRDON PLA
 TAY
 PLA
 TAX
 PLA
 RTS


* DRWC
* Draw Character
* $A1: Character scanline dots
* $A2: Cursor Column (0-39)
* $A3: Cursor Row (0-23)
* $A4: ASCII Character Code

DRWC ENT
 LDA $A0 ;Save A0/A1 zero page
 PHA
 LDA $A1
 PHA

 JSR CALCADR ;Set up screen address
 JSR FIXCHAR ;Fix ascii char
 JSR GETCHAR ;Set up character data

 LDY #$05 ;Count down scanlines
 LDA (DOTS),Y ;Load font scanline
RFIV STA $3400 ;Save to HGR memory
 DEY
 LDA (DOTS),Y
RFOR STA $3000
 DEY
 LDA (DOTS),Y
RTHR STA $2C00
 DEY
 LDA (DOTS),Y
RTWO STA $2800
 DEY
 LDA (DOTS),Y
RONE STA $2400
 DEY
 LDA (DOTS),Y
RZER STA $2000

 PLA  ;Restore Zero page A0/A1
 STA $A1
 PLA
 STA $A0
 RTS

* Calculate the address datat
* for drawing the font in the
* requested position.

CALCADR PHA  ;Save accumulator to stack

 LDA ROW ;Load & Multiply Row by 2
 CLC  ;to index table HGRROWS
 ROL
 TAX

 LDA HGRROWS,X ;Get the screen address LSB
 CLC  ;Add column to LSB
 ADC COL ;Y was stored in zero page
 STA RZER+1 ;Store LSB to subroutine
 STA RONE+1 ;variables
 STA RTWO+1
 STA RTHR+1
 STA RFOR+1
 STA RFIV+1

 LDA HGRROWS+1,X ;Get the screen address MSB
 ADC #$00 ;Add in any cary from LSB
 STA RZER+2 ;Store to subroutine MSB
 CLC
 ADC #$04 ;Addvance the scanline
 STA RONE+2
 CLC
 ADC #$04 ;Advance the scanline
 STA RTWO+2
 CLC
 ADC #$04 ;Advance the scanline
 STA RTHR+2
 CLC
 ADC #$04 ;Advance the scanline
 STA RFOR+2
 CLC
 ADC #$04 ;Advance the scanline
 STA RFIV+2

 PLA  ;Restore accumulator
 RTS


* The Ascii value is stored in
* $A3, so convert
* it to a table lookup and store
* the result in $A0

GETCHAR LDA CHAR ;ASCII is stored in $A4
 SEC  ;Subtract $20 from value
 SBC #$20 ;since table starts at ascii space
 CLC  ;shift value left to index words
 ROL
 TAX  ;Use as index
 LDA CTAB,X ;Load character address
 STA DOTS ;Save LSB in character address
 LDA CTAB+1,X ;Load MSB
 STA DOTS+1 ;Save MSB
 RTS

* Fixes the ASCII value
* by limiting it to the character
* set supported by this font

FIXCHAR LDA CHAR ;Load character code
 CMP #$20
 BPL :GT20 ;Is char >= 0x20?
 LDA #$3F ;If not, send back a ?
 STA CHAR
 RTS
:GT20 CMP #$61 ;greater than 0x60?
 BPL :GT60 ;If not, further fixing req
 STA CHAR
 RTS  ;Do nothing if 20 <= char <=60
:GT60 CMP #$7C ;Are we past lowercase?
 BPL :GT7A ;If over 0x7B, handle differently
 SEC
 SBC #$20 ;Shift character set down 0x20
 STA CHAR
 RTS
:GT7A SEC
 SBC #$1A ;Only shift down 0x1A
 STA CHAR
 RTS

CTAB DA _SP ;Character Index Table
 DA _EX
 DA _DQ
 DA _PD
 DA _DL
 DA _PC
 DA _AM
 DA _SQ
 DA _OP
 DA _CP
 DA _AS
 DA _PL
 DA _CM
 DA _DH
 DA _FS
 DA _SL
 DA _N0
 DA _N1
 DA _N2
 DA _N3
 DA _N4
 DA _N5
 DA _N6
 DA _N7
 DA _N8
 DA _N9
 DA _CN
 DA _SC
 DA _LT
 DA _EQ
 DA _GT
 DA _QM
 DA _AT
 DA _A
 DA _B
 DA _C
 DA _D
 DA _E
 DA _F
 DA _G
 DA _H
 DA _I
 DA _J
 DA _K
 DA _L
 DA _M
 DA _N
 DA _O
 DA _P
 DA _Q
 DA _R
 DA _S
 DA _T
 DA _U
 DA _V
 DA _W
 DA _X
 DA _Y
 DA _Z
 DA _OB
 DA _BS
 DA _CB
 DA _CT
 DA _US
 DA _AC
 DA _OB
 DA _PP
 DA _CB
 DA _TD


_SP DB $00 ;SPACE=0x20
 DB $00
 DB $00
 DB $00
 DB $00
 DB $00

_EX DB $0C ;! - Exclamation
 DB $0C
 DB $0C
 DB $0C
 DB $00
 DB $0C

_DQ DB $66 ;" - Double Quote
 DB $66
 DB $66
 DB $00
 DB $00
 DB $00

_PD DB $36 ;# - Pound
 DB $4E
 DB $36
 DB $4E
 DB $36
 DB $00

_DL DB $18 ;$ - Dollar
 DB $3C
 DB $06
 DB $30
 DB $1E
 DB $18

_PC DB $00 ;% - Percent
 DB $66
 DB $30
 DB $18
 DB $0C
 DB $66

_AM DB $18 ;& - Ampersand
 DB $66
 DB $18
 DB $66
 DB $18
 DB $6C

_SQ DB $18 ;' - Single Quote
 DB $18
 DB $18
 DB $00
 DB $00
 DB $00

_OP DB $30 ;( - Open Paren
 DB $18
 DB $18
 DB $18
 DB $18
 DB $30

_CP DB $0C ;) - Closed Paren
 DB $18
 DB $18
 DB $18
 DB $18
 DB $0C

_AS DB $18 ;* - Asterisk
 DB $7E
 DB $18
 DB $66
 DB $00
 DB $00

_PL DB $00 ;+ - Plus
 DB $18
 DB $18
 DB $7E
 DB $18
 DB $18

_CM DB $00 ;, - Comma
 DB $00
 DB $00
 DB $1C
 DB $18
 DB $18

_DH DB $00 ;- - Dash
 DB $00
 DB $00
 DB $7C
 DB $00
 DB $00

_FS DB $00 ;. - Full Stop
 DB $00
 DB $00
 DB $00
 DB $0C
 DB $0C

_SL DB $00 ;/ - Slant
 DB $60
 DB $30
 DB $18
 DB $0C
 DB $06

_N0 DB $18 ;0
 DB $66
 DB $76
 DB $6E
 DB $66
 DB $18

_N1 DB $18 ;1
 DB $1E
 DB $18
 DB $18
 DB $18
 DB $7E

_N2 DB $1E ;2
 DB $30
 DB $30
 DB $1C
 DB $06
 DB $3E

_N3 DB $3E ;3
 DB $30
 DB $1E
 DB $30
 DB $30
 DB $1E

_N4 DB $66 ;4
 DB $66
 DB $66
 DB $7E
 DB $60
 DB $60

_N5 DB $3E ;5
 DB $06
 DB $1E
 DB $30
 DB $30
 DB $1E

_N6 DB $3C ;6 - Could be 0C?
 DB $06
 DB $3E
 DB $66
 DB $66
 DB $18

_N7 DB $7C ;7
 DB $60
 DB $30
 DB $18
 DB $18
 DB $18

_N8 DB $18 ;8
 DB $66
 DB $18
 DB $66
 DB $66
 DB $18

_N9 DB $18 ;9
 DB $66
 DB $66
 DB $7C
 DB $60
 DB $3C

_CN DB $00 ;: - Colon
 DB $0C
 DB $0C
 DB $00
 DB $0C
 DB $0C

_SC DB $00 ;; - Semicolon
 DB $0C
 DB $00
 DB $1C
 DB $18
 DB $18

_LT DB $18 ;< - Less Than
 DB $0C
 DB $06
 DB $06
 DB $0C
 DB $18

_GT DB $18 ;> - Greater Than
 DB $30
 DB $60
 DB $60
 DB $30
 DB $18

_EQ DB $00 ;= - Equals
 DB $00
 DB $7E
 DB $00
 DB $7E
 DB $00

_QM DB $18 ;? - Question Mark
 DB $66
 DB $60
 DB $18
 DB $00
 DB $18

_AT DB $18 ;@ - At - could use 7E
 DB $66
 DB $36
 DB $36
 DB $06
 DB $7C

_A DB $18 ;A
 DB $66
 DB $66
 DB $7E
 DB $66
 DB $66

_B DB $1E ;B
 DB $66
 DB $1E
 DB $66 ;could use 62?
 DB $66
 DB $3E

_C DB $7C ;C - could use 3E? 18?
 DB $06
 DB $06
 DB $06
 DB $06
 DB $7C ; 3E?

_D DB $1E ;D
 DB $66
 DB $66
 DB $66
 DB $66
 DB $1E

_E DB $3E ;E
 DB $06
 DB $3E
 DB $06
 DB $06
 DB $3E

_F DB $3E ;F
 DB $06
 DB $3E
 DB $06
 DB $06
 DB $06

_G DB $7C ;G
 DB $06
 DB $06
 DB $66
 DB $66
 DB $7C

_H DB $66 ;H
 DB $66
 DB $7E
 DB $66
 DB $66
 DB $66

_I DB $7E ;I
 DB $18
 DB $18
 DB $18
 DB $18
 DB $7E

_J DB $60 ;J
 DB $60
 DB $60
 DB $66
 DB $66
 DB $18

_K DB $66 ;K
 DB $36
 DB $1E
 DB $1E
 DB $36
 DB $66

_L DB $0C ;L
 DB $0C
 DB $0C
 DB $0C
 DB $0C
 DB $3C ; or 7C?

_M DB $66 ;M
 DB $66
 DB $6B
 DB $6B
 DB $6B
 DB $63

_N DB $66 ;N
 DB $6E
 DB $76
 DB $76
 DB $66
 DB $66

_O DB $18 ;O
 DB $66
 DB $66
 DB $66
 DB $66
 DB $18

_P DB $3E ;P
 DB $66
 DB $66
 DB $3E
 DB $06
 DB $06

_Q DB $18 ;Q
 DB $66
 DB $66
 DB $66
 DB $16
 DB $6C

_R DB $3E ;R
 DB $66
 DB $66
 DB $3E
 DB $36
 DB $66

_S DB $3C ;S
 DB $06
 DB $1C
 DB $30
 DB $30
 DB $1E

_T DB $7E ;T
 DB $18
 DB $18
 DB $18
 DB $18
 DB $18

_U DB $66 ;U
 DB $66
 DB $66
 DB $66
 DB $66
 DB $3C

_V DB $66 ;V
 DB $66
 DB $66
 DB $66
 DB $3C
 DB $18

_W DB $66 ;W
 DB $6B
 DB $6B
 DB $6B
 DB $6A
 DB $1E

_X DB $66 ;X
 DB $3C
 DB $18
 DB $18
 DB $3C
 DB $66

_Y DB $66 ;Y
 DB $66
 DB $3C
 DB $18
 DB $18
 DB $18

_Z DB $3E ;Z
 DB $30
 DB $18
 DB $0C
 DB $06
 DB $3E

_OB DB $78 ;[ - Open Bracket
 DB $18
 DB $18
 DB $18
 DB $18
 DB $78

_BS DB $00 ;Backslash
 DB $06
 DB $0C
 DB $18
 DB $30
 DB $60

_CB DB $1E ;] - Closed Bracket
 DB $18
 DB $18
 DB $18
 DB $18
 DB $1E

_CT DB $18 ;^ - Carat
 DB $18
 DB $66
 DB $66
 DB $00
 DB $00

_US DB $00 ;_ - Underscore
 DB $00
 DB $00
 DB $00
 DB $00
 DB $7E

_PP DB $18 ;Pipe
 DB $18
 DB $18
 DB $18
 DB $18
 DB $18

_TD DB $00 ;Tilde
 DB $00
 DB $66
 DB $18
 DB $00
 DB $00

_AC DB $18 ;Accent Mark
 DB $18
 DB $30
 DB $00
 DB $00
 DB $00
