#ifndef AST_H_TEST
#define AST_H_TEST



// Program ::= (<ClassList>)? <MainFunc>
struct Program {
	struct Class *_class;	//classlist
	struct MainFunc *mainFunc;
};

// ClassList ::= (<Class>)+
// Class ::= class <string> { (private : <int_val>)? (public : <int_val>)? }
struct Class {
	char *id;
	int mem1, mem2;
	struct Class *prev;
};

// MainFunc ::= int main() {<string>}
struct MainFunc {
	char *body;
};

#endif