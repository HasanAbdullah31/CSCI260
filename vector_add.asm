# Hasan Abdullah
# vector_add.asm - adds two vectors and prints the resulting vector on the console.
        .data
               vector1: .word 3, 1, 4, 1, 5, 9, 2, 6, 5, 3
               vector2: .word 0, 1, 2, 3, 4, 0, 1, 2, 3, 4
               vector3: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
               size:    .word 10
               space:   .asciiz " "
               newline: .asciiz "\n"
        .text
        .globl main
# -----------------------------------------------------------------------------
        # int main(int argc, char** argv) {
        #   const int size=10;
        #   int vec1[size]={3,1,4,1,5,9,2,6,5,3};
        #   int vec2[size]={0,1,2,3,4,0,1,2,3,4};
        #   int vec3[size];   // assume all elements are initialized to 0
        #   print(vec1,size); print(vec2,size);
        #   addVectors(vec1,vec2,vec3,size); print(vec3,size);
        # }
main:
        # assign the variables to argument registers and call the functions
        la $a0, vector1
        lw $a1, size
        jal print

        la $a0, vector2
        jal print

        la $a0, vector1
        la $a1, vector2
        la $a2, vector3
        lw $a3, size
        jal addVectors

        la $a0, vector3
        lw $a1, size
        jal print

        li $v0, 10
        syscall
# -----------------------------------------------------------------------------
        # void print(int* vec, int size) {
        #   for (int* ptr=&vec[0]; ptr<&vec[size]; ++ptr) printf("%d ", *ptr);
        #   printf("\n");
        # }
        # vec, size are in $a0, $a1; local variable ptr is in $t1
print:
        move $t0, $a0        # store $a0 in $t0 because loop will change it
        move $t1, $a0        # int* ptr=&vec[0];
        sll $t2, $a1, 2      # calculate size*4
        add $t2, $t1, $t2    # $t2 holds ptr+size*4 (i.e. &vec[size])

        loop:
        beq $t1, $t2, exit   # if ptr==&vec[size], break from loop
        lw $a0, 0($t1)       # $a0 holds *ptr (i.e. vec[i], i=0...size-1)
        li $v0, 1
        syscall              # print *ptr
        la $a0, space
        li $v0, 4
        syscall              # print a space
        addi $t1, $t1, 4     # ++ptr (increment absolute address by 4)
        j loop

        exit:
        la $a0, newline
        li $v0, 4
        syscall              # print a newline
        move $a0, $t0        # restore $a0 to its original value (in $t0)
        jr $ra
# -----------------------------------------------------------------------------
        # void addVectors(int* vec1, int* vec2, int* vec3, int size) {
        #   int* p1=&vec1[0]; int* p2=&vec2[0]; int* p3=&vec3[0];
        #   while (p3<&vec3[size]) *p3=*p1+*p2, ++p1, ++p2, ++p3;
        # }
        # vec1, vec2, vec3, size are in $a0, $a1, $a2, $a3
        # local variables p1, p2, p3 are in $t1, $t2, $t3
addVectors:
        move $t1, $a0        # int* p1=&vec1[0];
        move $t2, $a1        # int* p2=&vec2[0];
        move $t3, $a2        # int* p3=&vec3[0];
        sll $t0, $a3, 2      # calculate size*4
        add $t0, $t3, $t0    # $t0 holds p3+size*4 (i.e. &vec3[size])

        while:
        beq $t3, $t0, return # if p3==&vec3[size], break from loop
        lw $t4, 0($t1)       # $t4 holds *p1
        lw $t5, 0($t2)       # $t5 holds *p2
        add $t4, $t4, $t5    # $t4 holds *p1+*p2
        sw $t4, 0($t3)       # *p3=*p1+*p2
        addi $t1, $t1, 4     # ++p1 (increment absolute address by 4)
        addi $t2, $t2, 4     # ++p2
        addi $t3, $t3, 4     # ++p3
        j while

        return: jr $ra
# -----------------------------------------------------------------------------
