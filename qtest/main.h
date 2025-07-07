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
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include "../queue/queue.h"
#include "../util/util.h"

// defines you can modify
#define DATA_COUNT    28

// defines you should not modify
#define STR_LEN   15

// index for tree walking
size_t ndx;

// data object
typedef struct data data_t;

struct data {
  double    d;
  char      s[STR_LEN + 1];
};

void print_data (size_t const , data_t const *);
