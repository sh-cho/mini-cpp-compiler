TARGET = mini-gcc
OBJECTS = lex.yy.c parser.tab.c parser.tab.h

$(TARGET) : $(OBJECTS)
	gcc -o $@ print.c $^ -lfl -g

parser.tab.c parser.tab.h : parser.y
	bison -t -d $^

lex.yy.c : scanner.l parser.tab.h
	flex -d $<

clean:
	rm $(OBJECTS) $(TARGET)