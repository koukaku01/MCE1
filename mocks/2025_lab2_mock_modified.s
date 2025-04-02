// 2025 lab2 input lab modified verison for twos complement
   
processor 18F8722
radix dec
    
// Hardware Configuration of our PIC18F8722
CONFIG OSC=HS, FCMEN=OFF, IESO=OFF
CONFIG BORV=3
CONFIG WDT=OFF, WDTPS=1
CONFIG MODE=MC, ADDRBW=ADDR20BIT, DATABW=DATA16BIT, WAIT=OFF
CONFIG CCP2MX=PORTC, LPT1OSC=OFF, MCLRE=ON
CONFIG STVREN=ON, LVP=OFF, XINST=OFF
CONFIG CP0=OFF, CP1=OFF, CP2=OFF, CP3=OFF
CONFIG CPB=OFF, CPD=OFF
CONFIG WRT0=OFF, WRT0=OFF, WRT0=OFF, WRT0=OFF
CONFIG WRTC=OFF
CONFIG EBTR0=OFF, EBTR1=OFF, EBTR2=OFF, EBTR3=OFF
CONFIG EBTRB=ON

#include <xc.inc>
    
    
PSECT udata_acs
global X, Y
X: ds 1
Y: ds 1
    
// Code
PSECT ResetVector, class=CODE, reloc=2
ResetVector:
 GOTO L_MainProgram

 PSECT Start, class=CODE, reloc=2
L_MainProgram:
    ;;; Configiure GPIOs
    MOVLW 15
    MOVWF ADCON1 ; set all ADCON1 pins to be DIGITAL INPUT
    
    SETF LATH
    
    SETF TRISJ ; set RJ5 as INPUT for PB1
    
    CLRF TRISF ; set RF pins as OUTPUT for LEDs and Displays
    
    MOVLW 00111100B ; set RC2-5 as INPUT
    MOVWF TRISC
    
    MOVLW 11111100B
    MOVWF TRISH ; set RH4-7 as INPUT, set RH0-1 as OUTPUT
    
    MOVLW 11101111B
    MOVWF TRISA ; set RA4 as OUTPUT
    
     ;
    
    ;;; Logic 1: PB1 to dispaly 'U' on left display
    BTFSS PORTJ, 5 ; test RJ5 value
    CALL L_DISPLAY_LEFT_U
        
    ;;; Logic 2: 
    MOVF PORTC, W
    MOVWF Y
    RRNCF Y, F
    RRNCF Y, F
    MOVF Y, W
    ANDLW 00001111B
    BTFSC WREG, 3 ; twos comeplemtn implementation by
    ADDLW 11110000B ; fillign with 1111 at the front
    MOVWF Y
    
    ; show Y on LEDs
    MOVF Y, W
    MOVWF LATF
    
    MOVLW 00010000B
    MOVWF LATA ; SET RA4 HIGH, turn ON Q3 Transisto, ACTIVE HIGH
    
    MOVLW 00000000B
    MOVWF LATA ; SET RA4 LOW, turn OFF Q3 Transisto, ACTIVE HIGH
    
   ;;; LOGIC 3: X in twos complement extended to 8 bits
   MOVF PORTH, W
   ANDLW 11110000B
   BTFSC WREG, 7 ; twos comeplemtn implementation by
   ADDLW 00001111B ; fillign with 1111 at the end, then swap
   movwf X
   SWAPf X, F
      
   MOVF X, W
   SUBWF Y ; Y-X
   BZ L_DISPLAY_RIGHT_E ; Y == X
   BNN L_COMPARISON
   CALL L_DISPLAY_RIGHT_L    
    
    BRA L_MainProgram

L_COMPARISON:
    BNOV L_DISPLAY_RIGHT_R
    
L_DISPLAY_LEFT_U:
    MOVLW 10000101B ; BINARY PATTERN FOR 'U'
    MOVWF LATF
    
    MOVLW 11111101B
    MOVWF LATH ; SET RH1 LOW, turn ON Q2 Transisto, ACTIVE LOW
    
    MOVLW 11111111B
    MOVWF LATH ; SET RH1 HIGH, turn OFF Q2 Transisto, ACTIVE LOW
    RETURN

L_DISPLAY_RIGHT_E:
    MOVLW 00001110B
    MOVWF LATF
    
    MOVLW 11111110B
    MOVWF LATH ; SET RH0 LOW, turn ON Q1 Transisto, ACTIVE LOW
    
    MOVLW 11111111B
    MOVWF LATH ; SET RH0 HIGH, turn OFF Q1 Transisto, ACTIVE LOW
    BRA L_MainProgram
    
L_DISPLAY_RIGHT_L:
    MOVLW 10001111B
    MOVWF LATF
    
    MOVLW 11111110B
    MOVWF LATH ; SET RH0 LOW, turn ON Q1 Transisto, ACTIVE LOW
    
    MOVLW 11111111B
    MOVWF LATH ; SET RH0 HIGH, turn OFF Q1 Transisto, ACTIVE LOW
    RETURN

L_DISPLAY_RIGHT_R:
    MOVLW 01011111B
    MOVWF LATF
    
    MOVLW 11111110B
    MOVWF LATH ; SET RH0 LOW, turn ON Q1 Transisto, ACTIVE LOW
    
    MOVLW 11111111B
    MOVWF LATH ; SET RH0 HIGH, turn OFF Q1 Transisto, ACTIVE LOW
    RETURN
    
    end 
