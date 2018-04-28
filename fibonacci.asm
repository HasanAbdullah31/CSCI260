# Hasan Abdullah
# fibonacci.asm - iterative and recursive versions of Fibonacci function using frame pointer.
        .data
               msg1: .asciiz "The "
               msg2: .asciiz "-th Fibonacci term using recursion is "
               msg3: .asciiz "-th Fibonacci term using iteration is "
               msg4: .asciiz ".\n"
        .text
        .globl main
# ---------------------------------------------------------------------------------------
        # int main(int argc, char** argv) {
        #   int num=10;
        #   int val=recur_fibonacci(num);
        #   printf("The %d-th Fibonacci term using recursion is %d.\n", num, val);
        #   val=iter_fibonacci(num);
        #   printf("The %d-th Fibonacci term using iteration is %d.\n", num, val);
        # }
        # num, val are in $s0, $s1 (respectively)
main:
        li $s0, 10              # int num=10;
        move $a0, $s0
        jal recur_fibonacci
        move $s1, $v0           # int val=recur_fibonacci(num);
        la $a0, msg1
        li $v0, 4
        syscall                 # print "The "
        move $a0, $s0
        li $v0, 1
        syscall                 # print num
        la $a0, msg2
        li $v0, 4
        syscall                 # print "-th Fibonacci term using recursion is "
        move $a0, $s1
        li $v0, 1
        syscall                 # print val
        la $a0, msg4
        li $v0, 4
        syscall                 # print ".\n"

        move $a0, $s0
        jal iter_fibonacci
        move $s1, $v0           # val=iter_fibonacci(num);
        la $a0, msg1
        li $v0, 4
        syscall                 # print "The "
        move $a0, $s0
        li $v0, 1
        syscall                 # print num
        la $a0, msg3
        li $v0, 4
        syscall                 # print "-th Fibonacci term using iteration is "
        move $a0, $s1
        li $v0, 1
        syscall                 # print val
        la $a0, msg4
        li $v0, 4
        syscall                 # print ".\n"
        li $v0, 10
        syscall                 # exit main
# ---------------------------------------------------------------------------------------
        # int recur_fibonacci(int n) {
        #   int term;
        #   if (n==0) term=0;
        #   else if (n==1) term=1;
        #   else term=recur_fibonacci(n-1)+recur_fibonacci(n-2);
        #   return term;
        # }
recur_fibonacci:
        # ALLOCATE STACK FRAME:
        # 1. arguments, 2. saved registers, 3. return address, 4. pad, 5. local data
        addi $sp, $sp, -4
        sw $fp, 0($sp)          # save frame pointer (will change on recursive calls)
        move $fp, $sp           # frame pointer points to top of stack frame
        addi $sp, $sp, -16
        sw $a0, -4($fp)         # input argument $a0=n, will be rewritten
        sw $t0, -8($fp)         # save register holding the cumulative sum
        sw $s0, -12($fp)
        sw $ra, -16($fp)        # save return address $ra across recursive calls
        move $t0, $a0           # load argument in temporary register, for n-1 and n-2
        base0:
        bne $t0, $zero, base1   # if n!=0, go to test for n==1
        li $v0, 0
        j end
        base1:
        li $t1, 1               # put 1 in $t1
        bne $t0, $t1, recursive # if n!=1, go to recursive case
        li $v0, 1
        j end
        recursive:
        addi $a0, $t0, -1       # calculate n-1
        jal recur_fibonacci     # call recur_fibonacci(n-1)
        move $s0, $v0           # store result in $s0
        addi $a0, $t0, -2       # calculate n-2
        jal recur_fibonacci     # call recur_fibonacci(n-2)
        add $s0, $s0, $v0       # store recur_fibonacci(n-1)+recur_fibonacci(n-2) in $s0
        move $v0, $s0           # store return value
        end:
        # restore values from stack, and then reset stack
        lw $ra, -16($fp)
        lw $s0, -12($fp)
        lw $t0, -8($fp)
        lw $a0, -4($fp)
        addi $sp, $sp, 16
        lw $fp, 0($sp)
        addi $sp, $sp, 4
        jr $ra                  # return term;
# ---------------------------------------------------------------------------------------
        # int iter_fibonacci(int n) {
        #   int x=0, u=0, v=1, temp;
        #   for (int i=0; i<n; ++i)
        #     temp=x, x+=v, u=v, v=temp;
        #   return x;
        # }
        # x, u, v, temp, i are in $s0, $s1, $s2, $s3, $t0 (respectively)
iter_fibonacci:
        addi $sp, $sp, -4
        sw $fp, 0($sp)          # save frame pointer
        move $fp, $sp           # frame pointer points to top of stack frame
        addi $sp, $sp, -16      # save $s0...$s3 to satisfy caller contract
        sw $s0, -4($fp)
        sw $s1, -8($fp)
        sw $s2, -12($fp)
        sw $s3, -16($fp)
        # int x=0, u=0, v=1, temp;
        li $s0, 0
        li $s1, 0
        li $s2, 1
        li $s3, 0
        li $t0, 0               # int i=0;
        loop:
        beq $t0, $a0, exit_loop # if i==n, exit the loop
        move $s3, $s0           # temp=x
        add $s0, $s0, $s2       # x+=v
        move $s1, $s2           # u=v
        move $s2, $s3           # v=temp
        addi $t0, $t0, 1        # ++i
        j loop
        exit_loop:
        move $v0, $s0           # x will be returned, so store it in $v0
        # restore values from stack, and then reset stack
        lw $s3, -16($fp)
        lw $s2, -12($fp)
        lw $s1, -8($fp)
        lw $s0, -4($fp)
        addi $sp, $sp, 16
        lw $fp, 0($sp)
        addi $sp, $sp, 4
        jr $ra                  # return x;
# ---------------------------------------------------------------------------------------
