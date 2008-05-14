package FormValidator::Assets::Field;
use Moose;

extends 'FormValidator::Assets::Component';

use overload q{""} => sub { shift->field };

has 'field'     => ( is => 'ro', required => 1 );
has 'rules'     => ( is => 'rw', default => sub { [] } );
has 'filters'   => ( is => 'rw', default => sub { [] } );
has 'rule_args' => ( is => 'rw', default => sub { {} } );

1;
