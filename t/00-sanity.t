use v6.d;
use lib '.';
use Text::Calendar;
use Test;

plan *;

## 1
ok calendar-month-block();

## 2
isa-ok calendar-month-block(), Str:D;

## 3
ok calendar();

## 4
isa-ok calendar(), Str:D;

## 5
ok calendar(Whatever);

## 6
ok calendar(2024, Whatever);

## 7
ok calendar(2024, 1..4, per-row=>2);

## 8
ok calendar-year();

done-testing;
