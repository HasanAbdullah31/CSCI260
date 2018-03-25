# Hasan Abdullah
# my_funct.asm - assembly program implementing a function call.
        .text
        .globl main
# -----------------------------------------------------------------------------
        # int main () {
        #   int result=funct(3,1,4,1);
        # }
main:
        # Assign the actuals to argument registers, then call the function
        li   $a0, 3
        li   $a1, 1
        li   $a2, 4
        li   $a3, 1
        jal  funct      # Save Program Counter in $ra, then jump to funct
        move $s1, $v0   # Assign $v0 (return value of funct) to $s1 (result)

        # Exit main
        li   $v0, 10    # Code for exit
        syscall
# -----------------------------------------------------------------------------
        # int funct (int g, int h, int i, int j) {
        #   int f;
        #   f=(g+h)-(i+j);
        #   return f;
        # }
        # g, h, i, j are in $a0, $a1, $a2, $a3 (respectively)
        # f is in $s0 and return value is stored in $v0
        # Return address is stored in $ra (by jal instruction)
funct:
        li   $s0, 0          # int f; // initialized to 0
        add  $t0, $a0, $a1   # rval (g+h)
        add  $t1, $a2, $a3   # rval (i+j)
        sub  $s0, $t0, $t1   # f=(g+h)-(i+j);

        # return f;
        move $v0, $s0        # Set return value to f
        jr   $ra             # Jump to Program Counter in $ra
# -----------------------------------------------------------------------------
