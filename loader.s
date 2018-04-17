.syntax unified

.section .vectors 	
.skip 4	
.word loader

.section .text
.thumb_func
loader:	
	/* loader should go here */
	/* ...					 */

	b main
