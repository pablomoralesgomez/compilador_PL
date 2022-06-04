BEGIN
	R0=4;
	//ID initialization: x - l:10
	RR0=0.500000;
	//ID initialization: df - l:11
	R1=32;
	//ID initialization: c - l:12
	R2=2;
	//ID initialization: b - l:15
	R3=1;
	//ID initialization: test - l:19
	R4=I(0x-0002);  //evaluate test - l:20
	R5=1;
	// Igualdad - l:20
	R4=R4!=R5;
	//ID initialization: d - l:20
	R5=1;
	//ID initialization: a - l:34
//if start - l:35
	R6=1;
	IF (!R6) GT(2); //if bool - l:35
//if start - l:36
	R6=1;
	IF (!R6) GT(4); //if bool - l:36
	R6=2;
	// Assign a - l:37
	R7=0x-0002;
	I(R7)=R6;
	GT(3); //exit if - l:39
L 4: //if not - l:39
	R6=1;
	//ID initialization: j - l:40
L 3: //if exit - l:42
	GT(1); //exit if - l:44
L 2: //if not - l:44
	R7=1;
	IF (!R7) GT(5);//elif bool - l:44
	R7=2;
	// Assign b - l:45
	R8=0x-0002;
	I(R8)=R7;
	GT(1); //exit elif - l:47
L 5: //elif not - l:47
	R7=3;
	// Assign c - l:48
	R8=0x-0002;
	I(R8)=R7;
L 1: //if exit - l:50
	R7=1;
	//ID initialization: z - l:51
	R8=1;
	//ID initialization: i - l:52
	R9=1;
	//ID initialization: j - l:53
L 6: //while con - l:54
	R10=I(0x-0002);  //evaluate i - l:54
	R11=3;
	// Igualdad - l:54
	R10=R10<R11;
	IF (!R10) GT(7); //while bool - l:54
L 8: //while con - l:55
	R10=I(0x-0002);  //evaluate j - l:55
	R11=3;
	// Igualdad - l:55
	R10=R10<R11;
	IF (!R10) GT(9); //while bool - l:55
//if start - l:56
	R10=1;
	IF (!R10) GT(11); //if bool - l:56
	R10=2;
	// Assign a - l:57
	R11=0x-0002;
	I(R11)=R10;
	GT(10); //exit if - l:59
L 11: //if not - l:59
L 10: //if exit - l:60
	GT(8) //continue - l:60
L 12: //while con - l:61
	R10=I(0x-0002);  //evaluate z - l:61
	R11=3;
	// Igualdad - l:61
	R10=R10<R11;
	IF (!R10) GT(13); //while bool - l:61
	R10=1;
	//ID initialization: w - l:62
L 13: // while bre - l:63
	GT(9) //break- l:64
L 9: // while bre - l:65
L 7: // while bre - l:66
END
