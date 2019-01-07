all:
	yacc -d proiect.y
	lex proiect.l
	gcc lex.yy.c y.tab.c -ll -ly
	
clean:
	rm -r y.tab.c
	rm -r y.tab.h
	rm -r lex.yy.c
	rm a.out