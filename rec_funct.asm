# Hasan Abdullah
# rec_funct.asm - assembly program implementing a recursive function call to calculate x^n (by doing x * x^(n-1)).
        .text
        .globl main
# -----------------------------------------------------------------------------
        # int main () { int result=pow(3,5); printf("%d", result); }
main:
        # Assign the actuals to argument registers, then call pow()
        li $a0, 3
        li $a1, 5
        jal pow         # Save Program Counter in $ra, then jump to pow
        move $s0, $v0   # Assign $v0 (return value of pow) to $s0 (result)
        move $a0, $s0   # Set $a0 to $s0 (result) to print it with syscall
        li $v0, 1       # Code for printing integer in $a0
        syscall
        li $v0, 10      # Code for exit
        syscall
# -----------------------------------------------------------------------------
        # int pow (int a, int b) {
        #   if (b==0) return 1;
        #   else if (b==1) return a;
        #   else return a*pow(a,b-1);
        # }
        # a, b are in $a0, $a1 (respectively)
        # Return value is stored in $v0
        # Return address is stored in $ra (by jal instruction)
pow:
        # Push the stack with the current return address
        subi $sp, $sp, 4
        sw $ra, 0($sp)

        bne $a1, $zero, elif   # if (b!=0) go to else if (b==1)
        addi $v0, $zero, 1     # Case 1: if (b==0) return 1;
        j RETURN

        elif:
        bne $a1, 1, else       # if (b!=1) go to else
        add $v0, $zero, $a0    # Case 2: else if (b==1) return a;
        j RETURN

        else:
        subi $a1, $a1, 1       # b=b-1
        jal pow                # Make a recursive call
        lw $ra, 0($sp)         # Set return address to previous stack frame
        addi $sp, $sp, 4       # Pop that return address off the stack
        mul $v0, $v0, $a0      # Case 3: else return a*pow(a,b-1);
        jr $ra                 # Go to previous stack frame in recursion

        RETURN:
        # Pop the previously stored $ra off the stack, then return to caller
        addi $sp, $sp, 4
        jr $ra
# -----------------------------------------------------------------------------
