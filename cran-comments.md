
Test environments
-----------------

-   local OS X install, R 3.4.1
-   ubuntu 14.04 (on travis-ci), R 3.4.1
-   win-builder (devel and release)

R CMD check results
-------------------

There were no ERRORs, or WARNINGs.

There was one NOTE because this is the first submission to CRAN.

Downstream dependencies
-----------------------

There are currently no downstream dependencies for this package.

Resubmission
------------

This is a resubmission. In this version we have:

-   Modified the DESCRIPTION to not begin with "This package."

-   Ensured that functions do not write by default or in examples/vignettes in the user's home filespace, writing to tempdir() instead.
