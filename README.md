# mx.forskningsdatabasen.dk:/var/www/mxd

This is a preparation and deployment repo for the DDF-MXD schema and documentation.


## Starting out

Before first deployment, Puppet (or anyone) needs to prepare /var/www/mxd
on the target host with owner:group = capistrano:www-data and
file mode = 2775 (rwxrwsr-x).


## Preparing updates to the schema and/or documentation

In the following, we'll assume the current published version is 1.2.3
and you're preparing 1.2.4, which initially is published as a preview
version only.

Note that we prepare a mirror of the website locally. In part that's
historical (we can't correctly reproduce old versions) and in part
because there's no staging host (you have to check your work locally
before deployment).


### Preview version

* Get a hold of the updated documentation for 1.2.4
  + It normally comes in the following files:
    - DDF_MXD_change_log_v1.2.4.pdf
    - DDF_MXD_v1.2.4.pdf
  + Copy these to doc/ (but check that the names are in correspondence with older versions)
* Update MXD_ddf_doc.xsd according to the change_log
* Update VERSION.sh:
  + set MAJOR,MINOR,REVISION to 1,2,4
  + set FINAL to 'false' as long as this version is not released for
    general use (and anticipated by all DDF producers and consumers)
* Run ./prepare.sh and check in site/mxd that the following are in place:
  + 1.2.4/        with all relevant files (check previous version as example)
  + 1.2           symlink which points to __1.2.3__ while we're not FINAL
  + current       symlink which points to 1.2
* Check the results in site/mxd in your browser
* git commit and git push when done.


### Final version

* Edit VERSION.sh and set FINAL to 'true'
* Run ./prepare.sh and check in site/mxd that the following are in place:
  + 1.2.4/        with all relevant files (check previous version as example)
  + 1.2           symlink which points to __1.2.4__
  + current       symlink which points to 1.2
* Commit and push as usual.


## Deployment

* Run manual deployment from Gitlab (it only copies files from site/mxd/ to
  mx.forskningsdatabasen.dk:/var/www/mxd/ )
* On mx.forskningsdatabasen.dk:/var/www/mxd, check the symlinks
  named 'current' and $MAJOR/$MINOR and try
  http://mx.forskningsdatabasen.dk/mxd/

