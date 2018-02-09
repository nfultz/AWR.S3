#' An R client to Amazon S3
#'
#' This is a simple wrapper around the most important features of the related Java SDK, \code{put_file()}, \code{get_file()}, \code{delete_file()}.
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
put_file <- function(bucket, key, local_file, client=s3_client()) {

}

#' @export
#' @rdname AWR.S3
get_file <- function(bucket, key, local_file, client=s3_client()) {

}

#' deletes an object from an S3 bucket
#' @export
#' @rdname AWR.S3
delete_file <- function(bucket, key, client=s3_client()) {

}


#' @export
#' @rdname AWR.S3
s3_client <- function() {
  client <- .jnew('com.amazonaws.services.batch.AmazonS3ClientBuilder')$defaultClient()

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
