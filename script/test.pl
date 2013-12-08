#!/usr/bin/perl -w
use strict;

use Math::String;

my $url = "abcdefghijk"; 
my $ms = new Math::String $url;
my $shurl = $ms->bstr();
print $shurl;
print "\n";
