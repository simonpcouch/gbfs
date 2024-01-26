# gbfs (developmental version)

# gbfs 1.3.9

- Fixed bug where non-english feeds couldn't be accessed using the top-level
  gbfs feed URL (#10).
- Update URLs to reflect the transition of the gbfs source from the NABSA 
  GitHub organization to MobilityData (#9).
- Update URLs in examples and unit tests to reflect bikeshare systems
  adjusting operations.
- Address CRAN check NOTEs related to help-file formatting.

# gbfs 1.3.8

- Changed default development branch name from `master` to `main`.
- Fixed HTML5 NOTEs on R devel checks.

# gbfs 1.3.7

- Update URLs in examples and unit tests to reflect bikeshare systems
  adjusting operations due to COVID-19
- Catch errors while fetching .json data and return a more informative
  message on timeout and HTTP 400 errors
  
# gbfs 1.3.6

- Introduce support for the new system ID key to improve stability of
  argument matching. This is now the recommended method for specifying the
  system of interest!
- Switch from Travis to GitHub Actions for continuous integration
- Update URLs in examples and unit tests to reflect bikeshare systems
  adjusting operations due to COVID-19

# gbfs 1.3.5

- Update URLs in examples and unit tests to reflect bikeshare systems
  adjusting operations due to COVID-19

# gbfs 1.3.4

- Update URLs in examples and unit tests to reflect bikeshare systems
  adjusting operations due to COVID-19
  
# gbfs 1.3.3

- Catch errors while fetching .json data and return a more informative
  message on timeout and HTTP 400 errors
- Update URLs in examples and unit tests to reflect bikeshare systems
  adjusting operations due to COVID-19

# gbfs 1.3.2

- Several fixes for bugs arising from NABSA’s update to the gbfs spec
  (gbfs 1.1-RC)
- Improved error message for multiple cities matching the supplied
  string
- Accomodate valid json URLs with no .json file extension

# gbfs 1.3.1

- All package functions requiring internet access now immediately
  check the internet connection upon being called, raising a message
  and returning an empty list if an internet connection is not
  available.

# gbfs 1.3.0

- The main wrapper function, `get_gbfs`, can now return its output as
  a named list, where each entry is a GBFS dataframe.
- Results will now be returned by default (note that these changes are
  non-breaking–the new default settings would error out in previous
  versions, and previously valid arguments still return results in the
  same way.)
- Added a `get_which_gbfs_feeds` function, which supplies a table
  giving all of the available feeds for a city\!
- Extended flexibility of the `city` argument–in addition to a string
  that matches the city name, the package can now find the appropriate
  feed given any subfeed of a bikeshare system.
- Extend argument checking.
- Make error messages more informative.
- Documentation improvements.
- Code refactoring.

# gbfs 1.2.0

- Addressed errors arising from new columns types introduced in the
  new NABSA GBFS guidelines.  
- Added the `output` argument, allowing users to either save the
  outputs as `.Rds` files or return them as list or dataframe objects.
  As a result, the directory argument is no longer required if `output
  = "return"`
- Minor bug fixes and documentation improvements

# gbfs 1.1.0

- Thanks to Mark Padgham (@mpadge), we’ve introduced a new function
  `get_gbfs_cities` that lists all of the cities currently releasing
  feeds\! This function will help inform users who do not have a
  specific city already in mind.  
- Add functionality for new column types introduced in the new NABSA
  GBFS guidelines.  
- Minor bug fixes (unused imports, vignette errors, etc.)
