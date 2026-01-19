;-------------------------------------------------------------------------------
;   Queue (QUEUE) Implementation in x86_64 Assembly Language with C interface
;
;   Copyright (C) 2025  J. McIntosh
;
;   QUEUE is free software; you can redistribute it and/or modify
;   it under the terms of the GNU General Public License as published by
;   the Free Software Foundation; either version 2 of the License, or
;   (at your option) any later version.
;
;   QUEUE is distributed in the hope that it will be useful,
;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;   GNU General Public License for more details.
;
;   You should have received a copy of the GNU General Public License along
;   with QUEUE; if not, write to the Free Software Foundation, Inc.,
;   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
;-------------------------------------------------------------------------------
%ifndef QUEUE_ASM
%define QUEUE_ASM   1
;
extern bzero
extern calloc
extern free
extern memmove64
extern printf
;
NULL          EQU     0
ALIGN_SIZE    EQU     8
ALIGN_WITH    EQU     (ALIGN_SIZE - 1)
ALIGN_MASK    EQU     ~(ALIGN_WITH)
;
;-------------------------------------------------------------------------------
;
%macro ALIGN_STACK_AND_CALL 2-4
      mov     %1, rsp               ; backup stack pointer (rsp)
      and     rsp, QWORD ALIGN_MASK ; align stack pointer (rsp) to
                                    ; 16-byte boundary
      call    %2 %3 %4              ; call C function
      mov     rsp, %1               ; restore stack pointer (rsp)
%endmacro
;
; Example: Call LIBC function
;         ALIGN_STACK_AND_CALL r15, calloc, wrt, ..plt
;
; Example: Call C callback function with address in register (rcx)
;         ALIGH_STACK_AND_CALL r12, rcx
;-------------------------------------------------------------------------------
;
%include "queue.inc"
;
section .text
;
;-------------------------------------------------------------------------------
; C definition:
;
;   int queue_deque (queue_t *queue, void *object);
;
; param:
;
;   rdi = queue
;   rsi = object
;
; return:
;
;   0 (success) | -1 (failure)
;
; stack:
;
;   QWORD [rbp - 8]   = rdi (queue)
;   QWORD [rbp - 16]  = rsi (object)
;-------------------------------------------------------------------------------
;
      global queue_deque:function
queue_deque:
; prologue
      push      rbp
      mov       rbp, rsp
      sub       rsp, 24
      mov       QWORD [rbp - 8], rdi
      mov       QWORD [rbp - 16], rsi
; if (queue->head == NULL) return -1;
      mov       eax, -1
      mov       rcx, QWORD [rdi + queue.head]
      test      rcx, rcx
      jz        .epilogue
; memmove64 (object, queue->head, queue->item_size);
      mov       rdx, QWORD [rdi + queue.o_size]
      mov       rsi, QWORD [rdi + queue.head]
      mov       rdi, QWORD [rbp - 16]
      call      memmove64 wrt ..plt
; queue->head += queue->s_size;
      mov       rdi, QWORD [rbp - 8]
      mov       rax, QWORD [rdi + queue.head]
      mov       rcx, QWORD [rdi + queue.s_size]
      add       rax, rcx
      mov       QWORD [rdi + queue.head], rax
; if (queue->head == queue->bufend);
      mov       rcx, QWORD [rdi + queue.bufend]
      cmp       rax, rcx
      jne       .check_empty
;   queue->head = queue->buffer;
      mov       rax, QWORD [rdi + queue.buffer]
      mov       QWORD [rdi + queue.head], rax
.check_empty:
; if (queue->head == queue->tail);
      mov       rax, QWORD [rdi + queue.head]
      mov       rcx, QWORD [rdi + queue.tail]
      cmp       rax, rcx
      jne       .success
;   queue->head = NULL and queue-tail = NULL;
      xor       rax, rax
      mov       QWORD [rdi + queue.head], rax
      mov       QWORD [rdi + queue.tail], rax
.success:
      xor       eax, eax
.epilogue:
      mov       rsp, rbp
      pop       rbp
      ret
;
;-------------------------------------------------------------------------------
; C definition:
;
;   int queue_empty (queue_t *queue);
;
; param:
;
;   rdi = queue
;
; return:
;
;   0 (false) | 1 (true)
;-------------------------------------------------------------------------------
;
      global queue_empty:function
queue_empty:
; if (queue->tail == NULL) return 1;
      mov       eax, 1
      mov       rcx, QWORD [rdi + queue.tail]
      test      rcx, rcx
      jz        .return
      xor       eax, eax
.return:
      ret
;
;-------------------------------------------------------------------------------
; C/C++ definitions:
;
;   int queue_enque (queue_t *queue, void *object)
;
; param:
;
; rdi = queue
; rsi = object
;
; return:
;
;   0 (success) | -1 (failure)
;
; stack:
;
;   QWORD [rbp - 8] = rdi (queue)
;-------------------------------------------------------------------------------
;
      global queue_enque:function
queue_enque:
; prologue
      push      rbp
      mov       rbp, rsp
      sub       rsp, 8
      mov       QWORD [rbp - 8], rdi
; if (queue->head == queue->tail) {
      mov       rcx, QWORD [rdi + queue.head]
      mov       rdx, QWORD [rdi + queue.tail]
      cmp       rdx, rcx
      jne       .do_enque
;   if (queue->tail != NULL) return -1;
      mov       eax, -1
      test      rdx, rdx
      jnz       .epilogue
;   queue->head = queue->buffer;
      mov       rax, QWORD [rdi + queue.buffer]
      mov       QWORD [rdi + queue.head], rax
;   queue->tail = queue->buffer;
      mov       QWORD [rdi + queue.tail], rax
; }
.do_enque:
; (void) memmove64(queue->tail, object, queue->o_size)
      mov       rdx, QWORD [rdi + queue.o_size]
