#!/usr/bin/perl

our $indent1 = " " x 4;
our $indent2 = " " x 8;
our $indent3 = " " x 12;

$xsd = $ARGV[0];
if (!-e $xsd) {
    die ("usage: $0 <schema-file>\n");
}
if (!open (FIN, $xsd)) {
    die ("fatal: cannot open $xsd ($!)\n");
}
$xml = join ('', <FIN>);
close (FIN);
if (&stylesheet_start ($xml)) {
    $UseNS = 1;
}
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
                $templates->{$tn} .= "$indent3<xsl:apply-templates select=\"*\"/>\n";
            } else {
                if ($UseNS) {
                    if ($name =~ m/^[0-9A-Za-z]/) {
                        $name = 'mx:' . $name;
                    }
                    $name =~ s/\/([0-9A-Za-z])/\/mx:$1/g;
                }
                $templates->{$tn} .= "$indent3<xsl:apply-templates select=\"$name\"/>\n";
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
            $templates->{$tn} .=  "$indent3<xsl:apply-templates select=\"\@$1\"/>\n";
        }
    }
    $templates->{$tn} .=  "$indent3<xsl:apply-templates select=\"\@xml:lang\"/>\n";
    $templates->{$tn} .=  "$indent3<xsl:apply-templates select=\"text()\"/>\n";
}

sub stylesheet_start
{
    my ($xml) = @_;
    my ($ns);

    if ($xml =~ m/<schema [^>]*targetNamespace="([^"]+)"/) {
        $ns = " xmlns:mx=\"$1\"";
    }
    print <<EOT; 
<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"$ns version="1.0">

    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="no" encoding="UTF-8"/>

EOT
    return ($ns);
}

sub stylesheet_end
{
    print <<EOT; 
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | text()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
EOT
}

sub template_start
{
    my ($match) = @_;

    if ($UseNS) {
        if ($match =~ m/^[0-9A-Za-z]/) {
            $match = 'mx:' . $match;
        }
        $match =~ s/\/([0-9A-Za-z])/\/mx:$1/g;
    }
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
