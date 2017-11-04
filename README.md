# Mini c++ compiler

using flex, bison

- Authors
  - [Seonghyeon Cho](https://github.com/sh-cho/)
  - Jeongin Park

- Manual
  - Debug
    1. `flex -d lex.l`, `bison -t -d ayacc.y`
    1. main에 다음 내용 추가
    ```c++
    extern int yydebug;
    yydebug = 1;
    ```

- Document
  - Problems
    1. ID reduction conflicts
    ```
    Type: ID
    IdentExpr: ID
    ```
	--> reduce conflict