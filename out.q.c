BEGIN
	R0=4;
	//ID initialization: x - l:10
	RR0=0.500000;
	//ID initialization: df - l:11
	R1=32;
	//ID initialization: c - l:12
	R2=1;
	//ID initialization: test - l:18
	R3=I(0x-0002);  //evaluate test - l:19
	R4=1;
	// Igualdad - l:19
	R3=R3!=R4;
	//ID initialization: d - l:19
	R4=1;
	//ID initialization: a - l:33
	R5=1;
	//ID initialization: i - l:34
L 1: //for con - l:34
	R6=I(0x-0002);  //evaluate i - l:34
	R7=3;
	// Igualdad - l:34
	R6=R6<R7;
	IF (!R6) GT(2);//for bool - l:34
	R6=1;
	// Assign i - l:34
	R7=0x-0002;
	R8=I(R7);
	R8=R8+R6;
	I(R7)=R8;
	R6=1;
	//ID initialization: j - l:35
L 3: //for con - l:35
	R7=I(0x-0002);  //evaluate j - l:35
	R8=3;
	// Igualdad - l:35
	R7=R7<R8;
	IF (!R7) GT(4);//for bool - l:35
	R7=1;
	// Assign j - l:35
	R8=0x-0002;
	R9=I(R8);
	R9=R9+R7;
	I(R8)=R9;
	 GT(3) //continue - l:36
	R7=1;
	//ID initialization: z - l:37
L 5: //for con - l:37
	R8=I(0x-0002);  //evaluate z - l:37
	R9=3;
	// Igualdad - l:37
	R8=R8<R9;
	IF (!R8) GT(6);//for bool - l:37
	R8=1;
	// Assign z - l:37
	R9=0x-0002;
	R10=I(R9);
	R10=R10+R8;
	I(R9)=R10;
	R8=1;
	//ID initialization: w - l:38
L 6: //for bre - l:39
	 GT(4) //break- l:40
L 4: //for bre - l:41
L 2: //for bre - l:42
END
