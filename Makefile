all: micomp $(F)
	./micomp $(F)

clean:
	rm -f lex.yy.c *.tab.? parser.output micomp .DS_Store *~

ejts: parser.tab.c lex.yy.c tab.c
	gcc -o micomp tab.c parser.tab.c lex.yy.c

lex.yy.c: milex.l parser.tab.h
	flex milex.l

ejts.tab.c: parser.y tab.c tab.h
	bison -lvt parser.y