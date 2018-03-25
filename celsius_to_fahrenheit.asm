# Hasan Abdullah
# celsius_to_fahrenheit.asm - converts temperature in Celsius to temperature in Fahrenheit.
        .data
               c_temp:   .float 12.0
               degree_C: .asciiz "°C = "
               degree_F: .asciiz "°F\n"
        .text
        .globl main
# -----------------------------------------------------------------------------
        # int main(int argc, char** argv) {
        #   float c_temp=12.0f;
        #   float f_temp=celsius_to_fahrenheit(c_temp);
        #   printf("%.1f°C = %.1f°F\n",c_temp,f_temp);
        # }
        # c_temp, f_temp are in $f12, $f4 (respectively)
main:
        # $f12...$f15 are used to store float arguments
        # $f0...$f3 are used to store float return values
        lwc1 $f12, c_temp         # float c_temp=12.0f;
        jal celsius_to_fahrenheit # celsius_to_fahrenheit(c_temp);
        mov.s $f4, $f0            # float f_temp=celsius_to_fahrenheit(c_temp);

        li $v0, 2                 # code to print float in $f12
        syscall                   # print c_temp
        la $a0, degree_C
        li $v0, 4                 # code to print string in $a0
        syscall                   # print "°C = "
        mov.s $f12, $f4           # move f_temp to $f12 for printing
        li $v0, 2
        syscall                   # print f_temp
        la $a0, degree_F
        li $v0, 4
        syscall                   # print "°F\n"
        li $v0, 10
        syscall                   # exit main
# -----------------------------------------------------------------------------
        # float celsius_to_fahrenheit(float celsius) {
        #   float fahrenheit=celsius*(9.0f/5.0f)+32.0f;
        #   return fahrenheit;
        # }
        # celsius is in $f12, fahrenheit is in $f0
celsius_to_fahrenheit:
        li $t0, 9
        mtc1 $t0, $f4             # move 9 to coprocessor-1 register $f4
        cvt.s.w $f4, $f4          # convert 9 to 9.0f (int to float) in $f4
        li $t0, 5
        mtc1 $t0, $f5
        cvt.s.w $f5, $f5          # $f5 holds 5.0f
        div.s $f4, $f4, $f5       # $f4 holds 9.0f/5.0f
        mul.s $f4, $f12, $f4      # $f4 holds celsius*(9.0f/5.0f)
        li $t0, 32
        mtc1 $t0, $f5
        cvt.s.w $f5, $f5          # $f5 holds 32.0f
        add.s $f0, $f4, $f5       # float fahrenheit=celsius*(9.0f/5.0f)+32.0f;
        jr $ra                    # return fahrenheit;
# -----------------------------------------------------------------------------
