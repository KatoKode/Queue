#-------------------------------------------------------------------------------
#   Assembly Language Implementation of a Queue
#   Copyright (C) 2025  J. McIntosh
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License along
#   with this program; if not, write to the Free Software Foundation, Inc.,
#   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#-------------------------------------------------------------------------------
libqueue.so: queue_asm.o queue.o
	gcc -march=x86-64 -m64 -z noexecstack -shared queue_asm.o queue.o -o libqueue.so
queue.o: queue.c
	gcc -march=x86-64 -m64 -fPIC -c queue.c -o queue.o
queue_asm.o: queue.asm
	nasm -f elf64 queue.asm -o queue_asm.o
.PHONY: clean
clean:
	rm -f libqueue.so queue.o queue_asm.o
