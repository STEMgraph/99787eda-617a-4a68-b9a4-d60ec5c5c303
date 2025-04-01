<!---
{
  "depends_on": [],
  "author": "Stephan Bökelmann",
  "first_used": "2025-04-01",
  "keywords": ["assembly", "NASM", "syscall", "x86_64", "Linux"]
}
--->

# Introduction to NASM on Linux

## 1) Introduction

Assembly programming allows us to interact with the **bare metal** of the machine. Using **NASM (Netwide Assembler)**, a popular assembler for x86 and x86_64 architectures, we can write low-level code that speaks almost directly to the CPU.

NASM is:
- Simple and consistent
- Uses **Intel syntax**
- Produces object files in **ELF** format for Linux
- Suitable for small, direct programs or educational use

In this exercise, we will write a minimal NASM program that calls the Linux `exit` syscall to terminate a process with a specific return code. This teaches how system calls work, how arguments are passed via registers, and how the program execution begins at `_start`.

To install NASM on your Linux system:

```bash
sudo apt update
sudo apt install nasm
```

Verify installation:

```bash
nasm -v
```

Here is your first complete NASM program:

```nasm
; file: exit.asm
section .text
    global _start

_start:
    mov     rax, 60     ; syscall: exit
    mov     rdi, 42     ; return code
    syscall             ; invoke kernel
```

To assemble and run it:

```bash
nasm -f elf64 exit.asm -o exit.o
ld exit.o -o exit
./exit
echo $?   # prints 42
```

This is a minimal, but powerful example that demonstrates the Linux syscall ABI: parameters go into specific registers (`rdi`, `rsi`, `rdx`…), the syscall number goes into `rax`, and the `syscall` instruction triggers the transition into kernel space.

Whenever the `syscall` instruction is encounterd in an assembly-program, the processor changes its behavior. Instead of further running in `ring 3` or _User Mode_ the processor clears its _Instruction Cache_, switches into `ring 0` or _Kernel Mode_ and loads the next instructions from a location called **Model-Specific Register / (Long System Target Address Register** or short: `MSR_LSTAR`.

This is a special address, which is set during the boot process. 
The Kernel than takes care of the instructions that were written into the registers (`rdi`, `rsi`, `rdx`…).

## 2) Tasks

1. **Install NASM**: Install nasm via your package manager and verify it works.
2. **Exit with Code 7**: Modify the program above to exit with code 7 instead of 42.
3. **Invalid Syscall**: Replace `mov rax, 60` with an invalid syscall number. Observe the behavior!

## 3) Questions

1. What does the `global _start` directive do?
2. Why do we use `rax` to specify the syscall?
3. What would happen if you omit the `syscall` instruction?
4. What is the difference between the `ld` and `nasm -f elf64` steps?

<details>
  <summary>Hint: syscall numbers</summary>

  Check out the Linux syscall table for x86_64:  
  https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/
</details>

## 4) Advice

Learning assembly is not about writing large programs — it's about understanding the **machine** beneath your abstractions. Starting with a minimal syscall lets you bypass the C runtime, linker conveniences, and libc entirely. This helps to demystify what's really going on when you run a program.

Don’t be afraid to break things. Inspect binaries, modify instructions, and read system call tables. In the words of Donald Knuth:

> “People who are more than casually interested in computers should have at least some idea of what the underlying hardware is like.”  
