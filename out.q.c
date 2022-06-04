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
	//ID initialization: z - l:34
	R6=1;
	//ID initialization: i - l:35
	R7=1;
	//ID initialization: j - l:36
L 1: //while con - l:37
	R8=I(0x-0002);  //evaluate i - l:37
	R9=3;
	// Igualdad - l:37
	R8=R8<R9;
	IF (!R8) GT(2);//while bool - l:37
L 3: //while con - l:38
	R8=I(0x-0002);  //evaluate j - l:38
	R9=3;
	// Igualdad - l:38
	R8=R8<R9;
	IF (!R8) GT(4);//while bool - l:38
	GT(3) //continue - l:39
L 5: //while con - l:40
	R8=I(0x-0002);  //evaluate z - l:40
	R9=3;
	// Igualdad - l:40
	R8=R8<R9;
	IF (!R8) GT(6);//while bool - l:40
	R8=1;
	//ID initialization: w - l:41
L 6: //while bre - l:42
	GT(4) //break- l:43
L 4: //while bre - l:44
L 2: //while bre - l:45
END
