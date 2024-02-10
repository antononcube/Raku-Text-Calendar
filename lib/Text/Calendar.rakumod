use v6.d;

# The code for calendar-month-block and calendar-year
# from https://rosettacode.org/wiki/Calendar#Raku
# Further modifications were done.

unit module Text::Calendar;

#==========================================================
my @weekday-names = <Mo Tu We Th Fr Sa Su>;
my @month-short-names = <Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec>;
my @month-names = <January February March April May June July August September October November December>;
my %month-names = @month-names Z=> 1 .. 12;
%month-names = %month-names, %( @month-short-names>>.lc Z=> 1 .. 12);
%month-names = %month-names.map({ $_.key.lc => $_.value });

sub calendar-weekday-names() is export {
    @weekday-names;
}

sub calendar-month-names(Bool :$short = False) is export {
    $short ?? @month-short-names !! @month-names;
}

#==========================================================
#| This function creates a visual representation of a calendar month, with options to include weekday headers and transpose the layout.
#| It can be customized with different symbols for empty days and optionally exclude weekday names from the output.
#| - C<$year>: The year for which the calendar month block is generated. Defaults to C<Whatever>.
#| - C<$month>: The month for which the calendar is generated. Also defaults to C<Whatever>.
#| - C<Str :$empty>: A string used to represent empty days in the calendar block. Defaults to two spaces.
#| - C<Bool :$weekdays>: A flag indicating whether weekday headers should be included in the output.
#|   Defaults to C<True:, including the weekdays.
#| - C<Bool :t(:$transposed)>: A flag to transpose the calendar, changing its orientation. Defaults to C<False>.
proto calendar-month-block(|) is export {*}

multi sub calendar-month-block($year = Whatever,
                               $month = Whatever,
                               Str :$empty = '  ',
                               Bool :$weekdays = True,
                               Bool :t(:$transposed) = False) {
    return calendar-month-block(:$year, :$month, :$empty, :$weekdays, :$transposed);
}

