#' An R client to Amazon S3
#'
#' This is a simple wrapper around the most important features of the related Java SDK, \code{s3_put_file()}, \code{s3_get_file()}, \code{s3_delete_file()}.
#' @references \url{http://docs.aws.amazon.com/AWSJavaSDK/latest/javadoc/com/amazonaws/services/Batch/AWSBatchClient.html}
#' @docType package
#' @importFrom rJava .jnew J .jbyte
#' @import AWR
#' @name AWR.S3
NULL

#' @param bucket the S3 bucket
#' @param key    the S3 key
#' @param local_file  the filename
#' @param client SDK client
#' @export
#' @rdname AWR.S3
s3_put_file <- function(bucket, key, local_file, client=s3_client()) {

}

#' @export
#' @rdname AWR.S3
s3_get_file <- function(bucket, key, local_file, client=s3_client()) {

}

#' deletes an object from an S3 bucket
#' @export
#' @rdname AWR.S3
s3_delete_file <- function(bucket, key, client=s3_client()) {

}

#' @export
#' @rdname AWR.S3
s3_list_files <- function(bucket, key, client=s3_client()) {

  listResult <- client$listObjectsV2(bucket, key)
  summaries <- listResult$getObjectSummaries()

  origin <- as.POSIXct("1970-01-01")
  n <- summaries$size()
  ret <- data.frame(
    bucketName = character(n),
    key = character(n),
    eTag = character(n),
    size = numeric(n),
    lastModified = as.POSIXct(numeric(n), origin=origin),
    storageClass = character(n),
    owner = character(n),
    stringsAsFactors = FALSE
  )

  null2NA <- function(x) if(is.null(x)) NA else x

  for (i in 1:n) {
    obj <- summaries$get(as.integer(i-1))
    row <- list(
      obj$getBucketName(),
      obj$getKey(),
      obj$getETag(),
      obj$getSize(),
      as.POSIXct(obj$getLastModified()$getTime(), origin=origin),
      obj$getStorageClass(),
      obj$getOwner()
    )

    ret[i,] <- lapply(row, null2NA)
  }

  ret
}


#' @export
#' @rdname AWR.S3
s3_client <- function() {
  client <- .jnew('com.amazonaws.services.s3.AmazonS3ClientBuilder')$defaultClient()

  ## fail on error
  if (inherits(client, 'SdkClientException')) {
    stop(paste(
      'There was an error while starting the S3 Client, probably due to no configured AWS Region',
      '(that you could fix eg in ~/.aws/config or via environment variables, then reload the package):',
      client$message))
  }

  ## return
  invisible(client)
}
