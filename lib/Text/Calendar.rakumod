use v6.d;

# The code for calendar-month-block and calendar-year
# from https://rosettacode.org/wiki/Calendar#Raku
# Further modifications were done.

unit module Text::Calendar;

my @weekday-names = <Mo Tu We Th Fr Sa Su>;
my @month-short-names = <Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec>;
my @month-names = <January February March April May June July August September October November December>;
my %month-names = @month-names Z=> 1 .. 12;
%month-names = %month-names, %( @month-short-names Z=> 1 .. 12);
%month-names = %month-names.map({ $_.key.lc => $_.value });

#----------------------------------------------------------
proto calendar-month-block(|) is export {*}

multi sub calendar-month-block($year = Whatever, $month = Whatever) {
    return calendar-month-block(:$year, :$month);
}

multi sub calendar-month-block(:$year is copy = Whatever, :$month is copy = Whatever) {

    # Process year
    if $year.isa(Whatever) { $year = Date.today.year; }

    die 'The argument $year is expected to be an interger or Whatever.'
    unless $year ~~ Int:D;

    # Process month
    if $month.isa(Whatever) { $month = Date.today.month; }
    if $month ~~ Str:D { $month = %month-names{$month} // 0 }

    die 'The argument $month is expected to be a month name, an interger between 1 and 12, or Whatever.'
    unless $month ~~ Int:D && 1 ≤ $month ≤ 12;

    my $date = Date.new($year, $month, 1);
    my $res = @month-names[$month - 1].fmt("%-20s\n") ~ @weekday-names ~ "\n" ~
            (('  ' xx $date.day-of-week - 1),
             (1 .. $date.days-in-month)».fmt('%2d')).flat.rotor(7, :partial).join("\n") ~
            (' ' if $_ < 7) ~ ('  ' xx 7 - $_).join(' ') given Date.new($year, $month, $date.days-in-month).day-of-week;

    return $res;
}

#----------------------------------------------------------

sub three-months(Int $year, UInt $month) {
    my @months = $year X=> (($month - 1) ... ($month + 1));
    @months[0] = @months[0].value == 0 ?? (($year - 1) => 12) !! @months[0];
    @months[2] = @months[2].value == 13 ?? (($year + 1) => 1) !! @months[2];

    return @months;
}

#----------------------------------------------------------
proto calendar(|) is export {*}

multi sub calendar($year is copy, $months is copy, UInt :$per-row = 3) {

    if $year.isa(Whatever) { $year = Date.today.year; }

    if $months.isa(Whatever) {
        $months = three-months($year, Date.today.month);
    } elsif $months ~~ Iterable {
        $months = ($year X=> $months.Array).cache;
    } elsif $months ~~ Str:D || $months ~~ Int:D {
        $months = [$year => $months,]
    }

    calendar($months, :$per-row);
}

multi sub calendar($months is copy = Whatever, UInt :$per-row = 3) {

    # Process months specs
    given $months {
        when Whatever {
            $months = three-months(Date.today.year, Date.today.month);
        }

        when $_ ~~ Iterable && $_.map({ $_ ~~ UInt:D || $_ ~~ Str:D }) {
            $months .= map({ $_ ~~ Str:D ?? %month-names{$_.lc} !! $_ });
            $months = Date.today.Year => $months.Array;
        }

        when $_.all ~~ Pair:D {
        }

        default {
            $months = [-1];
        }
    }

    die "The first argument is expected to be Whatever, a list of month names or integers between 1 and 12, a list of year-month pairs."
    unless $months>>.value.all ~~ UInt:D && ([&&] $months>>.value.map({ 1 ≤ $_ ≤ 12 }));

    return calendar-rows($months, :$per-row);
}

multi sub calendar-rows(@months is copy where @months.all ~~ Pair:D, UInt :$per-row = 3) {

    # Make rows of month blocks
    my @month-strs;
    for @months.kv -> $i, $p {
        @month-strs[$i + 1] = [calendar-month-block($p.key, $p.value).lines]
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

    return @C.join: "\n";
}

#----------------------------------------------------------
proto calendar-year(|) is export {*}

multi sub calendar-year($year is copy = Whatever, UInt :$per-row = 3) {
    if $year.isa(Whatever) { $year = Date.today.year; }
    return calendar-year(:$year, :$per-row);
}

multi sub calendar-year(:$year, UInt :$per-row = 3) is export {
    my $header = ' ' x 30 ~ $year;
    return $header ~ "\n\n" ~ calendar($year, 1 .. 12, :$per-row);
}