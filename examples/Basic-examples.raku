#!/usr/bin/env raku
use v6.d;

use lib '.';

use Text::Calendar;

#say calendar-month-block(year => 2024, month => 'january');
#say calendar-month-block(year => 2024, month => 'february');
#say calendar-month-block(year => 2024, month => 'march');

say calendar-year(2024, per-row => 4);
#say calendar(2024, 1..4,   per-row => 4);

#say calendar([2023 => 12, 2024 => 1, 2024 => 2]);
#say calendar();