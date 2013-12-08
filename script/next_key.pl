#!/usr/bin/perl -w
use strict;

use Data::Dumper;

use constant BASE => 62;

my @char = qw(
  gUJk4voitZduK29aAw1CVPbxjHTFBShDNmpO3lMf8ncyqs5EGL0eQIRzrXYW76
  wtWdXUYOEa6HAKvjQlmfozugMDGk3iNnc1pV805FT2yRbI4eBC9ZSLrs7JqPxh
  3sMld7UNCQRLakW1oBheAIpKEirYz0SxwtujVqDZ4FgmO5n9ybHPfcT682XGvJ
  emxLWoGnAPvXyMwtYzqT4bhODUrf3sjBd67Slg9IpF0ZiVHR2uCk85caEJQ1KN
  2Ucw8CTqtGQBAdp0aHzNPyRIYDlnSXWOf5M97hJ43Lm6VbixgZeFuj1EovrksK
  hUzNkMt9dgjypIHC5caKfF7BOEPbZi0sRx6Xq4lQ1JTDnmGYo3vLWeAwSurV82
  a85Gc9qvChoWARHwijDM6dKUyt3egsLZzmpxIlXFbNT2PV1QS7kuE4fnOYB0Jr
  FSJvYR0PBWDKyxpw5VXO8uieZUfEsLtIzM2m7rNQk4Hjc1hA9ao6nqlTg3CGbd
  oyaRqUPChpf4meXkQ6Mt7uLWF813N5YIKbZJjxgDHE2vTirwGcndSs0OlV9zAB
  Al7w8teJEcVWgaYi1UhBprmzT46uDnxFKGdPIqjRXkMC9O2fHosy35S0vZbQNL
);

my $URL_LENGTH = 3;

my @base  = (BASE) x $URL_LENGTH;
#my $index = BASE * BASE * BASE * BASE - 10;
my @index = (0) x $URL_LENGTH;

my $char_array = [ map { [ split '', $_ ] } @char ];

warn Dumper \@char;

my $i = 0;
while ($i < 10) {
  warn next_key();
  $i++;
}

sub next_key {
  my $key = join('', 
    map { $char_array->[$_]->[$index[$_]] } (0 .. scalar @index - 1)
  );
  _increment_indices();
  return $key;
}

sub _increment_indices {
  for (my $i = 1; $i <= scalar @index; $i++) {
    if ($index[-($i)] < BASE - 1) {
      $index[- $i] += 1;
      return;
    } else {
      $index[- $i] = 0;
    }
  }

  # still here, time to add an additional character
  $URL_LENGTH++;
  push @base, BASE;
  push @index, 0;
}

