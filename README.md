# Mini c++ compiler

using flex, bison

- Authors
  - [Seonghyeon Cho](https://github.com/sh-cho/)
  - Jeongin Park

- Manual
  - Debug
    1. `flex -d lex.l`, `bison -t -d ayacc.y`
    2. main에 다음 내용 추가
    ```c++
    extern int yydebug;
    yydebug = 1;
    ```