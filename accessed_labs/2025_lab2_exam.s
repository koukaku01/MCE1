//While PB2 is pressed down, show the number ‘3’ on the right-hand 7-segment display.
//Simultaneously, treat the leftmost four switches as a 4-bit unsigned number.

//    Extend this number to be an 8-bit unsigned number and show the result on the LEDs LD1-8.

// Simultaneously, treat the right-most four switches as a 4-bit twos complement number.

//    Store this number in the data memory location 0x333.
//    If that number equals -1, then show the number ‘0’ on the left-hand seven‑segment display

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
CONFIG EBTRB=OFF
    
    
#include <xc.inc>
    
// Defines
PSECT udata_acs
global x
x: ds 1

 
y equ 0x333 
 
 
 
// Code
PSECT ResetVector, class=CODE, reloc=2
ResetVector:
 GOTO L_MainProgram

PSECT Start, class=CODE, reloc=2
L_MainProgram:
    ;;; Configure GPIOs
    MOVLW 15
    MOVWF ADCON1 ; set all ADCON1 pins to be DIGITAL INPUT
    
    MOVLW 00000001B
    MOVWF TRISB ; set RB0 as INPUT
    
    MOVLW 11111100B
    MOVWF TRISH ; set RH0 as OUTPUT. RH4-7 as INPUT
    
    MOVLW 00111100B
    MOVWF TRISC ; set RC2-5 as INPUT
    
    CLRF TRISF ; set All RF pins as OUTPUT
    
    MOVLW 11101111B
    MOVWF TRISA ; set RA4 as OUTPUT
    
    
L_LOOP:   
    
    ;;; lOGIC 1: PB2 pressed to show '3' on right segment display
    BTFSS PORTB, 0
    CALL L_RIGHT_3
    
    ;;; LOGIC 2: Upper nibble of switch as 4bit unsigned number, extend to 8bit
		    ; shown on LEDs1-8
    MOVF PORTH, W
    ANDLW 11110000B
    MOVWF x
    SWAPF x, F
    MOVF x, W
    MOVWF LATF
    
    MOVLW 00010000B
    MOVWF LATA ; set RA4 HIGH to turn ON Transisitor Q3, ACTIVE HIGH
    
    MOVLW 00000000B
    MOVWF LATA ; set RA4 LOW to turn OFF Transisitor Q3, ACTIVE HIGH
		
    
    ;;; LOGIC 3: Lower nibble of switch as 4bit twos complement
		    ; store in 0x333 
    MOVF PORTC, W
    MOVLB 3 ; set bank 3
    MOVWF y, b
    RRNCF y, f, b
    RRNCF y, f, b
    MOVF y, W, b
    ANDLW 00001111B
    MOVWF y, b
    MOVF y, W, b
    BTFSC WREG, 3
    ADDLW 11110000B
    MOVWF y, b
    
    ///// one way of doing
    //MOVWF y, b
    //movlw -1
    //CPFSEQ y, b
    //BRA L_LOOP
    //CALL L_LEFT_0
    
    //// alternative 2
    //sublw -1
    //bz L_LEFT_0  
    
    //// alternative 3
    addlw 1
    bz L_LEFT_0

    BRA L_LOOP

    
    
L_RIGHT_3:
    MOVLW 01100100B ; binary pattern for '3'
    MOVWF LATF
    
    MOVLW 11111110B
    MOVWF LATH ; set RH0 LOW to turn ON Transisitor Q1, ACTIVE LOW
    
    MOVLW 11111111B
    MOVWF LATH ; set RH0 HIGH to turn OFF Transisitor Q1, ACTIVE LOW

    RETURN
    
    
L_LEFT_0:
    MOVLW 10000100B
    MOVWF LATF
    
    MOVLW 11111101B
    MOVWF LATH ; set RH1 LOW to turn ON Transisitor Q2, ACTIVE LOW
    
    MOVLW 11111111B
    MOVWF LATH ; set RH1 HIGH to turn OFF Transisitor Q2, ACTIVE LOW
    
    
    BRA L_LOOP

    end