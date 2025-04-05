


Just Another Armchair Programmer

Queue Implementation in x86_64 Assembly Language with C interface

by Jerry McIntosh
# INTRODUCTION
This is an Assembly Language implementation of a Queue (FIFO).  The Queue is implemented as a shared-library with a C interface.  There is also a C demo program.

LIST OF REQUIREMENTS:

+ Linux OS
+ Programming languages: C and Assembly
+ Netwide Assembler (NASM), the GCC compiler, and the make utility
+ your favorite text editor
+ and working at the command line

FILE STRUCTURE:

util/
+ memmove64.asm
+ util.h
+ util.c
+ makefile

btree/
+ queue.asm
+ queue.inc
+ queue.h
+ queue.c
+ makefile

btest/
+ main.h
+ main.c
+ makefile
+ go_qtest.sh
# CREATE THE DEMO WITH THE MAKE UTILITY:
Run the following command combo in each folder.
```bash
make clean; make
```

# RUN THE DEMO:
```bash
./go_qtest.sh
```
# THINGS TO KNOW:
You can modify a couple defines in the C header file `main.h`:
```c
#define DATA_COUNT    28
```
Modifying these defines will change the behavior of the demo program.

There are calls to `printf` in the `queue.asm` file.  They are for demo purposes only and can be removed or commented out.  The `printf` code sections are marked with comment lines: `BEGIN PRINTF`; and `END PRINTF`.  The format and text strings passed to `printf` are in the `.data` section of the `queue.asm` file.

Have Fun!
