package FormValidator::Assets::Script;
use strict;
use warnings;

require Class::Data::Inheritable;

sub import {
    my $caller = caller(0);

    {
        no strict 'refs';
        push @{"$caller\::ISA"}, 'Class::Data::Inheritable';
        $caller->mk_classdata( attr => {} );

        my $attr = $caller->attr;
        $attr->{class} = $caller;

        # field method
        {
            *{"$caller\::field"} = sub ($) {
                $attr->{field} = shift;
            };

            *{"$caller\::use_rule"} = sub ($;@) {
                my ($rule_name, @args) = @_;
                push @{ $attr->{rules} }, $rule_name;
                push @{ $attr->{rule_args}{ $rule_name } }, @args;
            };

            *{"$caller\::use_filter"} = sub ($) {
                push @{ $attr->{filters} }, shift;
            }
        }

        # rule method
        {
            *{"$caller\::rule"}    = sub ($) { $attr->{rule} = shift };
            *{"$caller\::process"} = sub (&) { $attr->{process} = shift };
            *{"$caller\::message"} = sub ($) { $attr->{message} = shift };
        }

        # filter method
        {
            *{"$caller\::filter"} = sub ($) { $attr->{filter} = shift };
            # process
        }

        # bundle method
        {
            *{"$caller\::bundle"} = sub ($) { $attr->{bundle} = shift };
            *{"$caller\::fields"} = sub (@) { $attr->{fields} = \@_ };
        }

        *{"$caller\::load"} = \&load;
    }
}

sub load {
    my ($class, $context) = @_;
    $context->setup($class);
}

1;
