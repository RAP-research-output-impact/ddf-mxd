#!/bin/sh
exsltproc --outdir=- orb2mxd.xsl $1 |xmllint --format -
