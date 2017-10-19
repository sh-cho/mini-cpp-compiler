TARGET = mini-gcc
OBJECTS = lex.yy.c parser.tab.c parser.tab.h main.c

$(TARGET) : $(OBJECTS)
	gcc -o $@ $^ -lfl

parser.tab.c parser.tab.h : parser.y
	bison -d $^

lex.yy.c : scanner.l parser.tab.h
	flex $<

clean:
	rm $(OBJECTS) $(TARGET)