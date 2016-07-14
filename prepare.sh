#!/bin/bash

# Prepare a new distribution that can be copied to
# the website
# mx.forskningsdatabasen.dk:/var/www/mxd/$MAJOR.$MINOR.$REVISION/
# which maps to
# http://mx.forskningsdatabasen.dk/mxd/$MAJOR.$MINOR.$REVISION/

. VERSION.sh  # MAJOR, MINOR, REVISION
out_base_dir=t

###############################################

fullversion=$MAJOR.$MINOR.$REVISION

target=$out_base_dir/$fullversion
echo "Installing to $target"

mkdir -p $target
rm -f $out_base_dir/current  # symlink to latest
ln -s "$fullversion" $out_base_dir/current

cp MXD_ddf_doc.xsd $target/DDF_MXD_Schema_v$fullversion.xsd
ln -s "DDF_MXD_Schema_v$fullversion.xsd" $target/ddf-mxd.xsd

./schema_sort.pl MXD_ddf_doc.xsd >$target/DDF_MXD_sort.xsl

cp examples/example*.xml $target/

cp doc/DDF_MXD_v$fullversion.pdf $target/
ln -s "DDF_MXD_v$fullversion.pdf" $target/ddf-mxd.pdf
cp doc/DDF_MXD_change_log_v$fullversion.pdf $target/

