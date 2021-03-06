#include "value.h"
#include "prim.h"
#include "io.h"

value compare();
value equal();
value notequal();
value less();
value lessequal();
value greater();
value greaterequal();

value input_char();
value output_char();

c_primitive cprims[] = {
  compare,
  equal,
  notequal,
  less,
  lessequal,
  greater,
  greaterequal,
  input_char,
  recv_char,
  output_char,
  output_int,
  output_float,
  output_string,
  send_string,
};

const char *name_of_cprims[] = {
  "compare",
  "equal",
  "notequal",
  "less",
  "lessequal",
  "greater",
  "greaterequal",
  "input_char",
  "recv_char",
  "output_char",
  "output_int",
  "output_float",
  "output_string",
  "send_string",
};
