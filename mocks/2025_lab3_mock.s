/*
THIS IS A MOCK (It will not be marked). Do not submit your code to Blackboard for the mock; just for the actual assessment. 
Read the associated document ("Digital Subs/Delays Assessment Information") very carefully.  You cannot use the handbook or previous code, only the Assessment Information sheet.
You have 40 minutes to complete the following task. You must start with an empty MPLAB-X, so select File->Clear All Projects.
You should not have compilation warnings in this assignment. Use the boiler-plate code to ensure there are no Configure warnings. Press "clean and compile" and look for any blue sentences (if there are any, click on them and fix them).
Hints  (No hints are provided in the assessed question)

    Banked Memory: For the memory address 0x400, use the MOVLB command and the bank selection flag.  Remember to set the bank flag in both the MOVWF and DECF commands. 
    Stopwatch You can find the MPLAB-X debugging stopwatch in the menu windows->debugging->stopwatch.  It only is available in simulator mode. Remember to set your instruction frequency for the stopwatch correctly.  You can do this by setting the project to simulator mode (right-click on the project, then Project Properties->Categories: Conf: Hardware Tool).  Once it is in simulator mode, select the Project Properties->Categories: Conf: Simulator Option Categories: Oscillator Options.  Your clock frequency is 10 MHz; therefore, the PIC's instruction frequency is 2.5 MHz.


The Task—You choose your level of difficulty. To obtain marks, the I/O board display must be working.
Basic:

    Create a subroutine that contains 4 NOPs, loops 71 times, and uses DECF to decrease the loop counter.  In simulator mode, use a stopwatch to determine how long the subroutine takes to execute.  Name the subroutine with that time to the nearest microsecond, e.g. _sub_350us.
    Store the variable used in the subroutine in memory address 0x400. 

Medium:

    Use the code you created in the Basic task.
    The 7-segment displays should be off.
    Create a second subroutine that has a delay of 40 ms. This new subroutine should call the subroutine from the Basic task.  Use the stopwatch to ensure the timing is within 5%.
    Turn the right-most LED on for 40 ms, then off for 40 ms and repeat.

Advanced:

    Nothing happens until PB2 is pressed.
    Once PB2 is pressed, start the following sequence.
    Use the code you created in the Medium task to turn the right-most LED on for 40 ms, then off for 40 ms and repeat.
    However, if the PB1 is pressed, then instead, pause for 400 ms LED on and 400 ms off.
*/

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
var_40ms_delay equ 0x11
    
// Code
PSECT ResetVector, class=CODE, reloc=2
ResetVector:
    GOTO L_start
    
PSECT Start, class=CODE, reloc=2
L_start:
;;; Configure GPIOs
    movlw 15
    movwf ADCON1
    
    bsf TRISB, 0 ; RB0 as INPUT ; PB2
    bsf TRISJ, 5 ; RJ5 as INPUT ; PB1
    
    CLRF TRISF ; set RF pins as OUTPUT
    clrf LATF
    
    bcf TRISA, 4 ; set RA4 as OUTPUT
L_MainProgram:
;;; LOGIC
    BTFSS PORTB, 0, a
    BRA L_LED1_40ms
    BRA L_MainProgram
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
    
;;; SUBROUTINES
SUB_1ms_delay:; 1ms /400 ns = 2500 instruciton cycle, c
    movlw 249 ; c
    movwf var_1ms_delay, a ; c
    
L_1ms:
    nop; c
    nop;
    nop;
    nop;
    nop;
    nop;
    nop;
    decf var_1ms_delay, f, a ;c 
    bnz L_1ms ;2c ;c
    return ; call + return ; 4c
    
;;;;;;;
    
SUB_40ms_delay: ; 40ms /400 ns = 100 000 = 40 * 2500 instruciton cycle, c
    ; approximately 40 SUB_1ms_delay ; 100 083c
    movlw 40
    movwf var_40ms_delay, a
    
L_40ms:
    call SUB_1ms_delay; 2500c
    decf var_40ms_delay, f, a 
    bnz L_40ms ;2c ;c
    return ; call + return ; 4c


    
    
L_LED1_40ms:
    movlw 00000001B
    movwf LATF, a
    
    bsf LATA, 4, a ; turn on TRNASISITOR
    CALL SUB_40ms_delay
    
    BTFSS PORTJ, 5
    BRA SUB_LED1_400ms
    
    
    bcf LATA, 4 ; turn off TRANSISITOR
    call SUB_40ms_delay
    
    BTFSS PORTJ, 5
    BRA SUB_LED1_400ms
        
    BRA L_LED1_40ms
    
SUB_LED1_400ms:
    bcf LATA, 4 ; turn off TRANSISITOR

    movlw 00000001B
    movwf LATF, a 
    
    bsf LATA, 4 ; turn on TRNASISITOR
    
    call SUB_40ms_delay
    BTFSS PORTB, 0, a
    BRA L_LED1_40ms
    
    call SUB_40ms_delay
    BTFSS PORTB, 0, a
    BRA L_LED1_40ms
    
    call SUB_40ms_delay
    BTFSS PORTB, 0, a
    BRA L_LED1_40ms
    
    call SUB_40ms_delay
    BTFSS PORTB, 0, a
    BRA L_LED1_40ms
    
    call SUB_40ms_delay
    BTFSS PORTB, 0, a
    BRA L_LED1_40ms
    
    call SUB_40ms_delay
    BTFSS PORTB, 0, a
    BRA L_LED1_40ms
    
    call SUB_40ms_delay
    BTFSS PORTB, 0, a
    BRA L_LED1_40ms
    
    call SUB_40ms_delay
    BTFSS PORTB, 0, a
    BRA L_LED1_40ms
    
    call SUB_40ms_delay
    BTFSS PORTB, 0, a
    BRA L_LED1_40ms
    
    call SUB_40ms_delay
    BTFSS PORTB, 0, a
    BRA L_LED1_40ms
    
    bcf LATA, 4 ; turn off TRANSISITOR
    
    call SUB_40ms_delay
    BTFSS PORTB, 0, a
    BRA L_LED1_40ms
   
    call SUB_40ms_delay
    BTFSS PORTB, 0, a
    BRA L_LED1_40ms
    
    call SUB_40ms_delay
    BTFSS PORTB, 0, a
    BRA L_LED1_40ms
    
    call SUB_40ms_delay
    BTFSS PORTB, 0, a
    BRA L_LED1_40ms
    
    call SUB_40ms_delay
    BTFSS PORTB, 0, a
    BRA L_LED1_40ms
    
    call SUB_40ms_delay
    BTFSS PORTB, 0, a
    BRA L_LED1_40ms
    
    call SUB_40ms_delay
    BTFSS PORTB, 0, a
    BRA L_LED1_40ms
    
    call SUB_40ms_delay
    BTFSS PORTB, 0, a
    BRA L_LED1_40ms
    
    call SUB_40ms_delay
    BTFSS PORTB, 0, a
    BRA L_LED1_40ms
    
    call SUB_40ms_delay
    BTFSS PORTB, 0, a
    BRA L_LED1_40ms

    bra  SUB_LED1_400ms
    
end    