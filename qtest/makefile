#-------------------------------------------------------------------------------
#   Queue Implementation in x86_64 Assembly Language with C interface
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
qtest: main.o ../queue/libqueue.so ../util/libutil.so
	gcc -march=x86-64 -m64 -z noexecstack main.o ../queue/libqueue.so ../util/libutil.so -o qtest
main.o: main.c
	gcc -march=x86-64 -m64 -Wall -c main.c -pthread -o main.o
clean:
	rm -f qtest main.o
