package Gth::MongoDB;

use warnings;
use strict;

use Data::Dumper;
use MongoDB;

use constant BASE => 62;

my $cxn;
my $db;
my %collections;

$db or do {
  $cxn = MongoDB::Connection->new(
    host => 'localhost',
    port => 27017,
  );
  $db = $cxn->get_database('gth');
};

sub new {
  my $class = shift;

  my $self = bless {}, $class;
  return $self;
}

sub conf {
  my $self = shift;
  $collections{conf} ||= $db->get_collection('conf');
  return $collections{conf};
}

sub urls {
  my $self = shift;
  $collections{urls} ||= $db->get_collection('urls');
  return $collections{urls};
}

sub stats {
  my $self = shift;
  $collections{stats} ||= $db->get_collection('stats');
  return $collections{stats};
}

1;
