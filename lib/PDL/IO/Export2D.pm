package PDL::IO::Export2D;

use 5.006000;

use strict;
use warnings;

our $VERSION = 0.010;
$VERSION = eval $VERSION;

use Carp;
use PDL;

my $method_name = 'export2d';

sub import {
  my $module_name = shift;

  if (@_) {
    $method_name = shift;
  }

  # Check to see if PDL already has a method by the same name
  carp <<MESSAGE if PDL->can($method_name);
PDL already provides a method named '$method_name', read the $module_name documentation to learn to avoid this conflict.
MESSAGE

  # Push method into the PDL namespace
  no strict 'refs';
  *{'PDL::' . $method_name} = \&export2d;
}


sub export2d {
  my ($pdl, $fh, $sep);
  $pdl = shift;
  unless (ref $pdl eq 'PDL') {
    carp "cannot call $method_name without a piddle input";
    return 0;
  }
  unless ($pdl->ndims == 2) {
    carp "$method_name may only be called on a 2D piddle";
    return 0;
  }

  # Parse additional input parameters
  while (@_) {
    my $param = shift;
    if (ref $param eq 'GLOB') {
      $fh = $param;
    } else {
      $sep = $param;
    }
  }

  # Extract columns from piddle
  my @params = map {$pdl->slice("($_),")} (0..$pdl->dim(0)-1);
  my $num_cols = @params;

  # Push additional parameters for wcols
  push @params, $fh if (defined $fh); 
  push @params, {Colsep => $sep} if (defined $sep);

  # Write columns
  wcols @params;

  return $num_cols;
}

1;

__END__
__POD__
=head1 NAME

Export2D

=head1 SYNOPSIS

 use PDL;
 use PDL::IO::Export2D;

 my $pdl = rvals(6,4);

 open my $fh, '>', 'file.dat';
 $pdl->export2d($fh);

=head1 DESCRIPTION

Provides a convenient method for exporting a 2D piddle. C<export2d> is a wrapper around the standard C<PDL> method C<wcols> for exporting the entire piddle. The author was tired of having to extract the columns just to write them all to a file, and so set off to provide a solution. 

=head1 PROVIDED METHOD

=head2 export2d

 $pdl->export2d($fh, ',');

C<export2d> may be called without any options. All default arguments will be used (print to STDOUT with a space as a column separator). It may also take a lexical filehandle or bareword filehandle reference (e.g. C<\*FILE>, N.B. the method checks for a globref). Also the method may take a string as a column separator. The order does not matter, the method will determine whether an argument refers to a file or not. In this way one may call either

 $pdl->export2d($fh);
 $pdl->export2d(',');

and it will do what you mean. Unfortunately this means that unlike C<wcols> one cannot use a filename rather than a filehandle; C<export2d> would interpret the string as the column separator!

The method returns the number of columns that were written.

=head1 CONFLICT AVOIDANCE

The method is pushed into the C<PDL> namespace. Should C<PDL> ever provide method of the same name, this module will override it, warning with both the standard Perl redefinition warning as well as an additional message from the package. To avoid a conflict a different method name may be passed when loading the module. For example:

 use Export2D 'my_export';

causing the method provided by this module to be called as 

 $pdl->my_export

rather than the default name C<export2d>.

=head1 AUTHOR

Joel Berger, E<lt>joel.a.berger@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Joel Berger

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.1 or,
at your option, any later version of Perl 5 you may have available.


=cut