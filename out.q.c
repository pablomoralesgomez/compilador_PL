BEGIN
	R0=4;
	//ID initialization: x - l:10
	RR0=0.500000;
	//ID initialization: df - l:11
	R1=32;
	//ID initialization: c - l:12
	R2=1;
	//ID initialization: test - l:18
	R3=I(0x-0002);  //evaluate test
	R4=1;
	// Igualdad - l:19
	R3=R3!=R4;
	//ID initialization: d - l:19
	R4=I(0x-0002);  //evaluate x
	// Assign x - l:29
	R5=0x-0002;
	R6=I(R5);
	R6=R6+R4;
	I(R5)=R6;
	RR1=I(0x-0002);  //evaluate df
	// Assign x - l:30
	R4=0x-0002;
	R5=I(R4);
	R5=R5+RR1;
	I(R4)=R5;
	R4=I(0x-0002);  //evaluate x
	// Assign df - l:31
	R5=0x-0002;
	RR1=I(R5);
	RR1=RR1+R4;
	I(R5)=RR1;
	RR1=I(0x-0002);  //evaluate df
	// Assign df - l:32
	R4=0x-0002;
	RR2=I(R4);
	RR2=RR2+RR1;
	I(R4)=RR2;
END
