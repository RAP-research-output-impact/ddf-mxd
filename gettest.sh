#!/bin/sh

# Get sitecore sample records.

data=/usr/local/orbit/ddf.data/records
set="182412 182413 182414 182416 182417 182419 182421 182423 182426 182468"

for f in $set; do
    fill=`printf '%08d' $f`
    # Substringing is very bashy...
    path=$data/${fill:0:4}/${fill:4}
    xmllint --format $path >/tmp/gettest$f
    # Try to get the /ddf/@type
    # grep --only-matching does not work in older greps
    type=`grep '<ddf' /tmp/gettest$f |sed 's/^.*type="//' |sed 's/".*//'`
    mv -iv /tmp/gettest$f test/$type.xml
done
