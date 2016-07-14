#!/bin/sh

SRCLIST=~/tmp/mxdtest-candidates
ORBITDATA=/usr/local/orbit/ddf.data
# Pick each Nth record from the candidate set to create a test case
N=20
TESTSET=~/tmp/mxdtestset
DESTDIR=~/tmp/mxdtestfiles

i=0
for f in `cat $SRCLIST`; do
    i=$(($i + 1))
    if [ $((i % $N)) = 0 ]; then 
        echo $f
        cp $ORBITDATA/$f $DESTDIR/${f//\/}.xml
    fi
done >$TESTSET
