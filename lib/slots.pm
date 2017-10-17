package slots;
# ABSTRACT: A simple pragma for managing class slots.

use strict;
use warnings;

use MOP         ();
use Devel::Hook ();

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

sub import {
    shift;
    my $meta  = MOP::Util::GET_META_FOR( caller(0) );
    my %slots = @_;

    $meta->add_slot( $_, $slots{ $_ } )
        foreach keys %slots;

    Devel::Hook->push_UNITCHECK_hook(
        sub { MOP::Util::INHERIT_SLOTS( $meta ) }
    );
}

1;

__END__

=pod

=head1 SYNOPSIS

    package Point {
        use strict;
        use warnings;

        use parent 'UNIVERSAL::Object';
        use slots (
            x => sub { 0 },
            y => sub { 0 },
        );

        sub clear {
            my ($self) = @_;
            $self->{x} = 0;
            $self->{y} = 0;
        }
    }

    package Point3D {
        use strict;
        use warnings;

        use parent 'Point';
        use slots (
            z => sub { 0 },
        );

        sub clear {
            my ($self) = @_;
            $self->next::method;
            $self->{z} = 0;
        }
    }

=head1 DESCRIPTION

This is a very simple pragma which takes a set of key/value
arguments and assigns it to the C<%HAS> package variable of
the calling class.

This module will also detect superclasses and insure that
slots are inherited correctly, this wil occur during the
next available UNITCHECK phase.

=cut
