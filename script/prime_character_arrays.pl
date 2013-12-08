#!/usr/bin/perl -w

my @valid = ('A'..'Z','a'..'z',0..9);

for (my $i = 1; $i <= 10; $i++) {
    my @valid = @valid;
    while (scalar @valid > 0) {
        my $r = rand(scalar @valid);
        print $valid[$r];
        @valid = grep { !/^$valid[$r]$/ } @valid;
    }
    print "\n";
}
