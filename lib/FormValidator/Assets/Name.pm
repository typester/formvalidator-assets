package FormValidator::Assets::Name;
use Moose;

use overload q{""} => sub { shift->name };

has 'name'  => ( is => 'ro', required => 1 );
has 'rules' => ( is => 'rw', default => sub { [] } );

sub BUILD {
    my ($self, $args) = @_;

    push @{ $self->rules }, $_ for @{ $args->{use_rules} || [] };
}

1;
