# 32-bit Perfect shuffle

## Specification
• The goal is to implement a function named “shuffle32” that rearranges the bits of a 32 bit integer

• Label the bits from 0 (least significant, right end) to 31 (most significant, left end)

• he function argument is placed in $a0, the function result goes into $v0

## Nested Procedures Specification
Note that you write new nested procedures

• At the beginning of a function, you should save register values in the stack “if necessary”

• Before returning to the caller (at the end of the function), you should restore register values
from the stack for the caller

• You implement shuffle32 as a function that calls shuffle16 twice

• And, you implement shuffle16 as a function that calls shuffle8 twice

• And, you implement shuffle8 as a function that calls shuffle4 twice

• Thus, you should write the four functions, shuffle4 , shuffle8 , shuffle16 , and shuffle32
