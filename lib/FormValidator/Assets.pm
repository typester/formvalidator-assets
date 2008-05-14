package FormValidator::Assets;
use 5.008001;

use Moose;

use Digest::MD5 qw/md5_hex/;

use FormValidator::Assets::Types;

use FormValidator::Assets::Field;
use FormValidator::Assets::Rule;
use FormValidator::Assets::Filter;
use FormValidator::Assets::Bundle;

use FormValidator::Assets::Result;

our $VERSION = '0.000001';

has assets_dir => (
    is       => 'rw',
    isa      => 'AssetsDir',
    required => 1,
    coerce   => 1,
);

has fields  => ( is => 'rw', isa => 'HashRef', default => sub { {} } );
has rules   => ( is => 'rw', isa => 'HashRef', default => sub { {} } );
has filters => ( is => 'rw', isa => 'HashRef', default => sub { {} } );
has bundles => ( is => 'rw', isa => 'HashRef', default => sub { {} } );

__PACKAGE__->meta->make_immutable;

sub BUILD {
    my ($self, $args) = @_;
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

        $code;

        1;
    };
    confess $@ if $@;

    $pkg->load($self);
}

sub load_yaml {
    my ($self, $yaml) = @_;

    die; # TODO
}

sub setup {
    my ($self, $asset) = @_;

    my $attr = $asset->attr;
    $attr->{context} = $self;

    $self->setup_field($attr)  if $attr->{field};
    $self->setup_rule($attr)   if $attr->{rule};
    $self->setup_filter($attr) if $attr->{filter};
    $self->setup_bundle($attr) if $attr->{bundle};

    $self->setup_isa;
}

sub setup_field {
    my ($self, $attr) = @_;

    my $field = FormValidator::Assets::Field->new($attr);
    $self->fields->{ $field } = $field;
}

sub setup_rule {
    my ($self, $attr) = @_;

    my $rule = FormValidator::Assets::Rule->new($attr);
    $self->rules->{ $rule } = $rule;
}

sub setup_filter {
    my ($self, $attr) = @_;

    my $filter = FormValidator::Assets::Filter->new($attr);
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

    my $result = FormValidator::Assets::Result->new( context => $self, input => $q );
    $result->process( @rest );
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
