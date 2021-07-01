
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
      results[[num]] <<- new_curl_error(num, urls[[num]], msg)
      todo <<- todo - 1L
      finished[[num]] <<- TRUE
      if (is.na(sizes[[num]])) sizes[[num]] <<- currents[[num]]
      unlink(tmpfiles[[num]], force = TRUE)
    })
  }

  prog <- function(num, down, up) {
    suspendInterrupts({
      # not possible to download _and_ upload with the same handle, right?
      if (down[[1]] != 0) sizes[num] <<- down[[1]]
      if (up[[1]] != 0) sizes[num] <<- up[[1]]
      currents[[num]] <<- down[[2]] + up[[2]]
      TRUE
    })
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

new_curl_error <- function(num, url, msg) {
  structure(
    list(
      message = paste0("curl error for ", url, " (#", num, "):", msg),
      number = num,
      url = url
    ),
    class = c("curl_error", "error", "condition")
  )
}

download_file_lines <- function(url, ...) {
  tmp <- tempfile()
  on.exit(unlink(tmp), add = TRUE)
  resp <- download_files(url, tmp, ...)[[1]]
  http_stop_for_status(resp)
  readLines(tmp, warn = FALSE)
}

http_stop_for_status <- function(resp) {
  if (!is.integer(resp$status_code)) stop("Not an HTTP response")
  if (resp$status_code < 300) return(invisible(resp))
  stop(http_error(resp))
}

http_error <- function(resp, call = sys.call(-1)) {
  status <- resp$status_code
  reason <- http_status(status)$reason
  message <- sprintf("%s (HTTP %d).", reason, status)
  status_type <- (status %/% 100) * 100
  if (length(resp[["content"]]) == 0 && !is.null(resp$file) &&
              file.exists(resp$file)) {
    tryCatch({
      n <- file.info(resp$file, extra_cols = FALSE)$size
      resp$content <- readBin(resp$file, what = raw(), n = n)
    }, error = identity)
  }
  http_class <- paste0("http_", unique(c(status, status_type, "error")))
  structure(
    list(message = message, call = call, response = resp),
    class = c(http_class, "http_error", "error", "condition")
  )
}

http_status <- function(status) {
  status_desc <- http_statuses[as.character(status)]
  if (is.na(status_desc)) {
    stop("Unknown http status code: ", status, call. = FALSE)
  }

  status_types <- c("Information", "Success", "Redirection", "Client error",
    "Server error")
  status_type <- status_types[[status %/% 100]]

  # create the final information message
  message <- paste(status_type, ": (", status, ") ", status_desc, sep = "")

  list(
    category = status_type,
    reason = status_desc,
    message = message
  )
}

http_statuses <- c(
  "100" = "Continue",
  "101" = "Switching Protocols",
  "102" = "Processing (WebDAV; RFC 2518)",
  "200" = "OK",
  "201" = "Created",
  "202" = "Accepted",
  "203" = "Non-Authoritative Information",
  "204" = "No Content",
  "205" = "Reset Content",
  "206" = "Partial Content",
  "207" = "Multi-Status (WebDAV; RFC 4918)",
  "208" = "Already Reported (WebDAV; RFC 5842)",
  "226" = "IM Used (RFC 3229)",
  "300" = "Multiple Choices",
  "301" = "Moved Permanently",
  "302" = "Found",
  "303" = "See Other",
  "304" = "Not Modified",
  "305" = "Use Proxy",
  "306" = "Switch Proxy",
  "307" = "Temporary Redirect",
  "308" = "Permanent Redirect (experimental Internet-Draft)",
  "400" = "Bad Request",
  "401" = "Unauthorized",
  "402" = "Payment Required",
  "403" = "Forbidden",
  "404" = "Not Found",
  "405" = "Method Not Allowed",
  "406" = "Not Acceptable",
  "407" = "Proxy Authentication Required",
  "408" = "Request Timeout",
  "409" = "Conflict",
  "410" = "Gone",
  "411" = "Length Required",
  "412" = "Precondition Failed",
  "413" = "Request Entity Too Large",
  "414" = "Request-URI Too Long",
  "415" = "Unsupported Media Type",
  "416" = "Requested Range Not Satisfiable",
  "417" = "Expectation Failed",
  "418" = "I'm a teapot (RFC 2324)",
  "420" = "Enhance Your Calm (Twitter)",
  "422" = "Unprocessable Entity (WebDAV; RFC 4918)",
  "423" = "Locked (WebDAV; RFC 4918)",
  "424" = "Failed Dependency (WebDAV; RFC 4918)",
  "424" = "Method Failure (WebDAV)",
  "425" = "Unordered Collection (Internet draft)",
  "426" = "Upgrade Required (RFC 2817)",
  "428" = "Precondition Required (RFC 6585)",
  "429" = "Too Many Requests (RFC 6585)",
  "431" = "Request Header Fields Too Large (RFC 6585)",
  "444" = "No Response (Nginx)",
  "449" = "Retry With (Microsoft)",
  "450" = "Blocked by Windows Parental Controls (Microsoft)",
  "451" = "Unavailable For Legal Reasons (Internet draft)",
  "499" = "Client Closed Request (Nginx)",
  "500" = "Internal Server Error",
  "501" = "Not Implemented",
  "502" = "Bad Gateway",
  "503" = "Service Unavailable",
  "504" = "Gateway Timeout",
  "505" = "HTTP Version Not Supported",
  "506" = "Variant Also Negotiates (RFC 2295)",
  "507" = "Insufficient Storage (WebDAV; RFC 4918)",
  "508" = "Loop Detected (WebDAV; RFC 5842)",
  "509" = "Bandwidth Limit Exceeded (Apache bw/limited extension)",
  "510" = "Not Extended (RFC 2774)",
  "511" = "Network Authentication Required (RFC 6585)",
  "598" = "Network read timeout error (Unknown)",
  "599" = "Network connect timeout error (Unknown)"
)
