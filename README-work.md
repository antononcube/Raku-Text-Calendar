# Text::Calendar

Raku package with text calendar functions for displaying monthly, yearly, and custom calendars.

-----

## Installation

From [Zef ecosystem](https://raku.land):

```
zef install Text::Calendar
```

From GitHub:

```
zef install https://github.com/antononcube/Raku-Text-Calendar.git
```

-----

## Examples

### Emacs style: this month with ones before and after

Load the package and show today's date:

```raku
use Text::Calendar;
Date.today;
```

Default, "Emacs style" calendar:

```raku
calendar();
```

Compare the output above with the that of UNIX (macOS) function `cal`:

```shell
cal -3 -h
```

### Yearly 

```raku
calendar-year(2024, per-row=>6)
```

**Remark:** The command used above has the same effect as `calendar-year(per-row=>6)`. 
I.e. the first, year argument can be `Whatever` and the current year be "deduced" as `Date.today.year`.

### Specific year-month pairs

```raku
calendar([2022=>2, 2023=>11, 2024 => 2])
```

-----

## Implementation notes

The initial codes for `calendar-month-block` and `calendar` were taken from https://rosettacode.org/wiki/Calendar#Raku .

The modifications done are for:
- Different signatures for making calendars
- Using of specs that are lists of year-month pairs

Significant modifications are expected for calendars based on ranges of days.
(The lists can be both dense or sparse.)

-----

## TODO

- [ ] Features
  - [X] DONE Month block string
  - [X] DONE Yearly calendar
  - [X] DONE Calendar for span of months
    - I.e. "Emacs style"
  - [X] DONE Calendar for a spec that is a list of year-month pairs
  - [ ] TODO Sparse calendar
    - Only for specified days
    - Days are specified with a list
  - [ ] TODO Language localization
    - Using the short names of weekdays in "Date::Names", [TB1]
    - Specified first day of week (e.g. Monday, not Sunday)
  - [ ] `ncal` mode 
    - I.e. "transposed" layout like:
```
    January 2024      February 2024     March 2024        
Mo  1  8 15 22 29        5 12 19 26        4 11 18 25   
Tu  2  9 16 23 30        6 13 20 27        5 12 19 26   
We  3 10 17 24 31        7 14 21 28        6 13 20 27   
Th  4 11 18 25        1  8 15 22 29        7 14 21 28   
Fr  5 12 19 26        2  9 16 23        1  8 15 22 29   
Sa  6 13 20 27        3 10 17 24        2  9 16 23 30   
Su  7 14 21 28        4 11 18 25        3 10 17 24 31
```
- [ ] Unit tests
  - [ ] DONE Sanity / signatures
  - [ ] TODO Correctness
    - [ ] Monthly
    - [ ] Yearly
    - [ ] Span
- [ ] Documentation
  - [X] DONE Basic README
  - [ ] TODO Detailed usage messages
  - [ ] TODO Comparison with LLMs

-----

## References

[TB1] Tom Browder,
[Date::Names Raku package](https://github.com/tbrowder/Date-Names),
(2019-2024),
[GitHub/tbrowder](https://github.com/tbrowder).