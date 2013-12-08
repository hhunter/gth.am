package Gth::ShortURL;

use warnings;
use strict;

use Gth::MongoDB;
use Data::Validate::URI qw(is_web_uri);

use constant BASE => 62;
use constant START_LENGTH => 2;

#------------------------------------------------------------------------------
# class variables
#------------------------------------------------------------------------------

our @INDICES;
our $URL_LENGTH;
our @CHAR;
our $CHAR_ARRAY;
our $error;

#------------------------------------------------------------------------------
# public methods
#------------------------------------------------------------------------------

sub new {
  my $class = shift;

  my $self = bless {}, $class;
  
  if (! scalar @INDICES) {
    # class needs initialization
    $self->_init_class();
  }
  
  return $self;
}

sub shorten {
  my $self     = shift;
  my $long_url = shift;

  is_web_uri($long_url) or do {
    $error = "invalid uri";
    return undef;
  };

  my $db = Gth::MongoDB->new();
 
  # see if we have already shortened this url
  if(my $url = $db->urls->find_one({ long_url => $long_url })) {
    return _full_url($url->{_id});
  } else { # otherwise, create a new shortened url key
    my $key = $self->_next_key();
    $db->urls->insert({ _id => $key, long_url => $long_url });
    return _full_url($key);
  }
}

sub lengthen {
  my $self      = shift;
  my $short_url = shift; # key or absolute url
  my $opts      = shift;

  # strip off the protocol and domain name, if present
  (my $key = $short_url) =~ s/.*gth\.am\///;

  my $db = Gth::MongoDB->new();
  my $url = $db->urls->find_one({ _id => $key });

  $url or do {
    $error = 'no such shortUrl';
    return undef;
  };

  if ($opts->{log_visit}) {
    $db->stats->update({ _id => $key }, { '$inc' => { visit => 1 } }, { upsert => 1 })
  }

  return $url->{long_url};
}

#-------------------------------------------------------------------------------
# private methods
#-------------------------------------------------------------------------------

sub _full_url {
  my $input = shift;
  return sprintf("http://gth.am/%s", $input);
}

sub _init_class {
  my $self = shift;
  my $db = Gth::MongoDB->new();
  my $data = $db->conf->find_one({ _id => 'indices' });
 
  if ($data->{val}) {
    @INDICES = @{ $data->{val} };
  } else {
    @INDICES = (0) x START_LENGTH;
    my $id = $db->conf->insert({ _id => 'indices', val => \@INDICES });
  }

  $URL_LENGTH = scalar @INDICES;
  @CHAR = qw(
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

  $CHAR_ARRAY = [ map { [ split '', $_ ] } @CHAR ];
}

sub _next_key {
  my $self = shift;
  my $key = join('', 
    map { $CHAR_ARRAY->[$_]->[$INDICES[$_]] } (0 .. scalar @INDICES - 1)
  );
  $self->_increment_indices();
  return $key;
}

sub _increment_indices {
  my $self = shift;
  my $db = Gth::MongoDB->new();
  for (my $i = 1; $i <= scalar @INDICES; $i++) {
    if ($INDICES[-($i)] < BASE - 1) {
      $INDICES[- $i] += 1;
      $db->conf->update({ _id => 'indices' }, { val => \@INDICES });
      return;
    } else {
      $INDICES[- $i] = 0;
    }
  }

  # still here, time to add an additional character
  $URL_LENGTH++;
  push @INDICES, 0;
  $db->conf->update({ _id => 'indices' }, { val => \@INDICES });
}

1;
