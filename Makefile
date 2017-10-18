TARGET = compiler
OBJECTS = lex.yy.c parser.tab.c parser.tab.h

$(TARGET) : $(OBJECTS)
	gcc -o $@ $^ -lfl

grammar.tab.c grammar.tab.h : parser.y
	bison -d $^

lex.yy.c : scanner.l parser.tab.h
	flex $<

clean:
	rm $(OBJECTS) $(TARGET)