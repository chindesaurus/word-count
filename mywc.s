############################################################
## mywc.s
##
## Reads characters from stdin until EOF, and prints to stdout
## a count of how many lines, words, and characters were read,
## a "word" being any sequence of characters delimited by at 
## least one whitespace character.
## 
## @author chindesaurus
## @version 1.00
##
############################################################

	.section ".rodata"
	
	## enumerated constants
	.equ TRUE, 1
	.equ FALSE, 0

	## global parameters (in ASCII)
	.equ Enter, 10
	.equ EOF, -1
	.equ Space1, 32     ## space character
	.equ Space2, 9      ## horizontal tab
	.equ Space3, 10     ## NL line feed, new line
	.equ Space4, 11     ## vertical tab
	.equ Space5, 12     ## NP form feed, new page
	.equ Space6, 13     ## carriage return

	## parameter offsets
	.equ iLineCount, -4
	.equ iWordCount, -8
	.equ iCharCount, -12
	.equ iChar, -16
	.equ iInWord, -20


	## printf format string
cResult:
	.asciz "%7d%8d%8d\n"

	## ------------------------------------
	## int main(void)
	## ------------------------------------

	.globl main
	.type main,@function

main:

	pushl %ebp
	movl %esp, %ebp

	## int iLineCount = 0
	## int iWordCount = 0
	## int iCharCount = 0
	## int iChar
	## int iInWord = FALSE

	subl $20, %esp
	movl $0, iLineCount(%ebp)
	movl $0, iWordCount(%ebp)
	movl $0, iCharCount(%ebp)
	movl $FALSE, iInWord(%ebp)

	jmp loop

loop:
	## while ((iChar = getchar())!= EOF)
	call getchar
	movl %eax, iChar(%ebp)
	cmpl $EOF, iChar(%ebp)
	je loopend
	
	## iCharCount++
	addl $1, iCharCount(%ebp)
	
	## if(isspace(iChar))
	cmpl $Space1, iChar(%ebp)
	je isspaceIf
	
	cmpl $Space2, iChar(%ebp)
	je isspaceIf
	
	cmpl $Space3, iChar(%ebp)
	je isspaceIf
	
	cmpl $Space4, iChar(%ebp)
	je isspaceIf
	
	cmpl $Space5, iChar(%ebp)
	je isspaceIf
	
	cmpl $Space6, iChar(%ebp)
	je isspaceIf
	
	jmp isspaceIfEnd
	
isspaceIf:
	
	## if (iInWord)
	cmpl $TRUE, iInWord(%ebp)
	je inWordIf1
	jmp inWordIf1End
	
inWordIf1:

	## iWordCount++
	addl $1, iWordCount(%ebp)
	
	## iInWord = FALSE
	movl $FALSE, iInWord(%ebp)
	jmp inWordIf1End

isspaceIfEnd:
isspaceElse:

	## if (! iInWord)
	cmpl $TRUE, iInWord(%ebp)
	jne inWordIf2
	jmp inWordIf2End

inWordIf2:

	## iInWord = TRUE
	movl $TRUE, iInWord(%ebp)

inWordIf2End: 

isspaceElseEnd:
inWordIf1End:

	## if (iChar == '\n')
	cmpl $Enter, iChar(%ebp)
	je iCharIf
	jmp iCharIfEnd

iCharIf:
	## iLineCount++
	addl $1, iLineCount(%ebp)

iCharIfEnd:
	jmp loop

loopend:
	## if (iInWord)	
	cmpl $TRUE, iInWord(%ebp)
	je inWordIf3
	jmp inWordIf3End

inWordIf3:
	## iWordCount++
	addl $1, iWordCount(%ebp)

inWordIf3End:
	## printf("%7d%9d%8d\n", iLineCount,
	## iWordCount, iCharCount);
	pushl iCharCount(%ebp)
	pushl iWordCount(%ebp)
	pushl iLineCount(%ebp)
	pushl $cResult
	call printf

	## return 0;
	movl $0, %eax
	movl %ebp, %esp
	popl %ebp
	ret
