#!/bin/bash

this=$(dirname "$(which $0)")

schema=$this/MXD_ddf_doc.xsd

if [ ! -r $schema ]; then
    echo "$0: Cannot find schema $schema"
    exit 1
fi

# TODO: This will still print 'bla.xml fails to validate'
xmllint --noout --schema $schema $1 2>&1 |grep -v language
