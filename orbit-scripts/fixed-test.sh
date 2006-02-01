#!/bin/sh

# Get prepared sample records, which have all possible fields filled in.

#data=/usr/local/urbit/urbit.data/records
data=/usr/local/urbit/urbit.data/drafts
set="182412 182413 182414 182416 182417 182419 182421 182423 182426 182468"

######################################################
TMPDIR=/tmp/gettest-$$
mkdir $TMPDIR

if ! [ -d test ]; then
    echo "You must execute this script from the dir above test/"
    exit 1
fi

for f in $set; do
    fill=`printf '%08d' $f`
    # Substringing is very bashy...
    path=$data/${fill:0:4}/${fill:4}
    xmllint --format $path >$TMPDIR/$f
    # Try to get the /ddf/@type; there should be only 1 of each type
    # grep --only-matching does not work in older greps
    type=`grep '<ddf' $TMPDIR/$f |sed 's/^.*type="//' |sed 's/".*//'`
    mv -iv $TMPDIR/$f test/$type.xml
done
