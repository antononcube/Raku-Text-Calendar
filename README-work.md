# Text::Calendar

Raku package with text calendar functions for displaying monthly, yearly, and custom calendars.

### Motivation

- For data science applications I need sparse calendars that contain only some of the dates 
- I want to facilitate making and displaying calendars in Jupyter notebooks using Markdown and HTML layouts  
- I like the "transposed" calendar layout of UNIX' `ncal`
- I am interested in comparisons of calendar making (i) with LLM applications, and (ii) in the "hard way" 

### Alternative implementations

- ["App::Cal"](https://raku.land/zef:coke/App::Cal), [WCp1].
- ["Calendar"](https://raku.land/zef:tbrowder/Calendar), [TBp1].

Compared to [WCp1] and [TBp1], this package, "Text::Calendars", is lightweight and with no dependencies.

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

Here is the "transposed" version (or UNIX `ncal` style):

```raku
say "ncal style:\n", calendar(:transposed);
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

### Month dataset

Using month dataset allows of utilizing HTML formatting in Markdown files or Jupyter notebooks.

Here is an example using ["Data::Translators"](https://raku.land/zef:antononcube/Data::Translators), [AAp1]:

```raku, results=asis
use Data::Translators;
my $m = 'February';
my $res = to-html(calendar-month-dataset(2024, $m), field-names => calendar-weekday-names);
'<h4>' ~ $m ~ '</h4>' ~ $res.subst('<td>7</td>', '<td><span style="color: red"><b>7</b></span></td>')
```

-----

## Implementation notes

The initial codes for `calendar-month-block` and `calendar` were taken from https://rosettacode.org/wiki/Calendar#Raku .

The modifications done are for:
- Different signatures for making calendars
- Using of specs that are lists of year-month pairs
- Have the transposed, `ncal` style layout

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
  - [X] DONE transposed or `ncal` mode 
  - [X] DONE Month block dataset
  - [ ] TODO Language localization
    - Using the short names of weekdays in "Date::Names", [TBp2]
    - Specified first day of week (e.g. Monday, not Sunday)
  - [ ] TODO Make sure month blocks align in multi-row layouts 
    - Like, year calendars
    - For transposed only
  - [ ] TODO Return a list of pairs with year-month keys and month-text-block keys
    - Using adverb `:pairs`
- [ ] Unit tests
  - [ ] DONE Sanity / signatures
  - [ ] TODO Correctness
    - [ ] Monthly
    - [ ] Yearly
    - [ ] Span
- [ ] Documentation
  - [X] DONE Basic README
  - [X] DONE Detailed usage messages
  - [ ] TODO Comparison with LLMs

-----

## References

[AAp1] Tom Browder,
[Data::Translators Raku package](https://github.com/antononcube/Raku-Data-Translators),
(2023),
[GitHub/tbrowder](https://github.com/antononcube).

[TBp1] Tom Browder,
[Calendar Raku package](https://github.com/tbrowder/Calendar),
(2020-2024),
[GitHub/tbrowder](https://github.com/tbrowder).

[TBp2] Tom Browder,
[Date::Names Raku package](https://github.com/tbrowder/Date-Names),
(2019-2024),
[GitHub/tbrowder](https://github.com/tbrowder).


[WCp1] Will Coleda,
[App::Cal Raku packate](https://github.com/coke/raku-cal),
(2022-2024),
[GitHub/coke](https://github.com/coke).