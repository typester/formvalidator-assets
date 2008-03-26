package FormValidator::Assets::Script;
use strict;
use warnings;

require Class::Data::Inheritable;

sub import {
    my $caller = caller(0);

    my @scalar = qw/name rule bundle/;
    my @list   = qw/use_rules no_rules extends names/;
    my @code   = qw/process/;

    {
        no strict 'refs';
        push @{"$caller\::ISA"}, 'Class::Data::Inheritable';
        $caller->mk_classdata( attr => {} );

        my $attr = $caller->attr;
        $attr->{class} = $caller;

        for my $method (@scalar) {
            *{"$caller\::$method"} = sub ($) { $attr->{$method} = shift };
        }

        for my $method (@list) {
            *{"$caller\::$method"} = sub (@) { push @{$attr->{$method}}, @_ };
        }

        for my $method (@code) {
            *{"$caller\::$method"} = sub (&;@) { $attr->{$method} = \@_ };
        }

        *{"$caller\::load"} = \&load;
    }
}

sub load {
    my ($class, $context) = @_;
    $context->setup($class);
}

1;
