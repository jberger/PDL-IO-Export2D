# Tests to check behavior when using a non-standard method name

use Test::More tests => 19;
BEGIN {
  use_ok('PDL');
  my $PDL_can = PDL->can('my_test_export2d');
  use_ok('PDL::IO::Export2D', 'my_test_export2d');
  SKIP : {
    skip "PDL already provides my_test_export2d", 1 if $PDL_can;
    ok(PDL->can('my_test_export2d'), "my_test_export2d pushed into namespace");
  }
}

# Test that method carps on non-2D piddles
{
  local $SIG{__WARN__} = sub{};
  ok(! xvals(3,3,3)->my_test_export2d(), "Fails on 3d piddle");
  ok(! xvals(3)->my_test_export2d(), "Fails on 1d piddle");
}

my $pdl = xvals(5,4);

# Test for default separator (space)
{
  my $fake_file;
  open my $fh, '>', \$fake_file;
  is($pdl->my_test_export2d($fh), 5, "Write correct number of columns lexical filehandle" );

  my $test_pdl = pdl( map { [split / /, $_] }(split /\n/, $fake_file));
  ok( all( $pdl == $test_pdl ), "Write to lexical filehandle correctly");
}

# test for comma separator
{
  my $fake_file;
  open my $fh, '>', \$fake_file;
  is($pdl->my_test_export2d($fh, ','), 5, "Write correct number of columns to lexical filehandle (comma separated)" );

  my $test_pdl = pdl( map { [split /,/, $_] }(split /\n/, $fake_file));
  ok( all( $pdl == $test_pdl ), "Write to lexical filehandle correctly (comma separated)");
}

# test for comma separator (opposite order)
{
  my $fake_file;
  open my $fh, '>', \$fake_file;
  is($pdl->my_test_export2d(',', $fh), 5, "Write correct number of columns to lexical filehandle (comma separated, reversed)" );

  my $test_pdl = pdl( map { [split /,/, $_] }(split /\n/, $fake_file));
  ok( all( $pdl == $test_pdl ), "Write to lexical filehandle correctly (comma separated, reversed)");
}

# test for bareword filehandle
{
  my $fake_file;
  open FILE, '>', \$fake_file;
  is($pdl->my_test_export2d(\*FILE), 5, "Write correct number of columns to bareword filehandle reference" );
  close FILE;

  my $test_pdl = pdl( map { [split / /, $_] }(split /\n/, $fake_file));
  ok( all( $pdl == $test_pdl ), "Write to bareword filehandle reference correctly");
}

# test for bareword filehandle (comma sep)
{
  my $fake_file;
  open FILE, '>', \$fake_file;
  is($pdl->my_test_export2d(\*FILE, ','), 5, "Write correct number of columns to bareword filehandle reference (comma separated)" );
  close FILE;

  my $test_pdl = pdl( map { [split /,/, $_] }(split /\n/, $fake_file));
  ok( all( $pdl == $test_pdl ), "Write to bareword filehandle reference correctly (comma separated)");
}

# test for output to STDOUT
{
  my $fake_file;
  open my $fh, '>', \$fake_file;
  local *STDOUT = $fh;
  is($pdl->my_test_export2d(), 5, "Write correct number of columns to STDOUT (redirected)" );

  my $test_pdl = pdl( map { [split / /, $_] }(split /\n/, $fake_file));
  ok( all( $pdl == $test_pdl ), "Write to STDOUT correctly");
}

# test for output to STDOUT, comma separated
{
  my $fake_file;
  open my $fh, '>', \$fake_file;
  local *STDOUT = $fh;
  is($pdl->my_test_export2d(','), 5, "Write correct number of columns to STDOUT (redirected) (comma separated)" );

  my $test_pdl = pdl( map { [split /,/, $_] }(split /\n/, $fake_file));
  ok( all( $pdl == $test_pdl ), "Write to STDOUT correctly (comma separated)");
}

