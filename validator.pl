#!/usr/bin/perl

use strict;
use XML::LibXML;

my ($FIX) = $ENV{'FIX'} || 0;
my ($schema, $parser, $file, $xml, $doc, @err, $err);
$file = shift (@ARGV);
open (TEMP, '>&STDERR');
open (STDERR, '> /dev/null');
eval { $schema = XML::LibXML::Schema->new (location => $file) };
if ($@) {
    die ($@);
}
open (STDERR, '>&TEMP');
$parser = XML::LibXML->new;
while ($file = shift (@ARGV)) {
    if (!open (FIN, $file)) {
        die ("failed to open $file; $!");
    }
    $xml = join ('', <FIN>);
    close (FIN);
    if ($FIX) {
#       Checking pages
        if ($xml =~ m/<pages>([^<]*)<\/pages>/s) {
            my ($p) = $1;

            if (($p !~ m/^[0-9]+$/) && ($p !~ m/^[0-9]+-[0-9]+/)) {
                $p =~ s/p?p\.//g;
                $p =~ s/\s+//g;
                if (($p =~ m/^[0-9]+$/) || ($p =~ m/^[0-9]+-[0-9]+/)) {
                    $xml =~ s/<pages>([^<]*)<\/pages>/<pages>$p<\/pages>/s;
                } else {
                    print (STDERR "=== pages: $p\n");
                }
            }
        }
#       Checking vol
        if ($xml =~ m/<vol>([^<]*)<\/vol>/s) {
            my ($p) = $1;

            if ($p !~ m/^[0-9]+$/) {
#               if ($p =~ m/^[0-9]+$/) {
#                   $xml =~ s/<pages>([^<]*)<\/pages>/<pages>$p<\/pages>/s;
#               } else {
                    print (STDERR "=== vol: $p\n");
#               }
            }
        }
#       Checking issue
        if ($xml =~ m/<issue>([^<]*)<\/issue>/s) {
            my ($p) = $1;

            if ($p !~ m/^[0-9]+$/) {
#               if ($p =~ m/^[0-9]+$/) {
#                   $xml =~ s/<pages>([^<]*)<\/pages>/<pages>$p<\/pages>/s;
#               } else {
                    print (STDERR "=== issue: $p\n");
#               }
            }
        }
    } # if FIX
    $doc = $parser->parse_string ($xml);
    eval { $schema->validate ($doc) };
    @err = ();
    foreach $err (split ("\n", $@)) {
        if ($err =~ m/'language'.*The value '[a-z]{3}' is not valid/) {
            next;
        }
        push (@err, $err);
    }
    my ($org) = {};
    my ($org_used) = {};
    while ($xml =~ s/<organisation [^>]*aff_no="([0-9]+)"//s) {
        $org->{$1} = 1;
    }
    while ($xml =~ s/<person [^>]*aff_no="([0-9]+)"//s) {
        if ($org->{$1}) {
            $org_used->{$1} = 1;
        } else {
            push (@err, "person aff_no=$1 does not match any organisation");
        }
    }
    foreach $err (keys (%{$org})) {
        if (!$org_used->{$err}) {
            push (@err, "organisation aff_no=$1 not used by any person");
        }
    }
    if (@err) {
        print (STDERR "--- $file:\n");
        foreach $err (@err) {
            print (STDERR "    $err\n");
        }
    } else {
        print (STDERR "+++ $file validated successfully\n");
    }
}
