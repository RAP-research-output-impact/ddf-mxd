#!/usr/bin/perl -w

our $xmllint   = '/usr/bin/xmllint';
our $schema    = 'MXD_ddf_doc.xsd';
our $chunksize = 100;  # files per commandline call

#################################
use Data::Dumper;
#use IO::Handle;
use POSIX qw(floor ceil);

my @files = <>;
for(my $i= 0; $i <= $#files; $i++) {
  chomp $files[$i];
}
my $chunks = ceil(@files / $chunksize);

for(my $i=0; $i < $chunks; $i++) {
  my %ret;
  my $base = $i * $chunksize;
  # prevent reaching over the top, will cause undefs in chunking
  my $top = $i == $chunks-1 ? $#files : $base+$chunksize+1;
  my @batch = @files[$base .. $top];
  check(\%ret, @batch);

  print STDERR "Done chunk ", $i+1, " of $chunks\n";
  # Only problem with hashes is, the order get mangled.
  foreach my $fn (@batch) {
    next unless exists $ret{$fn};
    print "$fn\n";
    foreach my $err (@{$ret{$fn}}) {
      print "  $err\n";
    }
  }
}


sub check
{
  my($hash, @files) = @_;
  my $args = join(' ', @files);

  my @res = `$xmllint --noout --schema $schema $args 2>&1`;
  while(my $l = shift @res) {
    chomp $l;
    # ignore bogus xs:language errors for 3-char languages
    next unless $l =~ /validity error/i && $l !~ /not a valid value of the atomic type 'xs:language'/i;
    my($file) = $l =~ /^(.+?):/;
    push(@{$hash->{$file}}, $l);
  }
  return $hash;
}
