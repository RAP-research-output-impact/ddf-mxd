#!/bin/bash
exsltproc -o - orb2mxd.xsl,filterempty.xsl $1
