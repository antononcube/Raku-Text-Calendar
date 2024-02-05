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

#==========================================================
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
    unless $year ~~ Int:D;

    # Process month
    if $month.isa(Whatever) { $month = Date.today.month; }
    if $month ~~ Str:D { $month = %month-names{$month} // 0 }

    die 'The argument $month is expected to be a month name, an interger between 1 and 12, or Whatever.'
    unless $month ~~ Int:D && 1 ≤ $month ≤ 12;

    my $date = Date.new($year, $month, 1);
    my $res = @month-names[$month - 1].fmt("%-20s\n") ~ ( $weekdays ?? @weekday-names ~ "\n" !! '') ~
            (($empty xx $date.day-of-week - 1),
             (1 .. $date.days-in-month)».fmt('%2d')).flat.rotor(7, :partial).join("\n") ~
            (' ' if $_ < 7) ~ ($empty xx 7 - $_).join(' ') given Date.new($year, $month, $date.days-in-month).day-of-week;

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
    my @res2 = $res.lines.tail(*-1)>>.split(/\h/, :skip-empty).flat.map({ $_.chars == 1 ?? " $_" !! $_}).rotor(7)>>.Array;

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

sub three-months(Int $year, UInt $month) {
    my @months = $year X=> (($month - 1) ... ($month + 1));
    @months[0] = @months[0].value == 0 ?? (($year - 1) => 12) !! @months[0];
    @months[2] = @months[2].value == 13 ?? (($year + 1) => 1) !! @months[2];

    return @months;
}

#==========================================================
proto calendar(|) is export {*}

multi sub calendar($year is copy,
                   $months is copy,
                   UInt :$per-row = 3,
                   Str :$empty = '  ',
                   Bool :t(:$transposed) = False) {

    if $year.isa(Whatever) { $year = Date.today.year; }

    if $months.isa(Whatever) {
        $months = three-months($year, Date.today.month);
    } elsif $months ~~ Iterable {
        $months = ($year X=> $months.Array).cache;
    } elsif $months ~~ Str:D || $months ~~ Int:D {
        $months = [$year => $months,]
    }

    calendar($months, :$per-row, :$empty, :$transposed);
}

multi sub calendar($months is copy = Whatever,
                   UInt :$per-row = 3,
                   Str :$empty = '  ',
                   Bool :t(:$transposed) = False) {

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
proto calendar-year(|) is export {*}

multi sub calendar-year($year is copy = Whatever, UInt :$per-row = 3, Bool :t(:$transposed) = False) {
    if $year.isa(Whatever) { $year = Date.today.year; }
    return calendar-year(:$year, :$per-row, :$transposed);
}

multi sub calendar-year(:$year, UInt :$per-row = 3, Bool :t(:$transposed) = False) is export {
    my $header = ' ' x 30 ~ $year;
    return $header ~ "\n\n" ~ calendar($year, 1 .. 12, :$per-row, :$transposed);
}