multi sub calendar-month-block(:$year is copy = Whatever,
                               :$month is copy = Whatever,
                               Str :$empty = '  ',
                               Bool :$weekdays = True,
                               Bool :t(:$transposed) = False) {

    # Process transpose
    if $transposed {
        return calendar-month-block-transposed(:$year, :$month, :$empty, :$weekdays);
    }

    # Process year
    if $year.isa(Whatever) { $year = Date.today.year; }

    die 'The argument $year is expected to be an interger or Whatever.'
    unless $year ~~ UInt:D;

    # Process month
    if $month.isa(Whatever) { $month = Date.today.month; }
    if $month ~~ Str:D { $month = %month-names{$month.lc} // 0 }

    die 'The argument $month is expected to be a month name, an interger between 1 and 12, or Whatever.'
    unless $month ~~ Int:D && 1 ≤ $month ≤ 12;

    my $date = Date.new($year, $month, 1);
    my $res = @month-names[$month - 1].fmt("%-20s\n") ~ ($weekdays ?? @weekday-names ~ "\n" !! '') ~
            (($empty xx $date.day-of-week - 1),
             (1 .. $date.days-in-month)».fmt('%2d')).flat.rotor(7, :partial).join("\n") ~
            (' ' if $_ < 7) ~ ($empty xx 7 - $_).join(' ') given Date.new($year, $month, $date.days-in-month)
            .day-of-week;

    return $res;
}

#----------------------------------------------------------
sub calendar-month-block-transposed(
        :$year is copy = Whatever,
        :$month is copy = Whatever,
        Str :$empty = '  ',
        Bool :$weekdays = True) {

    # Standard month block
    my $res = calendar-month-block(:$year, :$month, empty => '..');

    # Keep head
    my $head = $res.lines.head.trim;

    # Split into 2D array
    my @res2 = $res.lines.tail(*- 1)>>.split(/\h/, :skip-empty).flat.map({ $_.chars == 1 ?? " $_" !! $_ }).rotor(7)>>.Array;

    # Transpose
    my @res3;
    for ^@res2.elems -> $i {
        for ^@res2[0].elems -> $j {
            @res3[$j][$i] = @res2[$i][$j];
        }
    }

    # Combine
    my $res4 = @res3>>.join(' ').join("\n").subst('..', $empty, :g);

    if !$weekdays {
        $res4 = $res4.lines.map({ $_.substr(4, *) }).join("\n");
    }

    # Result
    $head = ($weekdays ?? ' ' x 4 !! '') ~ $head ~ ' ' ~ $year;
    return $head ~ ' ' x ($res4.lines.head.chars - $head.chars) ~ "\n" ~ $res4;
}

#==========================================================
#| Returns a dataset each row of which represents a week.
#| Each records has the weekdays are keys.
#| - C<$year>: The year for which the calendar month block is generated. Defaults to C<Whatever>.
#| - C<$month>: The month for which the calendar is generated. Also defaults to C<Whatever>.
proto calendar-month-dataset(|) is export {*}

multi sub calendar-month-dataset($year = Whatever,
                                 $month = Whatever,
                                 Str :$empty = '  ') {
    return calendar-month-dataset(:$year, :$month, :$empty);
}

multi sub calendar-month-dataset(:$year is copy = Whatever,
                                 :$month is copy = Whatever,
                                 Str :$empty = '  ') {
    my @calArr = calendar-month-block(:$year, :$month, empty => '..').lines.tail(*- 1).split(/\h/, :skip-empty).rotor(7)>>.Array;

    my @ds = @calArr.tail(*- 1).map({ @calArr[0].Array Z=> $_.map({ $_ eq '..' ?? $empty !! $_ }).Array })>>.Hash;

    if $year.isa(Whatever) { $year = Date.today.year; }
    if $month.isa(Whatever) { $month = Date.today.month; }
    return @ds;
}


#==========================================================

#| Give three consecutive months.
#| C<$year> -- Current year.
#| C<$month> -- Current month.
our sub three-months(Int $year, UInt $month) {
    my @months = $year X=> (($month - 1) ... ($month + 1));
    @months[0] = @months[0].value == 0 ?? (($year - 1) => 12) !! @months[0];
    @months[2] = @months[2].value == 13 ?? (($year + 1) => 1) !! @months[2];

    return @months;
}

#==========================================================

#| Process month specifications.
#| C<$month> -- Month specs: Whatever, Iterable of UInt | Str, or Iterable of year-month pairs.
#| C<$year> -- Year for the months.
our sub process-month-specs($months is copy, $year is copy = Whatever ) {

    if $year.isa(Whatever) { $year = Date.today.year; }

    die "Do not know how to process the year argument."
    unless $year ~~ UInt:D;

    given $months {
        when Whatever {
            $months = three-months($year, Date.today.month);
        }

        when ($_ ~~ UInt:D) && 1 ≤ $_ ≤ 12 {
            $months = [$year => $months,];
        }

        when $months ~~ Str:D {
            $months = [$year => %month-names{$months.lc},];
        }

        when $_ ~~ Iterable && $_.map({ $_ ~~ UInt:D || $_ ~~ Str:D }) {
            $months .= map({ $_ ~~ Str:D ?? %month-names{$_.lc} !! $_ });
            $months = ($year X=> $months.Array).cache;
        }

        when $_.all ~~ Pair:D {
            # Replace month names with integers
            $months = $_.map(-> $p { $p.key => ($p.value ~~ Str:D ?? %month-names{$p.value.lc} !! $p.value) }).Array;
        }

        default {
            die "Do not know how to process the months argument.";
        }
    }

    return $months;
}

#==========================================================
#| Generates a string that represents calendars for given months of a specific year, with options to adjust the layout and appearance.
#| - C<$year is copy> : Specifies the year for the calendars. This parameter is required and does not have a default value.
#| - C<$months is copy> : Specifies the months to be included in the calendar. This can be a single month or a list of months. This parameter is required and does not have a default value.
#| - C<UInt :$per-row> : Determines how many calendars are displayed per row in the output. Defaults to 3.
#| - C<Str :$empty> : Defines the string used to represent empty days in the calendar. Defaults to two spaces.
#| - C<Bool :t(:$transposed)> : If set to C<True>, transposes the layout of the calendar. Defaults to C<False>.
proto calendar(|) is export {*}

multi sub calendar($year is copy,
                   $months is copy,
                   UInt :$per-row = 3,
                   Str :$empty = '  ',
                   Bool :t(:$transposed) = False) {

    $months = process-month-specs($months, $year);

    return calendar($months, :$per-row, :$empty, :$transposed);
}

multi sub calendar($months is copy = Whatever,
                   UInt :$per-row = 3,
                   Str :$empty = '  ',
                   Bool :t(:$transposed) = False) {

    # Process months specs
    $months = process-month-specs($months);

    die "The months argument is expected to be Whatever, a list of month names or integers between 1 and 12, or a list of year-month pairs."
    unless $months>>.value.all ~~ UInt:D && ([&&] $months>>.value.map({ 1 ≤ $_ ≤ 12 }));

    return calendar-rows($months, :$per-row, :$empty, :$transposed);
}

multi sub calendar-rows(@months is copy where @months.all ~~ Pair:D,
                        UInt :$per-row = 3,
                        Str :$empty = '  ',
                        Bool :t(:$transposed) = False) {

    # Make rows of month blocks
    my @month-strs;
    for @months.kv -> $i, $p {
        my $weekdays = !$transposed || $i mod $per-row == 0;
        @month-strs[$i + 1] = [calendar-month-block($p.key, $p.value, :$empty, :$transposed, :$weekdays).lines]
    };

    my @C = '';
    for 1, 1 + $per-row ... @months.elems -> $month {
        while @month-strs[$month] {
            for ^$per-row -> $column {
                @C[*- 1] ~= @month-strs[$month + $column].shift ~ ' ' x 3 if @month-strs[$month + $column];
            }
            @C.push: '';
        }
        @C.push: '';
    }

    my $res = @C.join: "\n";

    return $res;
}

#==========================================================
#| A shortcut for calendar
#| - C<$year> : Year of the calendar. Defaults to Whatever.
#| - C<UInt :$per-row> : Determines how many calendars are displayed per row in the output. Defaults to 3.
#| - C<Bool :t(:$transposed)> : If set to C<True>, transposes the layout of the calendar. Defaults to C<False>.
proto calendar-year(|) is export {*}

multi sub calendar-year($year is copy = Whatever, UInt :$per-row = 3, Bool :t(:$transposed) = False) {
    if $year.isa(Whatever) { $year = Date.today.year; }
    return calendar-year(:$year, :$per-row, :$transposed);
}

multi sub calendar-year(:$year, UInt :$per-row = 3, Bool :t(:$transposed) = False) is export {
    my $header = ' ' x 30 ~ $year;
    return $header ~ "\n\n" ~ calendar($year, 1 .. 12, :$per-row, :$transposed);
}