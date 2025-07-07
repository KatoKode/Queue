/*------------------------------------------------------------------------------
    Queue Implementation in x86_64 Assembly Language with C interface
    Copyright (C) 2025  J. McIntosh

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
------------------------------------------------------------------------------*/
#ifndef UTIL_H
#define UTIL_H  1

#include <stddef.h>
#include <stdlib.h>
#include <stdint.h>

typedef struct queue queue_t;

struct queue {
  size_t      o_size;
  size_t      s_size;
  void *      head;
  void *      tail;
  void *      bufend;
  void *      buffer;
};

#define queue_alloc() (calloc(1, sizeof(queue_t)))
#define queue_free(P) (free(P), P = NULL)

int queue_empty (queue_t *);
int queue_full (queue_t *);
int queue_init (queue_t *, size_t const, size_t const);
int queue_deque (queue_t *, void *);
int queue_enque (queue_t *, void const *);
void queue_term (queue_t *);
#endif
