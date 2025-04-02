; simple exmaple of switches
processor 18F8722
radix dec

CONFIG OSC = HS
CONFIG WDT = OFF
CONFIG LVP = OFF
    
#include <xc.inc>
    
PSECT udata_acs
global switches
switches: ds 1
       
PSECT resetVector, class=CODE, reloc=2
resetVector:
 GOTO start

PSECT start, class=CODE, reloc=2
start:
    ;;;
    movlw 11101111B
    movwf TRISA ;; set transistor output RA4
    
    CLRF TRISF ;; set trisf output
    
    movlw 00111100B
    movwf TRISC ; RC2-5
    
    movlw 11110000B
    movwf TRISH
    
    movlw 15
    movwf ADCON1
       
    ;;;
    movf PORTC, W
    MOVWF switches
    rrncf switches, f
    rrncf switches, W
    andlw 00001111B
    
    movwf switches
    
        movlw 11110000B
    andwf PORTH, w

    
    iorwf switches, f
    
    ;;;
    movf switches, w
    movwf LATF
    
    ;;;
    movlw 00010000B
    movwf LATA ; TURN ON LED
    comf LATA ; TURN OFF LED
    
    
loop:
    bra start
    end


