processor 18F8722
radix dec
CONFIG OSC = HS
CONFIG WDT = OFF
CONFIG LVP = OFF
    
#include <xc.inc>
       
PSECT resetVector, class=CODE, reloc=2
resetVector:
 GOTO start

PSECT start, class=CODE, reloc=2
start:
    ;;; Configure TRIState TRISF, TRSH, TRISA as output
    MOVLW 00000000B
    movWF TRISF ; Set all TRISF pins as output
    
    movlw 11111100B
    movwf TRISH ; Set RH0, RH1 pin as output
    
    movlw 11101111B
    movwf TRISA ; Set RA4 pin as output
    
    ;;; Set 7 Segment Left Dsiplay as 'A'
    movlw 00010100B ; binary representation of 'B' display
    movwf LATF
    
    movlw 11111101B
    movwf LATH ; turn ON Transistor Q2
    
    setf LATH ; turn OFF Transistor Q2
    
    ;;; Set 7 Segment Right Dsiplay as 'B'
    movlw 00000111B ; binary representation of 'B' display
    movwf LATF

    movlw 1111110B
    movwf LATH ; turn ON Transistor Q1
    
    setf LATH ; turn OFF Transistor Q1
    
    ;;; Set decimal number '240' as bit pattern into LEDs
    movlw 11110000B ; binary representation of '240'
    movwf LATF 
    
    movlw 00010000B
    movwf LATA ; turn ON Transistor Q3
    
    clrf LATA ; turn OFF Transistor Q3   
    
loop:
    BRA start
    end
