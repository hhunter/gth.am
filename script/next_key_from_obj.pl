#!/usr/bin/perl -w
use strict;

use FindBin qw/ $Bin /;
use lib "$Bin/../lib";

use Data::Dumper;
use Gth::ShortURL;

my $gth = Gth::ShortURL->new();

my $i = 0;
while ($i < 10) {
  warn $gth->next_key();
  $i++;
}


