BEGIN
	R0 = 4;
	R7 = R7 - 4
	I(R6 - 4) = R0
	RR0 = 0.500000;
	R7 = R7 - 8
	I(R6 - 8) = R0
	R0 = 32;
	R7 = R7 - 12
	I(R6 - 12) = R0
	R0 = 2;
	R7 = R7 - 16
	I(R6 - 16) = R0
	R0 = 1;
	R7 = R7 - 20
	I(R6 - 20) = R0
	R0 = I(R6 - 20);  //evaluate test 20
	R1 = 1;
	// Igualdad - l:20
	R0=R0!=R1;
	R7 = R7 - 24
	I(R6 - 24) = R0
	R0 = 1;
	R7 = R7 - 28
	I(R6 - 28) = R0
//if start - l:35
	R0 = 1;
	IF (!R0) GT(2); //if bool - l:35
//if start - l:36
	R0 = 1;
	IF (!R0) GT(4); //if bool - l:36
	R0 = 2;
	// Assign a - l:37
	R1=0x00028;
	I(R1)=R0;
	GT(3); //exit if - l:39
L 4: //if not - l:39
	R0 = 1;
	R7 = R7 - 32
	I(R6 - 32) = R0
L 3: //if exit - l:42
	GT(1); //exit if - l:44
L 2: //if not - l:44
	R0 = 1;
	IF (!R0) GT(5);//elif bool - l:44
	R0 = 2;
	// Assign b - l:45
	R1=0x00016;
	I(R1)=R0;
	GT(1); //exit elif - l:47
L 5: //elif not - l:47
	R0 = 3;
	// Assign c - l:48
	R1=0x00012;
	I(R1)=R0;
L 1: //if exit - l:50
	R0 = 1;
	R7 = R7 - 36
	I(R6 - 36) = R0
	R0 = 1;
	R7 = R7 - 40
	I(R6 - 40) = R0
	R0 = 1;
	R7 = R7 - 44
	I(R6 - 44) = R0
L 6: //while con - l:54
	R0 = I(R6 - 40);  //evaluate i 54
	R1 = 3;
	// Igualdad - l:54
	R0=R0<R1;
	IF (!R0) GT(7); //while bool - l:54
L 8: //while con - l:55
	R0 = I(R6 - 44);  //evaluate j 55
	R1 = 3;
	// Igualdad - l:55
	R0=R0<R1;
	IF (!R0) GT(9); //while bool - l:55
//if start - l:56
	R0 = 1;
	IF (!R0) GT(11); //if bool - l:56
	R0 = 2;
	// Assign a - l:57
	R1=0x00028;
	I(R1)=R0;
	GT(10); //exit if - l:59
L 11: //if not - l:59
L 10: //if exit - l:60
	GT(8) //continue - l:60
L 12: //while con - l:61
	R0 = I(R6 - 36);  //evaluate z 61
	R1 = 3;
	// Igualdad - l:61
	R0=R0<R1;
	IF (!R0) GT(13); //while bool - l:61
	R0 = 1;
	R7 = R7 - 48
	I(R6 - 48) = R0
L 13: // while bre - l:63
	GT(9) //break- l:64
L 9: // while bre - l:65
L 7: // while bre - l:66
END
