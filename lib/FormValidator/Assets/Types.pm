package FormValidator::Assets::Types;
use Moose;
use Moose::Util::TypeConstraints;

use Path::Class::Dir;

subtype 'AssetsDir'
    => as 'Object'
    => where { $_->isa('Path::Class::Dir') && -e $_ && -d _ };

coerce 'AssetsDir'
    => from 'Str'
       => via { Path::Class::Dir->new($_) }
    => from 'ArrayRef'
       => via { Path::Class::Dir->new(@{ $_ }) };


1;

