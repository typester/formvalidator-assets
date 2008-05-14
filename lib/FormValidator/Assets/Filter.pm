package FormValidator::Assets::Filter;
use Moose;

extends 'FormValidator::Assets::Component';

use overload q{""} => sub { shift->filter };

has 'filter'  => ( is => 'ro', required => 1 );
has 'process' => ( is => 'ro', required => 1 );

1;
