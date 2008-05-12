package FormValidator::Assets;

use Moose;
use Digest::MD5 qw/md5_hex/;

use FormValidator::Assets::Types;

use FormValidator::Assets::Name;
use FormValidator::Assets::Rule;
use FormValidator::Assets::Bundle;

use FormValidator::Assets::Result;

our $VERSION = '0.000001';

has 'assets_dir' => (
    is       => 'rw',
    isa      => 'AssetsDir',
    required => 1,
    coerce   => 1,
);

has 'names'   => ( is => 'rw', default => sub { {} } );
has 'rules'   => ( is => 'rw', default => sub { {} } );
has 'bundles' => ( is => 'rw', default => sub { {} } );

sub BUILD {
    my ($self, $args) = @_;

    confess "Directory $self->{assets_dir} does not exists"
        unless -e $self->assets_dir && -d _;

    $self->load_assets;
}

sub load_assets {
    my $self = shift;
    $self->assets_dir->recurse( callback => sub { $self->load_asset(shift) } );
}

sub load_asset {
    my ($self, $asset) = @_;

    return unless -f $asset && -r _;

    my @loaders = (
        [qr/\.pl$/, 'load_perl' ],
        [qr/\.ya?ml$/, 'load_yaml' ],
    );

    my ($loader) = map { $_->[1] } grep { $asset =~ $_->[0] } @loaders;
    $self->$loader($asset) if $loader;
}

sub load_perl {
    my ($self, $script) = @_;

    my $root = join '::', $self->assets_dir->dir_list;
    my $ns   = join '::', $script->parent->dir_list, $script->basename;
    $ns =~ s/(^$root|\.pl$)//g;

    $ns = md5_hex($root) . $ns;

    my $pkg  = "FormValidator::Assets::Script::$ns";
    my $code = $script->slurp;

    eval qq{
        package $pkg;
        use FormValidator::Assets::Script;

        $code

        1;
    };
    confess $@ if $@;

    $pkg->load($self);
}

sub load_yaml {
    my ($self, $yaml) = @_;

    
}

sub setup {
    my ($self, $asset) = @_;

    my $attr = $asset->attr;

    $self->setup_name($attr) if $attr->{name};
    $self->setup_rule($attr) if $attr->{rule};
    $self->setup_bundle($attr) if $attr->{bundle};

    $self->setup_isa;
}

sub setup_name {
    my ($self, $attr) = @_;

    my $name = FormValidator::Assets::Name->new($attr);
    $self->names->{ $name } = $name;
}

sub setup_rule {
    my ($self, $attr) = @_;

    my $rule = FormValidator::Assets::Rule->new($attr);
    $self->rules->{ $rule } = $rule;
}

sub setup_bundle {
    my ($self, $attr) = @_;

    my $bundle = FormValidator::Assets::Bundle->new($attr);
    $self->bundles->{ $bundle } = $bundle;
}

sub setup_isa {
    # orz
}

sub bundle {
    my ($self, $bundle) = @_;

    $bundle = $self->bundles->{ $bundle } or confess 'no such bundles';

    $self->{bundle} = $bundle;
    $self;
}

sub process {
    my ($self, $q, @rest) = @_;

    my $result = FormValidator::Assets::Result->new( input => $q );

    my @params;
    if ($self->{bundle}) {
        @params = @{ $self->{bundle}->names };
    }
    else {
        @params = $q->param;
    }

    for my $param (@params) {
        my $name = $self->names->{$param} or next;

        my $invalid;
        for my $rule (@{ $name->rules }) {
            $rule = $self->rules->{ $rule } or next;

            my ($code, $params) = @{ $rule->process };
            $invalid++ unless $rule->{process}->[0]->( $q->param($param),  );
        }

        if ($invalid) {
            $result->invalid_fields->{ $param }++;
        }
        else {
            $result->valid_fields->{ $param }++;
        }
    }

    $result;
}

=head1 NAME

FormValidator::Assets - Module abstract (<= 44 characters) goes here

=head1 SYNOPSIS

  use FormValidator::Assets;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for this module was created by ExtUtils::ModuleMaker.
It looks like the author of the extension was negligent enough
to leave the stub unedited.

Blah blah blah.

=head1 AUTHOR

Daisuke Murase <typester@cpan.org>

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut

1;
