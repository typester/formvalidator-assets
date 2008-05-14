package FormValidator::Assets::Component;
use Moose;

has context => (
    is       => 'ro',
    isa      => 'FormValidator::Assets',
    weak_ref => 1,
    required => 1,
);

1;

