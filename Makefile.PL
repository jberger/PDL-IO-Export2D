use 5.006000;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'PDL::IO::Export2D',
    VERSION_FROM      => 'lib/PDL/IO/Export2D.pm', # finds $VERSION
    PREREQ_PM         => {PDL => 0, 'Scalar::Util' => 0}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT  => 'Provides a convenient method for exporting a 2D piddle.',
       AUTHOR         => 'Joel Berger <joel.a.berger@gmail.com>') : ()),
    BUILD_REQUIRES    => {
    	'Capture::Tiny'	=> 0,
    	'Test::More'	=> 0,
    },
);
