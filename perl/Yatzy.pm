package Yatzy;

use strict;
use warnings;
use List::Util qw(reduce);

sub chance {
    return reduce { $a + $b } @_;
}

sub yatzy {
    my (@dice) = @_;
    my $position = pop @dice;

    if (@dice == 0) {
        return 50;
    }
    if  ($position != $dice[0]){
        return 0;
    } else {
        return yatzy(@dice);
    }
}

sub group {
    my $value = shift;
    my @dices = ref($_[0]) eq 'Yatzy' ? @{ $_[0]->{dice} } : @_;
    return $value * scalar grep {$_ ==$value} @dices;
}

sub ones {
    return group(1,@_);
}

sub twos {
    return group(2,@_);
}

sub threes {
    return group(3,@_);
}

sub new {
    my $class = shift;
    my $self = { dice => \@_ };
    return bless $self, $class;
}

sub fours {
    return group(4,@_);
}

sub fives {
    return group(5,@_);
}

sub sixes {
    return group(6,@_);
}

sub counts {
    my ( $d1, $d2, $d3, $d4, $d5 ) = @_;
    my @counts = (0) x 6;
    $counts[ $d1 - 1 ]++;
    $counts[ $d2 - 1 ]++;
    $counts[ $d3 - 1 ]++;
    $counts[ $d4 - 1 ]++;
    $counts[ $d5 - 1 ]++;
    return @counts;
}

sub score_pair {
    my %counts;
    for (@_)  { $counts{$_}++ };
    for (reverse 1..6) {
        return 2*$_ if $counts{$_}>=2;
    }
    return 0;
}

sub two_pair {
    my ( $d1, $d2, $d3, $d4, $d5 ) = @_;
    my @counts = counts(@_);
    my $n     = 0;
    my $score = 0;

    for my $i ( 0 .. 5 ) {
        if ( $counts[ 6 - $i - 1 ] >= 2 ) {
            $n++;
            $score += ( 6 - $i );
        }
    }
    if ( $n == 2 ) {
        return $score * 2;
    }
    else {
        return 0;
    }
}

sub four_of_a_kind {
    my ( $_1, $_2, $d3, $d4, $d5 ) = @_;
    my @tallies = counts(@_);

    for my $i ( 0 .. 5 ) {
        if ( $tallies[$i] >= 4 ) {
            return ( $i + 1 ) * 4;
        }
    }
    return 0;
}

sub three_of_a_kind {
    my ( $d1, $d2, $d3, $d4, $d5 ) = @_;
    my @t = counts(@_);

    for my $i ( ( 0, 1, 2, 3, 4, 5 ) ) {
        if ( $t[$i] >= 3 ) {
            return ( $i + 1 ) * 3;
        }
    }
    return 0;
}

sub smallStraight {
    my @tallies = counts(@_);
    return (5 == grep { $_ == 1 } @tallies[0..4]) ? 15 : 0;
}

sub largeStraight {
    my @tallies = counts(@_);
    return (5 == grep { $_ == 1 } @tallies[1..5]) ? 20 : 0;
}

sub fullHouse {
    my ( $d1, $d2, $d3, $d4, $d5 ) = @_;
    my @tallies = counts(@_);
    my $i;
    my $_2    = 0;
    my $_2_at = 0;
    my $_3    = 0;
    my $_3_at = 0;

    for my $i ( 0 .. 5 ) {
        if ( $tallies[$i] == 2 ) {
            $_2    = 1;
            $_2_at = $i + 1;
        }
    }

    for my $i ( 0 .. 5 ) {
        if ( $tallies[$i] == 3 ) {
            $_3    = 1;
            $_3_at = $i + 1;
        }
    }

    if ( $_2 && $_3 ) {
        return $_2_at * 2 + $_3_at * 3;
    }
    else {
        return 0;
    }
}

1;
