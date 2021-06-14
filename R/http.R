
#' @importFrom curl new_pool new_handle handle_setopt multi_add multi_run
#' @importFrom cli cli_progress_bar cli_progress_update

download_files <- function(urls,
                           destfiles,
                           quiet = FALSE,
                           total_con = 100L,
                           host_con = 15L,
                           handles = NULL) {

  stopifnot(
    is.character(urls) && !anyNA(urls),
    is.character(destfiles) & !anyNA(destfiles),
    !any(duplicated(destfiles)),
    length(urls) == length(destfiles),
    is_count(total_con),
    is_count(host_con),
    length(handles) == urls || length(handles) == 0
  )

  pool <- new_pool(total_con = total_con, host_con = host_con)
  on.exit(download_files_cleanup(pool, destfiles), add = TRUE)

  todo <- length(urls)
  tmpfiles <- paste0(destfiles, ".tmp")
  if (is.null(handles)) handles <- vector(todo, mode = "list")
  results <- vector(todo, mode = "list")
  sizes <- rep(NA_integer_, todo)
  currents <- rep(0L, todo)
  finished <- rep(FALSE, todo)

  if (getRversion() < "3.5.0") suspendInterrupts <- identity

  done <- function(num, resp) {
    suspendInterrupts({
      results[[num]] <<- resp
      todo <<- todo - 1L
      finished[[num]] <<- TRUE
      if (is.na(sizes[[num]])) sizes[[num]] <<- currents[[num]]
      file.rename(tmpfiles[[num]], destfiles[[num]])
    })
  }

  fail <- function(num, msg) {
    suspendInterrupts({
      results[[num]] <<- new_http_error(num, urls[[num]], msg)
      todo <<- todo - 1L
      finished[[num]] <<- TRUE
      if (is.na(sizes[[num]])) sizes[[num]] <<- currents[[num]]
      unlink(tmpfiles[[num]], force = TRUE)
    })
  }

  prog <- function(num, down, up) {
    # not possible to download _and_ upload with the same handle, right?
    if (down[[1]] != 0) sizes[num] <<- down[[1]]
    if (up[[1]] != 0) sizes[num] <<- up[[1]]
    currents[[num]] <<- down[[2]] + up[[2]]
    TRUE
  }

  if (!quiet) pbar <- cli_progress_bar(type = "download")

  prog_update <- function() {
    cli_progress_update(id = pbar, set = sum(currents), total = sum(sizes))
  }

  lapply(seq_along(urls), function(i) {
    if (is.null(handles[[i]])) handles[[i]] <<- new_handle()
    handle_setopt(handles[[i]], url = urls[[i]])
    if (!quiet) {
      handle_setopt(
        handles[[i]],
        noprogress = FALSE,
        progressfunction = function(down, up) prog(i, down, up)
      )
    }
    multi_add(
      handles[[i]],
      done = function(resp) done(i, resp),
      fail = function(msg) fail(i, msg),
      data = tmpfiles[[i]],
      pool = pool
    )
  })

  repeat {
    if (todo == 0) break;
    multi_run(0.1, poll = TRUE, pool = pool)
    if (!quiet) prog_update()
  }

  results
}

#' @importFrom curl multi_list multi_cancel

download_files_cleanup <- function(pool, destfiles) {
  handles <- multi_list(pool)
  for (h in handles) {
    tryCatch(multi_cancel(h), error = function(err) NULL)
  }
  tmpfiles <- paste0(destfiles, ".tmp")
  unlink(tmpfiles, force = TRUE)
}

new_http_error <- function(num, url, msg) {
  structure(
    list(
      message = paste0("HTTP error for ", url, " (#", num, "):", msg),
      number = num,
      url = url
    ),
    class = c("http_error", "error", "condition")
  )
}
