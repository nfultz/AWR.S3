
#' @export
#' @rdname AWR.S3
put_file <- function(bucket, key, input, client=s3_client()) {

}


#' @export
#' @rdname AWR.S3
get_file <- function(bucket, key, output, client=s3_client()) {

}


#' @export
#' @rdname AWR.S3
delete_object <- function(bucket, key, client=s3_client()) {

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