; >>>> rsi still holds address of object <<<<
      mov       rdi, QWORD [rdi + queue.tail]
      call      memmove64 wrt ..plt
; queue->tail += queue->s_size;
      mov       rdi, QWORD [rbp - 8]
      mov       rax, QWORD [rdi + queue.tail]
      mov       rcx, QWORD [rdi + queue.s_size]
      add       rax, rcx
      mov       QWORD [rdi + queue.tail], rax
; if (queue->tail == queue->bufend)
      mov       rcx, QWORD [rdi + queue.bufend]
      cmp       rax, rcx
      jne       .success
;   queue->tail = queue->buffer
      mov       rax, QWORD [rdi + queue.buffer]
      mov       QWORD [rdi + queue.tail], rax
.success:
      xor       eax, eax
.epilogue:
      mov       rsp, rbp
      pop       rbp
      ret
;
;-------------------------------------------------------------------------------
; C definition:
;
;   int queue_full (queue_t *queue);
;
; param:
;
;   rdi = queue
;
; return:
;
;   0 (false) | 1 (true)
;-------------------------------------------------------------------------------
;
      global queue_full:function
queue_full:
; if ((queue->head != NULL) && (queue->head == queue->tail)) return 1
      mov       eax, 1
      mov       rcx, QWORD [rdi + queue.head]
      test      rcx, rcx
      jz        .empty
      mov       rdx, QWORD [rdi + queue.tail]
      cmp       rcx, rdx
      je        .return
.empty:
      xor       eax, eax
.return:
      ret
;
;-------------------------------------------------------------------------------
; C definition:
;
;   int queue_init (queue_t *queue, size_t obj_count, size_t const obj_size);
;
; param:
;
;   rdi = queue
;   rsi = obj_count
;   rdx = obj_size
;
; return:
;
;   0 (success) | -1 (failure)
;
; stack:
;
;   QWORD [rbp - 8]   = rdi (queue)
;   QWORD [rbp - 16]  = buffer_size
;   QWORD [rbp - 24]  = rbx (callee saved)
;-------------------------------------------------------------------------------
;
      global queue_init:function
queue_init:
; prologue
      push      rbp
      mov       rbp, rsp
      sub       rsp, 24
      mov       QWORD [rbp - 8], rdi
      mov       QWORD [rbp - 24], rbx
; queue->o_size = obj_size;
      mov       QWORD [rdi + queue.o_size], rdx
; queue->s_size = (obj_size + ALIGN_SIZE - 1) & ALIGN_MASK;
      mov       rax, rdx
      add       rax, ALIGN_SIZE
      dec       rax
      and       rax, ALIGN_MASK
      test      rax, rax  ; test for 0 and adjust up to 8
      jnz       .not_zero
      mov       rax, QWORD ALIGN_SIZE
.not_zero:
      mov       QWORD [rdi + queue.s_size], rax
; buffer_size = queue->s_size * obj_count;
      mul       rsi
      mov       QWORD [rbp - 16], rax
; if ((queue->buffer = calloc(1, buffer_size)) == NULL) return -1;
      mov       rdi, 1
      mov       rsi, rax
      ALIGN_STACK_AND_CALL rbx, calloc, wrt, ..plt
      mov       rdi, QWORD [rbp - 8]
      mov       QWORD [rdi + queue.buffer], rax
      test      rax, rax
      jnz       .continue
      mov       eax, -1
      jmp       .epilogue
.continue:
; queue->head = NULL and queue->tail = NULL;
      xor       rax, rax
      mov       QWORD [rdi + queue.head], rax
      mov       QWORD [rdi + queue.tail], rax
; queue->bufend = queue->buffer + buffer_size;
      mov       rax, QWORD [rdi + queue.buffer]
      mov       rcx, QWORD [rbp - 16]
      add       rax, rcx
      mov       QWORD [rdi + queue.bufend], rax
      xor       eax, eax
.epilogue:
      mov       rbx, QWORD [rbp - 24]
      mov       rsp, rbp
      pop       rbp
      ret
;
;-------------------------------------------------------------------------------
; C definition:
;
;   void queue_term (queue_t *queue);
;
; param:
;
;   rdi = queue
;
; stack:
;
;   QWORD [rbp - 8] = rdi (queue}
;   QWORD [rbp - 16]  = rbx (callee saved)
;-------------------------------------------------------------------------------
;
      global queue_term:function
queue_term:
; prologue
      push      rbp
      mov       rbp, rsp
      sub       rsp, 24
      mov       QWORD [rbp - 8], rdi
      mov       QWORD [rbp - 16], rbx
; buffer_size = queue->bufend - queue->buffer;
      mov       rcx, QWORD [rdi + queue.buffer]
      mov       rax, QWORD [rdi + queue.bufend]
      sub       rax, rcx
      mov       rdi, rcx
      mov       rsi, rax
      ALIGN_STACK_AND_CALL rbx, bzero, wrt, ..plt
; free item queue memory
      mov       rdi, QWORD [rbp - 8]
      mov       rdi, QWORD [rdi + queue.buffer]
      ALIGN_STACK_AND_CALL rbx, free, wrt, ..plt
; zero out queue structure
      mov       rdi, QWORD [rbp - 8]
      mov       rsi, QWORD queueSize
      ALIGN_STACK_AND_CALL rbx, bzero, wrt, ..plt
; epilogue
      mov       rbx, QWORD [rbp - 16]
      mov       rsp, rbp
      pop       rbp
      ret
%endif
