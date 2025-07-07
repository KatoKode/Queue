/*------------------------------------------------------------------------------
    Assembly Language Implementation of a Queue
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
#include "main.h"

int main (int argc, char *argv[]) {

  if (argc < 2) {
    printf ("usage: ./btest [random number]\n");
    return -1;
  }

  queue_t queue;

  if (queue_init(&queue, DATA_COUNT, sizeof(data_t)) < 0) return -1;

  // myrand will hold the random number paramenter
  size_t myrand = strtol(argv[1], NULL, 10);
  srand48(myrand);    // initialize the random number generator

  puts("\n---| enque |---\n");

  for (size_t i = 0L; i < DATA_COUNT; ++i) {
    data_t d;

    d.d = drand48();

    (void) snprintf(d.s, STR_LEN + 1, "%8.6f", d.d);

    if (queue_enque(&queue, &d) < 0) return -1;

    print_data(i, &d);
  }

  puts("\n---| deque |---\n");

  for (size_t i = 0L; i < DATA_COUNT; ++i) {
    data_t d;

    if (queue_deque(&queue, &d) < 0) return -1;

    print_data(i, &d);
  }

  puts("\n");

  queue_term(&queue);

  puts("\n");

  return 0;
}
//
// output data object
//
void print_data (size_t const i, data_t const *d) {
  printf("%02lu:  d: %8.6lf  s: %8s\n", i, d->d, d->s);
}

