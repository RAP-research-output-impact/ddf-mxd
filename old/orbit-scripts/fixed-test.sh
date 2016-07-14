#!/bin/sh

# Get prepared sample records, which have all possible fields filled in.

#data=/usr/local/orbit/urbit.data/records
data=/usr/local/orbit/urbit.data/drafts
set="184664 184667 184669 184670 184676 184681 184691 184683 184688 184690"
# personal recs: "181048 181049 181050 181051 181052 181053 181054 181055 181056 181058 184686 186345"


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
    if ! [ -f $path ]; then
        echo "w00t! could not find $path"
    else
        xmllint --format $path >$TMPDIR/$f
        # Try to get the /ddf/@type; there should be only 1 of each type
        # grep --only-matching does not work in older greps
        type=`grep '<ddf' $TMPDIR/$f |sed 's/^.*type="//' |sed 's/".*//'`
        mv -i $TMPDIR/$f test/$type.xml
    fi
done
