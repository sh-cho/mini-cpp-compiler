TARGET = mini-gcc
OBJECTS = lex.yy.c parser.tab.c parser.tab.h print.c

$(TARGET) : $(OBJECTS)
	gcc -o $@ $^ -lfl -g

parser.tab.c parser.tab.h : parser.y
	bison -d $^

lex.yy.c : scanner.l parser.tab.h
	flex $<

clean:
	rm $(OBJECTS) $(TARGET)