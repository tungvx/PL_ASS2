CC = gcc
BISON = bison
BISONFLAGS = -d
FLEX = flex
CFLAGS = -std=c99 -c
LDLIBS = -lgc
OBJECTS = dict.o lex.yy.o main.tab.o
main : $(OBJECTS)
	$(CC) $(OBJECTS) $(LDLIBS) -o main

dict.o : dict.h dict.c
	$(CC) $(CFLAGS) dict.c

lex.yy.o : lex.yy.c main.tab.h
	$(CC) $(CFLAGS) lex.yy.c

main.tab.o : main.tab.c main.tab.h	
	$(CC) $(CFLAGS) main.tab.c

lex.yy.c : main.lex main.tab.h
	$(FLEX) main.lex

main.tab.c main.tab.h : main.y
	$(BISON) $(BISONFLAGS) main.y

clean : 
	rm *.o main
