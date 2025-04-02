Digital Input Assessment Mock 2025
THIS IS A MOCK (It will not be marked). Do not submit your code to Blackboard for the mock; just for the actual assessment. 
Read the associated document ("Digital Input Assessment Information") very carefully.  You cannot use the handbook or previous code, only the Assessment Information sheet.
You have 40 minutes to complete the following task. You must start with an empty MPLAB-X, so select File->Clear All Projects.
You should not have compilation warnings in this assignment. Use the boiler plate code to ensure there are no Configure warnings. Press "clean and compile" and look for any blue sentences (if there are any, click on them and fix them).
The Task—You choose your level of difficulty. To marks, the I/O board display must be working.
Basic (55%):
When pressing PB1, show the letter ‘U’ on the left-hand 7-segment display.
Medium (65%):
When pressing PB1, show the letter ‘U’ on the left-hand 7-segment display.
Simultaneously, treat the right-most four switches as a 4-bit unsigned number.  Extend this number to be an 8-bit unsigned number, and show the result on the LEDs LD1-8.
If that number is equal to 9, turn off the LEDs LD1-8
Advanced(100%):
When pressing PB1, show the letter ‘U’ on the left-hand 7-segment display.
Simultaneously, treat the right-most four switches as a 4-bit unsigned number.  Extend this number to be an 8-bit unsigned number, and show the result on the LEDs LD1-8.
Simultaneously, treat the left-most four switches as a 4-bit unsigned number.
Simultaneously display either 'L', 'R' or 'E' on the right-hand 7-segment display to show which of the two switch values are greater. If the left switches are greater, display 'L', if the right switches are greater, display 'R'. Display 'E' if they are equal in value.

    
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
    MOVWF Y
    
    ; show Y on LEDs
    MOVF Y, W
    MOVWF LATF
    
    MOVLW 00010000B
    MOVWF LATA ; SET RA4 HIGH, turn ON Q3 Transisto, ACTIVE HIGH
    
    MOVLW 00000000B
    MOVWF LATA ; SET RA4 LOW, turn OFF Q3 Transisto, ACTIVE HIGH
    
   ;;; LOGIC 3: X
   MOVF PORTH, W
   ANDLW 11110000B
   movwf X
   SWAPf X, F
   
   MOVF X, W
   SUBWF Y
   BZ L_DISPLAY_RIGHT_E
   BC L_DISPLAY_RIGHT_R
   CALL L_DISPLAY_RIGHT_L
    
    
    
    BRA L_MainProgram
    
    
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