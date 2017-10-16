package slots;

use strict;
use warnings;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

sub import {
    shift;
    my $class = caller(0);
    my %slots = @_;
    {
        no strict   'refs';
        no warnings 'once';
        %{ $class.'::HAS' } = ((map %{$_.'::HAS'}, @{$class.'::ISA'}), %slots);
    }
}

1;

__END__

=pod

=cut
