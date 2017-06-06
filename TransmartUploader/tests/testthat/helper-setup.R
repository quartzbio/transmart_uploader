

get_db <- function(dbid = Sys.getenv('TRANSMART_DB')) {
  if (!nzchar(dbid)) return(NULL)
  items <- strsplit(dbid, '@', fixed = TRUE)[[1]]

  list(host = items[1], port = as.integer(items[2]))
}


requires_db <- function(db = get_db()) {
  if (is.null(db)) skip('This test requires a Transmart Test DB')

  db
}


setup_temp_dir <- function(chdir = TRUE, ...) {
  dir <- tempfile(...)
  dir.create(dir, recursive = TRUE)
  old_dir <- NULL
  if (chdir) old_dir <- setwd(dir)

  # on one line because it not seen by the coverage
  cleanup <- bquote({if (.(chdir)) setwd(.(old_dir));unlink(.(dir), recursive = TRUE)})

  do.call(add_on_exit, list(cleanup, parent.frame()))

  invisible(normalizePath(dir))
}

add_on_exit <- function(expr, where = parent.frame()) {
  do.call("on.exit", list(substitute(expr), add = TRUE), envir = where)
}