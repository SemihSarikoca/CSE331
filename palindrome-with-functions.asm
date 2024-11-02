    .data
prompt:     .asciiz "Enter an integer: "
palindrome: .asciiz "\nThe number is a palindrome.\n"
not_palindrome: .asciiz "\nThe number is not a palindrome.\n"

    .text
    .globl main

# Main function
main:
    # Call read_number
    jal read_number          # Jump to read_number function
    move $t0, $v0            # Store the returned number in $t0 (original number)

    # Call reverse_number
    move $a0, $t0            # Pass the original number in $a0
    jal reverse_number        # Jump to reverse_number function
    move $t1, $v0            # Store the reversed number in $t1

    # Call is_palindrome
    move $a0, $t0            # Pass the original number in $a0
    move $a1, $t1            # Pass the reversed number in $a1
    jal is_palindrome         # Jump to is_palindrome function

    # Check result in $v0
    beq $v0, 1, palindrome_case
    j not_palindrome_case

palindrome_case:
    # Call print_message with the palindrome message
    la $a0, palindrome        # Load address of palindrome message
    jal print_message
    j end_program

not_palindrome_case:
    # Call print_message with the not palindrome message
    la $a0, not_palindrome    # Load address of not palindrome message
    jal print_message

end_program:
    li $v0, 10               # syscall for exit
    syscall

# Function: read_number
# Reads an integer from the user and returns it in $v0
read_number:
    li $v0, 4                # syscall for print_string
    la $a0, prompt            # load address of prompt
    syscall

    li $v0, 5                # syscall for read_int
    syscall
    jr $ra                   # return to caller

# Function: reverse_number
# Reverses the number passed in $a0 and returns the reversed number in $v0
reverse_number:
    move $t1, $a0            # Copy input number to $t1
    li $t2, 0                # Initialize reversed number to 0

reverse_loop:
    beq $t1, $zero, reverse_done # If number is 0, exit loop
    divu $t3, $t1, 10         # $t3 = $t1 / 10
    mfhi $t4                  # $t4 = remainder (last digit)
    mul $t2, $t2, 10          # Multiply reversed number by 10
    add $t2, $t2, $t4         # Add the last digit to reversed number
    move $t1, $t3             # Update $t1 = $t1 / 10
    j reverse_loop

reverse_done:
    move $v0, $t2             # Return the reversed number in $v0
    jr $ra                    # Return to caller

# Function: is_palindrome
# Compares the original number ($a0) and reversed number ($a1)
# Returns 1 in $v0 if they are the same, 0 otherwise
is_palindrome:
    beq $a0, $a1, palindrome_true  # If original == reversed, it's a palindrome
    li $v0, 0                    # Return 0 (not a palindrome)
    jr $ra                        # Return to caller

palindrome_true:
    li $v0, 1                    # Return 1 (it's a palindrome)
    jr $ra                        # Return to caller

# Function: print_message
# Prints a string passed in $a0
print_message:
    li $v0, 4                    # syscall for print_string
    syscall
    jr $ra                        # Return to caller
