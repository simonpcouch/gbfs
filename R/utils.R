check_return_arguments <- function(directory_, file_, output_) {
  
  if (is.null(directory_)) {
    directory_ <- "null"
  }
  
  if (is.null(output_)) {
    output_ <- "null"
  }
  
  # check whether the output argument matches one of the options... (if left
  # as default, the output is "save")
  if (!output_ %in% c("save", "return", "both", "null")) {
    stop(sprintf(c("Please supply one of \"save\", \"return\", or \"both\" ",
                   "as arguments to `output`.")))
  }
  
  # if the output type indicates the object should be returned, by there's
  # no directory argument, trigger an error
  if (directory_ == "null" & output_ %in% c("save", "both")) {
    stop(sprintf(c("You have not supplied a folder to save the resulting file",
                   " in, but the argument to `output` indicates that you'd like",
                   " to save the dataframe. Please supply a `directory`",
                   " argument or set `output = \"return\".`")))
  }  
  
  
  # message when the user doesn't supply a `dir` argument but the output
  # argument is left as default. so as not to break functionality from v1.0.0, 
  # the package still defaults to returning output as .rds files. instead of 
  # requiring users to switch their argument to `output`, though, they can just
  # not supply a `dir` argument.
  if (directory_ == "null" & output_ == "null") {
    message(c("Returning the output data as an object, rather than saving it, ",
              "since the `dir` argument was not specified. Setting ",
              "output = `return` will silence this message."))
  }
}


