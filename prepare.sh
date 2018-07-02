#!/bin/bash

# Prepare a new distribution that can be copied to
# the website
# mx.forskningsdatabasen.dk:/var/www/mxd/$MAJOR.$MINOR.$REVISION/
# which maps to
# http://mx.forskningsdatabasen.dk/mxd/$MAJOR.$MINOR.$REVISION/

. VERSION.sh      # MAJOR, MINOR, REVISION, FINAL
prepdir=t         # doesn't need to exist
webdir=site/mxd

###############################################

set -e

fullversion=$MAJOR.$MINOR.$REVISION

target=$prepdir/$fullversion
echo "Preparing distribution in $target"

rm -rf $prepdir/*
mkdir -p $target

# While in testing, we don't touch existing symlinks
if [ "$FINAL" = "true" ]; then
    #ln -s "$fullversion" $prepdir/current             # current -> 1.2.3
    ln -s "$fullversion" $prepdir/$MAJOR.$MINOR        # 1.2 -> 1.2.3
    # ln -sf on linux doesn't seem to replace
    # directory symlinks, so:
    rm -f $prepdir/current
    ln -s "$MAJOR.$MINOR" $prepdir/current             # current -> 1.2
fi

cp MXD_ddf_doc.xsd $target/DDF_MXD_Schema_v$fullversion.xsd
ln -sf "DDF_MXD_Schema_v$fullversion.xsd" $target/ddf-mxd.xsd

./schema_sort.pl MXD_ddf_doc.xsd >$target/DDF_MXD_sort.xsl

cp examples/example*.xml $target/

cp doc/DDF_MXD_v$fullversion.pdf $target/
ln -sf "DDF_MXD_v$fullversion.pdf" $target/ddf-mxd.pdf
cp doc/DDF_MXD_change_log_v$fullversion.pdf $target/

echo "Moving prepared distribution to $webdir"
rm -rf $webdir/$fullversion
mv $prepdir/* $webdir/

