    .data
prompt:      .asciiz "Enter an integer: "
fib_message: .asciiz "\nThe number is a Fibonacci number.\n"
not_fib_message: .asciiz "\nThe number is NOT a Fibonacci number.\n"

    .text
    .globl main

main:
    # Read the number from the user
    li $v0, 4                # syscall for print_string
    la $a0, prompt            # load address of prompt
    syscall

    li $v0, 5                # syscall for read_int
    syscall
    move $t0, $v0            # Store the user's input in $t0 (N)

    # Calculate 5 * N^2 + 4
    mul $t1, $t0, $t0        # t1 = N^2
    li $t2, 5                # Load constant 5
    mul $t1, $t1, $t2        # t1 = 5 * N^2
    addi $t3, $t1, 4         # t3 = 5 * N^2 + 4

    # Check if 5 * N^2 + 4 is a perfect square
    move $a0, $t3            # Pass 5N^2 + 4 to check_square function
    jal check_square
    move $s1, $v0            # Store the result (1 if perfect square, 0 if not) in s1

    # Calculate 5 * N^2 - 4
    addi $t3, $t1, -4        # t3 = 5 * N^2 - 4

    # Check if 5 * N^2 - 4 is a perfect square
    move $a0, $t3            # Pass 5N^2 - 4 to check_square function
    jal check_square
    move $s2, $v0            # Store the result (1 if perfect square, 0 if not) in s2

    # Check if either t4 or t5 is true (1)
    or $s0, $s1, $s2         # s0 = s1 | s2 (if either is 1, s0 becomes 1)

    # Branch based on whether s0 is 1 (Fibonacci) or 0 (not Fibonacci)
    beq $s0, $zero, not_fibonacci

fibonacci:
    # Print "The number is a Fibonacci number."
    li $v0, 4                # syscall for print_string
    la $a0, fib_message       # load address of fib_message
    syscall
    j end_program            # Jump to the end

not_fibonacci:
    # Print "The number is NOT a Fibonacci number."
    li $v0, 4                # syscall for print_string
    la $a0, not_fib_message   # load address of not_fib_message
    syscall

end_program:
    li $v0, 10               # syscall for exit
    syscall

# Function: check_square
# Checks if the number passed in $a0 is a perfect square
# Returns 1 in $v0 if it is a perfect square, 0 otherwise
check_square:
    li $t7, 0                # Initialize counter (k) to 0
    move $t8, $a0            # Copy the input number to $t8

square_loop:
    mul $t9, $t7, $t7        # t9 = k^2
    beq $t9, $t8, is_square  # If k^2 == number, it's a perfect square
    bgt $t9, $t8, not_square # If k^2 > number, it's not a perfect square
    addi $t7, $t7, 1         # Increment k
    j square_loop            # Repeat loop

is_square:
    li $v0, 1                # Return 1 (perfect square)
    jr $ra                   # Return to caller

not_square:
    li $v0, 0                # Return 0 (not a perfect square)
    jr $ra                   # Return to caller
