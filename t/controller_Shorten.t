use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Gth' }
BEGIN { use_ok 'Gth::Controller::Shorten' }

ok( request('/shorten')->is_success, 'Request should succeed' );


