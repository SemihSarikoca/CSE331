    .data
prompt:     .asciiz "Enter an integer: "
palindrome: .asciiz "\nThe number is a palindrome.\n"
not_palindrome: .asciiz "\nThe number is not a palindrome.\n"

    .text
    .globl main

main:
    # Print prompt message
    la $a0, prompt           # load address of prompt
    li $v0, 4               # syscall for print_string
    syscall

    # Read user input (an integer)
    li $v0, 5               # syscall for read_int
    syscall
    move $t0, $v0           # store input in $t0 (original number)

    # Initialize reverse and temp
    move $t1, $t0           # copy original number to $t1 for reversing
    li $t2, 0               # $t2 will hold the reversed number
    li $t3, 0               # $t3 is used to extract digits

reverse_loop:
    beq $t1, $zero, compare # if $t1 == 0, go to compare
    divu $t1, $t1, 10       # $t3 = $t1 / 10 (integer division)
    mfhi $t4               # $t4 = $t1 % 10 (remainder)
    mul $t2, $t2, 10        # $t2 = $t2 * 10
    add $t2, $t2, $t4       # $t2 = $t2 + remainder (reversing)
    j reverse_loop          # repeat the loop

compare:
    # Compare original number ($t0) with reversed number ($t2)
    beq $t0, $t2, is_palindrome
    j is_not_palindrome

is_palindrome:
    # Print palindrome message
    li $v0, 4               # syscall for print_string
    la $a0, palindrome       # load address of palindrome message
    syscall
    j end_program            # jump to end

is_not_palindrome:
    # Print not palindrome message
    li $v0, 4               # syscall for print_string
    la $a0, not_palindrome   # load address of not_palindrome message
    syscall

end_program:
    li $v0, 10              # syscall for exit
    syscall
