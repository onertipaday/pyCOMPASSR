install_pycompass <- function(method = "auto", conda = "auto", envname = NULL, skip_if_available = FALSE) {

  if (skip_if_available &&
      (!is.null(reticulate::py_discover_config(required_module = "pycompass")$required_module_path))) {

    return(invisible(1))

  }

  tryCatch(reticulate::py_install(c("pycompass", "numpy"), envname = envname, method = method, conda = conda),

           error = function(e) {message(paste0("\n", e$message))

             message(paste("-> Make sure you have Python with virtualenv",
                           " or conda installed (on Windows you need conda).",
                           "\n-> Try in a fresh R session.",
                           "\n-> If not successful, use pip or conda outside of the R environment."))

             return(invisible(1))

           })

  tryCatch(invisible(reticulate::import("pycompass")),

           error = function(e) {message(paste0("\n", e$message))

             message(paste("Installation successful but loading the pycompass Python module failed.",
                           "Try using pycompassR in a fresh R session."))

             return(invisible(1))

           })

  return(invisible(0))

}

