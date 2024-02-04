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