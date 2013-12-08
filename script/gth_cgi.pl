#!/usr/bin/perl -w

use lib qw[
  /home/hhunter/local/lib/perl5
  /home/hhunter/local/share/perl/5.8.8
  /home/hhunter/local/lib/perl/5.8.8
  /home/hhunter/local/share/perl/5.8.4
  /home/hhunter/local/lib/perl/5.8.4
  /home/hhunter/local/lib

  /home/hhunter/api.gth.am/public_html/lib
];

BEGIN { $ENV{CATALYST_ENGINE} ||= 'CGI' }

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Gth;

Gth->run;

1;

=head1 NAME

gth_cgi.pl - Catalyst CGI

=head1 SYNOPSIS

See L<Catalyst::Manual>

=head1 DESCRIPTION

Run a Catalyst application as a cgi script.

=head1 AUTHORS

Catalyst Contributors, see Catalyst.pm

=head1 COPYRIGHT


This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
