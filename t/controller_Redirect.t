use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Gth' }
BEGIN { use_ok 'Gth::Controller::Redirect' }

ok( request('/redirect')->is_success, 'Request should succeed' );


