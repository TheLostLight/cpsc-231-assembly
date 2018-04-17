.syntax unified

.equ INPUT_DIR,		1 
.equ OUTPUT_DIR,	0
.equ LEVEL_HIGH,	1 
.equ LEVEL_LOW,		0

.section .text
.thumb_func
.global main
main:	
	/* 
		Assuming the loader did its job, 
		at this point memory has been 
		initialized and the machine is 
		ready for execution 
	*/
	mov r8, #0

start:
	/* First blink LED1 */

	/* init pioc */
	bl pioc_init
	
	/* configure PC20 as output */
	mov r0, OUTPUT_DIR
	mov r1, 20
	bl pioc_dir_set

	/* set PC20 high (logic is inverted) */
	mov r0, LEVEL_LOW
	mov r1, 20
	bl pioc_level_set

	/* delay the program to admire the LED */
	mov r7, r8
	bl delay

	/* set PC20 low */
	mov r0, LEVEL_HIGH
	bl pioc_level_set

	/* Next blink LED2 */

	/* init pioa */
	bl pioa_init

	/* configure PA16 as output */
	mov r0, OUTPUT_DIR
	mov r1, 16
	bl pioa_dir_set

	/* set PA16 high */
	mov r0, LEVEL_LOW
	mov r1, 16
	bl pioa_level_set

	/* delay program again */
	mov r7, r8
	bl delay

	/* set PA16 low */
	mov r0, LEVEL_HIGH
	bl pioa_level_set

	/* And now blink LED3! */

	/* configure PC22 as output */
	mov r0, OUTPUT_DIR
	mov r1, 22
	bl pioc_dir_set

	/*set PC22 high */
	mov r0, LEVEL_LOW
	mov r1, 22
	bl pioc_level_set

	/* another delay */
	mov r7, r8
	bl delay

	/* set PC22 low */
	mov r0, LEVEL_HIGH
	bl pioc_level_set

	/* Logic preparations */
	mov r7, #0
	add r7, r7, r8

	/* Let's do it again, but faster. For fun. */
	mov r8, #0x78000
	cmp r7, #0
	beq start

	bl delay

	mov r9, #0	//loop counter

	/* Finish off with a little light show. Again, for fun. */
allthree:

	mov r0, LEVEL_LOW
	mov r1, 20
	bl pioc_level_set

	mov r1, 22
	bl pioc_level_set

	mov r1, 16
	bl pioa_level_set

	mov r7, r8
	bl delay

	mov r0, LEVEL_HIGH
	bl pioa_level_set

	mov r0, LEVEL_HIGH
	mov r1, 22
	bl pioc_level_set

	mov r0, LEVEL_HIGH
	mov r1, 20
	bl pioc_level_set

	mov r7, r8
	bl delay

	add r9, r9, #1
	cmp r9, #3
	bne allthree //this loop should blink all three LEDs three times before moving on

	mov r0, LEVEL_LOW
	mov r1, 16
	bl pioa_level_set

	mov r7, #0
	bl delay

	mov r1, 20
	bl pioc_level_set

	mov r1, 22
	bl pioc_level_set

	mov r0, LEVEL_HIGH
	mov r1, 16
	bl pioa_level_set

	mov r7, r8
	bl delay

	bl pioa_level_set

	mov r0, LEVEL_HIGH
	mov r1, 20
	bl pioc_level_set

	mov r0, LEVEL_HIGH
	mov r1, 22
	bl pioc_level_set

	mov r7, #0
	bl delay

	mov r0, LEVEL_HIGH
	mov r1, 16
	bl pioa_level_set // this section blinks LED2 by itself, then LED1 & 3, then back to LED2 before turning them all back off

	mov r7, r8
	bl delay

	mov r8, #0xB4000

	mov r1, 20
	bl pioc_level_set

	mov r7, r8
	bl delay

	mov r1, 16
	bl pioa_level_set

	mov r7, r8
	bl delay

	mov r0, LEVEL_HIGH
	mov r1, 20
	bl pioc_level_set

	mov r7, r8
	bl delay

	mov r1, 22
	bl pioc_level_set

	mov r7, r8
	bl delay

	mov r0, LEVEL_HIGH
	mov r1, 16
	bl pioa_level_set

	mov r7, #0
	bl delay

	bl pioa_level_set

	mov r7, r8
	bl delay

	mov r0, LEVEL_HIGH
	mov r1, 22
	bl pioc_level_set

	mov r7, r8
	bl delay

	mov r1, 20
	bl pioc_level_set

	mov r7, r8
	bl delay

	mov r0, LEVEL_HIGH
	mov r1, 16
	bl pioa_level_set

	mov r7, r8
	bl delay

	mov r0, LEVEL_HIGH
	mov r1, 20
	bl pioc_level_set	//this last huge section makes the LEDs do a wave sort of thing.

	/* This section up to b . is just garbage code in an attempt to fix the infinite loop 
		All it ended up doing was giving the program time for the last led to turn off
		before the program starts up again*/

	mov r0, #0

plsstop:
	
	add r0, r0, #1
	cmp r0, #0x10
	blt plsstop

	bl pio_disable

	mov r12, #0x12

	b .

/*
	A simple loop just to waste some time
*/
delay:

	add r7, #1
	cmp r7, #0xF0000
	blt delay

	bx lr
