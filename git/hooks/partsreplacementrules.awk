#!/bin/awk -f
{ parts = $1
  sub(/Replaced/, "Result", parts)
  printf "%s \\/ ",parts
}
