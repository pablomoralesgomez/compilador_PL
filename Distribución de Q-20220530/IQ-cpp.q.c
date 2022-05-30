#include "Q.h"
# 1 "<stdin>"
# 1 "<built-in>"
# 1 "<command-line>"
# 31 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 32 "<command-line>" 2
# 1 "<stdin>"
# 1 "Qlib.h" 1
# 2 "<stdin>" 2




BEGIN
L 2: R6=R7;
        R7=R7-16;
        R0=I(R6+8);
        IF (R0<=1) GT(3);
        R0=R0-1;
        I(R7+8)=R0;
        P(R7+4)=R6;
        P(R7)=4;
        GT(2);
L 4: P(R6-4)=R0;
        R0=I(R6+8);
        R0=R0-2;
        I(R7+8)=R0;
        P(R7+4)=R6;
        P(R7)=5;
        GT(2);
L 5: R1=I(R6-4);
        R0=R1+R0;
L 3: R7=R6;
        R6=P(R7+4);
        R5=P(R7);
        GT(R5);
L 6: R6=R7;
        R7=R7-16;
        R3=0;
L 7: IF (R3>30) GT(8);
STAT(0)
    STR(0x11ff6,"fibo(%i)=");
    STR(0x11ff2,"%i\n");
CODE(0)
        R1=0x11ff6;
        R2=R3;
        R0=9;
        GT(-12);
L 9: R1=0x11ff2;
        P(R7+12)=R1;
        I(R7+8)=R3;
        P(R7+4)=R6;
        P(R7)=10;
        GT(2);
L 10: R2=R0;
        R1=P(R7+12);
        R0=11;
        GT(-12);
L 11: R3=R3+1;
        GT(7);
L 8: R7=R6;
        R6=P(R7+4);
        R5=P(R7);
        GT(R5);
L 0: R6=R7;
        GT(-1);
        R7=R7-8;
        P(R7+4)=R6;
        P(R7)=1;
        GT(6);
L 1: R0=0;
        GT(-2);
END
