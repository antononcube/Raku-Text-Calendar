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

Compared to [WCp1] and [TBp1], this package, "Text::Calendar", is lightweight and with no dependencies.

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
```
# 2024-02-05
```

Default, "Emacs style" calendar:

```raku
calendar();
```
```
# January                February               March                  
# Mo Tu We Th Fr Sa Su   Mo Tu We Th Fr Sa Su   Mo Tu We Th Fr Sa Su   
#  1  2  3  4  5  6  7             1  2  3  4                1  2  3   
#  8  9 10 11 12 13 14    5  6  7  8  9 10 11    4  5  6  7  8  9 10   
# 15 16 17 18 19 20 21   12 13 14 15 16 17 18   11 12 13 14 15 16 17   
# 22 23 24 25 26 27 28   19 20 21 22 23 24 25   18 19 20 21 22 23 24   
# 29 30 31               26 27 28 29            25 26 27 28 29 30 31
```

Compare the output above with the that of UNIX (macOS) function `cal`:

```shell
cal -3 -h
```
```
# 2024
#       January               February               March          
# Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  
#     1  2  3  4  5  6               1  2  3                  1  2  
#  7  8  9 10 11 12 13   4  5  6  7  8  9 10   3  4  5  6  7  8  9  
# 14 15 16 17 18 19 20  11 12 13 14 15 16 17  10 11 12 13 14 15 16  
# 21 22 23 24 25 26 27  18 19 20 21 22 23 24  17 18 19 20 21 22 23  
# 28 29 30 31           25 26 27 28 29        24 25 26 27 28 29 30  
#                                             31
```

Here is the "transposed" version (or UNIX `ncal` style):

```raku
say "ncal style:\n", calendar(:transposed);
```
```
# ncal style:
#     January 2024    February 2024   March 2024      
# Mo  1  8 15 22 29      5 12 19 26      4 11 18 25   
# Tu  2  9 16 23 30      6 13 20 27      5 12 19 26   
# We  3 10 17 24 31      7 14 21 28      6 13 20 27   
# Th  4 11 18 25      1  8 15 22 29      7 14 21 28   
# Fr  5 12 19 26      2  9 16 23      1  8 15 22 29   
# Sa  6 13 20 27      3 10 17 24      2  9 16 23 30   
# Su  7 14 21 28      4 11 18 25      3 10 17 24 31
```

### Yearly 

```raku
calendar-year(2024, per-row=>6)
```
```
# 2024
# 
# January                February               March                  April                  May                    June                   
# Mo Tu We Th Fr Sa Su   Mo Tu We Th Fr Sa Su   Mo Tu We Th Fr Sa Su   Mo Tu We Th Fr Sa Su   Mo Tu We Th Fr Sa Su   Mo Tu We Th Fr Sa Su   
#  1  2  3  4  5  6  7             1  2  3  4                1  2  3    1  2  3  4  5  6  7          1  2  3  4  5                   1  2   
#  8  9 10 11 12 13 14    5  6  7  8  9 10 11    4  5  6  7  8  9 10    8  9 10 11 12 13 14    6  7  8  9 10 11 12    3  4  5  6  7  8  9   
# 15 16 17 18 19 20 21   12 13 14 15 16 17 18   11 12 13 14 15 16 17   15 16 17 18 19 20 21   13 14 15 16 17 18 19   10 11 12 13 14 15 16   
# 22 23 24 25 26 27 28   19 20 21 22 23 24 25   18 19 20 21 22 23 24   22 23 24 25 26 27 28   20 21 22 23 24 25 26   17 18 19 20 21 22 23   
# 29 30 31               26 27 28 29            25 26 27 28 29 30 31   29 30                  27 28 29 30 31         24 25 26 27 28 29 30   
# 
# July                   August                 September              October                November               December               
# Mo Tu We Th Fr Sa Su   Mo Tu We Th Fr Sa Su   Mo Tu We Th Fr Sa Su   Mo Tu We Th Fr Sa Su   Mo Tu We Th Fr Sa Su   Mo Tu We Th Fr Sa Su   
#  1  2  3  4  5  6  7             1  2  3  4                      1       1  2  3  4  5  6                1  2  3                      1   
#  8  9 10 11 12 13 14    5  6  7  8  9 10 11    2  3  4  5  6  7  8    7  8  9 10 11 12 13    4  5  6  7  8  9 10    2  3  4  5  6  7  8   
# 15 16 17 18 19 20 21   12 13 14 15 16 17 18    9 10 11 12 13 14 15   14 15 16 17 18 19 20   11 12 13 14 15 16 17    9 10 11 12 13 14 15   
# 22 23 24 25 26 27 28   19 20 21 22 23 24 25   16 17 18 19 20 21 22   21 22 23 24 25 26 27   18 19 20 21 22 23 24   16 17 18 19 20 21 22   
# 29 30 31               26 27 28 29 30 31      23 24 25 26 27 28 29   28 29 30 31            25 26 27 28 29 30      23 24 25 26 27 28 29
```

**Remark:** The command used above has the same effect as `calendar-year(per-row=>6)`. 
I.e. the first, year argument can be `Whatever` and the current year be "deduced" as `Date.today.year`.

### Specific year-month pairs

```raku
calendar([2022=>2, 2023=>11, 2024 => 2])
```
```
# February               November               February               
# Mo Tu We Th Fr Sa Su   Mo Tu We Th Fr Sa Su   Mo Tu We Th Fr Sa Su   
#     1  2  3  4  5  6          1  2  3  4  5             1  2  3  4   
#  7  8  9 10 11 12 13    6  7  8  9 10 11 12    5  6  7  8  9 10 11   
# 14 15 16 17 18 19 20   13 14 15 16 17 18 19   12 13 14 15 16 17 18   
# 21 22 23 24 25 26 27   20 21 22 23 24 25 26   19 20 21 22 23 24 25   
# 28                     27 28 29 30            26 27 28 29
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
<h4>February</h4><table border="1"><thead><tr><th>Mo</th><th>Tu</th><th>We</th><th>Th</th><th>Fr</th><th>Sa</th><th>Su</th></tr></thead><tbody><tr><td>  </td><td>  </td><td>  </td><td>1</td><td>2</td><td>3</td><td>4</td></tr><tr><td>5</td><td>6</td><td><span style="color: red"><b>7</b></span></td><td>8</td><td>9</td><td>10</td><td>11</td></tr><tr><td>12</td><td>13</td><td>14</td><td>15</td><td>16</td><td>17</td><td>18</td></tr><tr><td>19</td><td>20</td><td>21</td><td>22</td><td>23</td><td>24</td><td>25</td></tr><tr><td>26</td><td>27</td><td>28</td><td>29</td><td>  </td><td>  </td><td>  </td></tr></tbody></table>


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