#!/bin/sh

SRCLIST=~/tmp/mxdtest-candidates
DESTLIST=~/tmp/mxdtest-newnames
TYPES="(la|lbralc|lbr|lr)"
ORBITDATA=/usr/local/orbit/urbit.data
DESTFILE=~/tmp/mxdtest-all.xml

pushd $ORBITDATA || exit 1
grep -Erl ' type="'$TYPES'"' records >$SRCLIST

for f in `cat $SRCLIST`; do
    #echo $f |tr -d '/'
    # bashian way, muuuch faster:
    echo ${f//\/}
done >$DESTLIST

echo '<?xml version="1.0"?>'   >$DESTFILE
echo '<root>'                 >>$DESTFILE
popd
for f in `cat $SRCLIST`; do
    xsltproc orb2mxd.xsl $ORBITDATA/$f |grep -Ev '<\?'
done >>$DESTFILE
echo '</root>' >>$DESTFILE

