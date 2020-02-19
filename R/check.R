# ---------------------------------------------------------------------------
## .check_pycompass_py():
# Check availability of py-pycompass and, if not available, throw an error and
# lead the user to install_pycompass(). Initializing Python is avoided
# because reticulate (1.13) cannot change the Python environment
# once a Python version is initialized; this can be necessary for
# install_pycompass() to import the module after installation.
# ---------------------------------------------------------------------------

.check_pycompass <- function() {

  # is a Python version already initialized?
  if (reticulate::py_available(initialize = FALSE)) {

    # pycompass available in the initialized Python env?
    if (reticulate::py_module_available("pycompass")) {

      return()

    } else {

      # pycompass available on system? (in any env)
      if (!is.null(reticulate::py_discover_config(required_module = "pycompass")$required_module_path)) {

        stop(paste("The pycompass Python module is not available in the currently initialized Python environment",
                   "but was found on the system. Try reload pycompassR in a fresh R session."),
             call. = FALSE)

      } else {

        stop(paste("The pycompass Python module is not available on your system.",
                   "Use install_pycompass_py() to install it.",
                   "Additional note: A version of Python is currently initialized.",
                   "Therefore, it is advisable to start a fresh R session before installation."),
             call. = FALSE)

      }

    }

    # pycompass available on system? (in any env)
  } else if (!is.null(reticulate::py_discover_config(required_module = "pycompass")$required_module_path)) {

    return()

  } else {

    stop("The pycompass Python module is not available on your system. Use install_pycompass_py() to install it.",
         call. = FALSE)

  }

}
