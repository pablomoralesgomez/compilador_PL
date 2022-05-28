all: micomp $(F)
	./micomp $(F)

clean:
	rm -f lex.yy.c *.tab.? parser.output micomp .DS_Store *~

micomp: parser.tab.c lex.yy.c parser.tab.c
	gcc -o micomp parser.tab.c lex.yy.c -lfl

lex.yy.c: milex.l parser.tab.h
	flex milex.l

parser.tab.c: parser.y tab.c tab.h
	bison -lvt parser.y