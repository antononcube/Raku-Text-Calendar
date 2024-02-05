#!/usr/bin/env raku
use v6.d;

use lib '.';

use Text::Calendar;

say '=' x 60;
say calendar-month-block(year => 2024, month => 'january'):weekdays;
say '-' x 60;
say calendar-month-block(year => 2024, month => 'feb', empty => ' .'):transposed:weekdays;
#say calendar-month-block(year => 2024, month => 'february');
#say calendar-month-block(year => 2024, month => 'march');

say '=' x 60;
#say calendar-year(2024, per-row => 4);
say calendar-year(2024, per-row => 4):t;
#say calendar(2024, 1..4,   per-row => 4);

say '=' x 60;
say 'Emacs style';
say '-' x 60;
say calendar():t;

say '=' x 60;
say calendar([2023 => 12, 2024 => 1, 2024 => 2]);
say '=' x 60;
say calendar([2023 => 12, 2024 => 1, 2024 => 2]):t;
