#!/usr/bin/perl -w

our $xmllint   = '/usr/bin/xmllint';
our $schema    = 'MXD_ddf_doc.xsd';
our $chunksize = 100;  # files per commandline call

#################################
use Data::Dumper;
#use IO::Handle;
use POSIX qw(floor ceil);

my @files = <>;
for(my $i= 0; $ < $#files; $i++) {
  chomp $files[$i];
}
my $chunks = ceil(@files / $chunksize);
while(my $file = <>) {
  chomp $file;
  if(my @err = check($file)) {
    print "---$file\n";
    print join("\n", @err, "\n");
  } else {
    print "+++$file\n";
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
    my($file) = $l =~ /^(.+): /;
    push(@{$hash->{$file}}, $l);
  }
  return $hash;
}
