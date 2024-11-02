    .data
prompt:      .asciiz "Enter an integer: "
prime_message: .asciiz "\nThe number is a prime number.\n"
not_prime_message: .asciiz "\nThe number is NOT a prime number.\n"

    .text
    .globl main

main:
    # Print the prompt for user input
    li $v0, 4                # syscall for print_string
    la $a0, prompt            # load address of prompt
    syscall

    # Read the input integer from the user
    li $v0, 5                # syscall for read_int
    syscall
    move $t0, $v0            # Store input number in $t0

    # Check if the number is less than 2 (not prime)
    li $t1, 2                # Load the value 2
    blt $t0, $t1, not_prime  # If input < 2, it's not prime

    # Initialize divisor to 2
    li $t2, 2                # t2 = divisor = 2

prime_check_loop:
    mul $t3, $t2, $t2        # Calculate t2^2
    bgt $t3, $t0, prime      # If divisor^2 > input, the number is prime

    # Check if input % divisor == 0 (not prime)
    div $t0, $t2             # Divide input by divisor
    mfhi $t4                 # Get the remainder
    beq $t4, $zero, not_prime  # If remainder == 0, it's not prime

    # Increment divisor
    addi $t2, $t2, 1         # divisor++

    # Repeat the loop
    j prime_check_loop

prime:
    # Print "The number is a prime number."
    li $v0, 4                # syscall for print_string
    la $a0, prime_message     # load address of prime message
    syscall
    j end_program            # Exit the program

not_prime:
    # Print "The number is NOT a prime number."
    li $v0, 4                # syscall for print_string
    la $a0, not_prime_message # load address of not prime message
    syscall

end_program:
    li $v0, 10               # syscall for exit
    syscall
