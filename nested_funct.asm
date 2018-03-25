# Hasan Abdullah
# nested_funct.asm - assembly program implementing a nested function (one with 6 arguments) program
#                    that calculates, compares, and prints three triangle areas.
        .data
              b1: .word 10
              b2: .word 12
              b3: .word 41
              h1: .word 8
              h2: .word 7
              h3: .word 2
              msg_1g2: .asciiz "Area1 greater than Area2.\n"
              msg_2g1: .asciiz "Area2 greater than Area1.\n"
              msg_1g3: .asciiz "Area1 greater than Area3.\n"
              msg_3g1: .asciiz "Area3 greater than Area1.\n"
              msg_2g3: .asciiz "Area2 greater than Area3.\n"
              msg_3g2: .asciiz "Area3 greater than Area2.\n"
              debug1: .asciiz "Area1="
              debug2: .asciiz "Area2="
              debug3: .asciiz "Area3="
              newline: .asciiz "\n"
        .text
        .globl main
# -----------------------------------------------------------------------------
        # int main(int argc, char** argv) {
        #   int base1, base2, base3, height1, height2, height3;
        #   base1=10; base2=12; base3=41; height1=8; height2=7; height3=2;
        #   Compare(base1, height1, base2, height2, base3, height3);
        #   return 0;
        # }
main:
        # Assign the first 4 variables to argument registers $a0...$a3
        # and the last 2 variables to registers $s0, $s1
        lw $a0, b1
        lw $a1, h1
        lw $a2, b2
        lw $a3, h2
        lw $s0, b3
        lw $s1, h3
        # Store $s0, $s1 on the stack so Compare() can use its own $s0, $s1
        subi $sp, $sp, 8
        sw $s0, 0($sp)
        sw $s1, 4($sp)
        jal Compare
        # Restore $s0, $s1 and reset the stack
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        addi $sp, $sp, 8
        # Code for exit
        li $v0, 10
        syscall
# -----------------------------------------------------------------------------
        # void Compare(int b1, int h1, int b2, int h2, int b3, int h3) {
        #   int A1=Area(b1, h1); printf("Area1=%d\n", A1);
        #   int A2=Area(b2, h2); printf("Area2=%d\n", A2);
        #   int A3=Area(b3, h3); printf("Area3=%d\n", A3);
        #   /* Checkpoint 1 */
        #   if (A1>=A2) printf("Area1 is greater than Area2.\n");
        #   else        printf("Area2 is greater than Area1.\n");
        #   /* Checkpoint 2 */
        #   if (A1>=A3) printf("Area1 is greater than Area3.\n");
        #   else        printf("Area3 is greater than Area1.\n");
        #   /* Checkpoint 3 */
        #   if (A2>=A3) printf("Area2 is greater than Area3.\n");
        #   else        printf("Area3 is greater than Area2.\n");
        # }
        # b1, h1, b2, h2, b3, h3 are in $a0, $a1, $a2, $a3, 0($sp), 4($sp)
        # Local variables A1, A2, A3 are in $s0, $s1, $s2
Compare:
        # Store b3, h3 in $t0, $t1 (respectively)
        lw $t0, 0($sp)
        lw $t1, 4($sp)
        # Store current $ra on stack before doing any jal
        subi $sp, $sp, 4
        sw $ra, 0($sp)

        # int A1=Area(b1, h1); printf("Area1=%d\n", A1);
        # b1 is in $a0, h1 is in $a1, and A1 will be in $s0
        jal Area
        move $s0, $v0
        la $a0, debug1
        li $v0, 4
        syscall
        move $a0, $s0
        li $v0, 1
        syscall
        la $a0, newline
        li $v0, 4
        syscall
        # int A2=Area(b2, h2); printf("Area2=%d\n", A2);
        # b2 is in $a2, h2 is in $a3, and A2 will be in $s1
        move $a0, $a2
        move $a1, $a3
        jal Area
        move $s1, $v0
        la $a0, debug2
        li $v0, 4
        syscall
        move $a0, $s1
        li $v0, 1
        syscall
        la $a0, newline
        li $v0, 4
        syscall
        # int A3=Area(b3, h3); printf("Area3=%d\n", A3);
        # b3 is in $t0, h3 is in $t1, and A3 will be in $s2
        move $a0, $t0
        move $a1, $t1
        jal Area
        move $s2, $v0
        la $a0, debug3
        li $v0, 4
        syscall
        move $a0, $s2
        li $v0, 1
        syscall
        la $a0, newline
        li $v0, 4
        syscall

        CHECKPOINT_1:
        # if (A1<A2) goto A1_LESS_A2;
        sub $t0, $s0, $s1
        bltz $t0, A1_LESS_A2
        # assert: A1>=A2
        li $v0, 4
        la $a0, msg_1g2
        syscall
        j CHECKPOINT_2
        # assert: A1<A2
        A1_LESS_A2:
        li $v0, 4
        la $a0, msg_2g1
        syscall

        CHECKPOINT_2:
        # if (A1<A3) goto A1_LESS_A3;
        sub $t0, $s0, $s2
        bltz $t0, A1_LESS_A3
        # assert: A1>=A3
        li $v0, 4
        la $a0, msg_1g3
        syscall
        j CHECKPOINT_3
        # assert: A1<A3
        A1_LESS_A3:
        li $v0, 4
        la $a0, msg_3g1
        syscall

        CHECKPOINT_3:
        # if (A2<A3) goto A2_LESS_A3;
        sub $t0, $s1, $s2
        bltz $t0, A2_LESS_A3
        # assert: A2>=A3
        li $v0, 4
        la $a0, msg_2g3
        syscall
        j RETURN
        # assert: A2<A3
        A2_LESS_A3:
        li $v0, 4
        la $a0, msg_3g2
        syscall

        RETURN:
        # Restore $ra, reset the stack, and return to caller
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra
# -----------------------------------------------------------------------------
        # int Area(int b, int h) {
        #   int A=(b*h)/2;
        #   return A;
        # }
        # b, h are in $a0, $a1
        # Local variable A is in $s0
Area:
        subi $sp, $sp, 8
        sw $ra, 0($sp)
        sw $s0, 4($sp)

        mul $s0, $a0, $a1   # A=(b*h)
        srl $v0, $s0, 1     # $v0 now holds A/2 (srl once equivalent to /2)

        lw $ra, 0($sp)
        lw $s0, 4($sp)
        addi $sp, $sp, 8
        jr $ra
# -----------------------------------------------------------------------------
