// WIP: INCOMPLETE CODE WITH BUGS AND LOGIC ERRORS

// TASKS
//    Start with the right-most LED on, but nothing should happen until the right-most toggle switch SW1[0] is set to 1 (the upper part of the switch is pressed).
//    Once the right-most toggle switch is on, then continue as below.
//    Move the “on” LED to the left, waiting for 320 ms, and repeat the movement to the left. The LEDs should not be turned off between movements.
//    Once the left-most LED (LED8) is lit, turn on all the LEDs on and stop there.
//    At any point, if the right-most toggle switch SW1[0] is set to zero, the program will reset (LED variable=0), ready to go again.

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
var_1ms_delay equ 0x10
var_10ms_delay equ 0x11
var_320ms_delay equ 0x12
var_LED equ 0x20

// Code
PSECT ResetVector, class=CODE, reloc=2
ResetVector:
    GOTO L_MainProgram

PSECT Start, class=CODE, reloc=2
L_MainProgram:
    ;;; Configure GPIOs
    movlw 15
    movwf ADCON1, a ; set ADCON1 pins as DIGITAL INPUT
    bcf TRISA, 4, a ; RA4 as OUTPUT
    BSF TRISC, 2, a ; set RC2 as INPUT
    clrf TRISF, a ; set RF pins as OUTPUT

    L_MAIN:
    BCF LATA, 4, a ; set RA4 as LOW, transisitor ACTIVE HIGH
    CLRF LATF  ; Turn off all LEDs 

    
    ;;; LED1 initially ON
    movlw 00000001B
    movwf LATF, a ; LED1, RF0 as logic level HIGH
    BSF LATA, 4, a ; TURN ON transisitor Q3, ACTIVE HIGH    
    
    BTFSC PORTC, 2, a ; BRANCH to cycle LEDs Loop if RC2 is 1
    BRA L_LED
    
    BRA L_MAIN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; LOOP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
L_LED:
    BTFSS PORTC, 2, a ; RESET
    BRA L_RESET
    
    BCF LATA, 4, a
    RLNCF LATF, f, a
    BSF LATA, 4, a
    call SUB_320ms_delay
    
    BTFSC LATF, 7, a
    BZ LED_all_ON
    
    BRA L_LED

LED_all_ON:
    NOP
    BTFSS PORTC, 2, a
    BRA L_RESET
    
    movlw 11111111B
    BCF LATA, 4, a
    movwf LATF, a
    BSF LATA, 4, a
    
    BRA LED_all_ON
    
L_RESET:
    RESET
    
    BRA L_MAIN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SUB_1ms_delay: ; 1ms /400 ns = 2500 instruction cycle, c
    movlw 249 ; c
    movwf var_1ms_delay, a ; c
    nop; total 5c
    nop
    nop
    nop
    nop

L_1ms:
    nop ; total 7c
    nop
    nop
    nop
    nop
    nop
    nop
    decf var_1ms_delay, f, a ; c
    bnz L_1ms ; 2c ; c

    RETURN  ; call + return 4c
    
SUB_10ms_delay: ; 10ms /400 ns = 25000 instruction cycle, c
    ; appr 10 SUB_1ms_delay  ; total 25004 c ; error acceptable
   
    call SUB_1ms_delay ; 2500c
    call SUB_1ms_delay
    call SUB_1ms_delay
    call SUB_1ms_delay
    call SUB_1ms_delay
    call SUB_1ms_delay
    call SUB_1ms_delay
    call SUB_1ms_delay
    call SUB_1ms_delay
    call SUB_1ms_delay
    
    RETURN  ; call + return 4c

SUB_320ms_delay: ; 100ms /400 ns = 800 000 instruction cycle, c
    ; appr 32 10ms delay ; 800101 c
    movlw 32 ;c 
    movwf var_320ms_delay, a ;c 
    
L_320ms:
    call SUB_10ms_delay ; 25000c
    decf var_320ms_delay, f, a ; c
    bnz L_320ms ; 2c ; c

    RETURN  ; call + return 4c
     
end
