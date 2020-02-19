.onLoad <- function(libname, pkgname) {
  # try() because if a Python version is already initialized
  # delay_load will be ignored causing an error if pycompass is missing
  try(
    assign(".pycompass",
           reticulate::import("pycompass", delay_load = TRUE),
           envir = parent.env(environment())),
    silent = TRUE
  )
}
