#!/usr/bin/perl

$xsd = $ARGV[0];
if (!-e $xsd) {
    die ("usage: $0 <schema-file>\n");
}
if (!open (FIN, $xsd)) {
    die ("fatal: cannot open $xsd ($!)\n");
}
$xml = join ('', <FIN>);
close (FIN);
&stylesheet_start ();
$templates = {};
&get_elements ([], $templates, $xml, $xml);
foreach $tn (sort (keys (%{$templates}))) {
    &template_start ($tn);
    print ($templates->{$tn});
    &template_end ();
}
&stylesheet_end ();

sub get_types
{
    my ($xml, $name) = @_;
    my ($ret, $n);

    if ($xml =~ m/<complexType[^>]*name="$name"[^>]*>(.*?)<\/complexType>/s) {
        $ret = $1;
        while (1) {
            $n += s/(<complexType)/$1/g;
            $n -= s/(<\/complexType)/$1/g;
            if ($n > 0) {
                $xml = m/(.*?)<\/complexType>/s;
                $ret .= '</complexType>' . $1;
            } else {
                last;
            }
        }
    }
    return ($ret);
}

sub get_elements
{
    my ($path, $templates, $xml, $xo) = @_;
    my ($x, $xs, $name, $type, $tn);

    $tn = '/' . join ('/', @{$path});
    $xml =~ s/<complexType[^>]*name=[^>]*>(.*?)<\/complexType>//sg;
    while ($xml =~ s/<element([^>]*)>//s) {
        $x = $1;
        $name = $type = '';
        if ($x =~ /name="([^"]+)"/) {
            $name = $1;
            push (@{$path}, $name);
            if ($tn eq '/') {
                $templates->{$tn} .= "<xsl:apply-templates select=\"*\"/>\n";
            } else {
                $templates->{$tn} .= "<xsl:apply-templates select=\"$name\"/>\n";
            }
        }
        if ($x =~ /type="([^"]+)"/) {
            $type = $1;
            $x = &get_types ($xo, $type);
            if (!defined ($x)) {
                $type =~ s/^.*://;
                $x = &get_types ($xo, $type);
            }
            if (defined ($x)) {
                &get_attributes ($path, $templates, $x);
                &get_elements ($path, $templates, $x, $xo);
            }
        }
        pop (@{$path});
    }
}

sub get_attributes
{
    my ($path, $templates, $xml) = @_;
    my ($x, $tn);

    $tn = '/' . join ('/', @{$path});
    $xml =~ s/<complexType[^>]*name=[^>]*>(.*?)<\/complexType>//sg;
    while ($xml =~ s/<attribute([^>]*)>//s) {
        $x = $1;
        if ($x =~ /name="([^"]+)"/) {
            $templates->{$tn} .=  "<xsl:apply-templates select=\"\@$1\"/>\n";
        }
    }
}

sub stylesheet_start
{
    print <<EOT; 
<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="no" encoding="UTF-8"/>

EOT
}

sub stylesheet_end
{
    print <<EOT; 
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
EOT
}

sub template_start
{
    my ($match) = @_;

    print <<EOT; 
    <xsl:template match="$match">
        <xsl:copy>
EOT
}

sub template_end
{
    print <<EOT; 
        </xsl:copy>
    </xsl:template>
EOT
}
