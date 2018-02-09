#' Submit a Batch Job
#'
#' @param jobname name of the job
#' @param jobdefinition name of the job definition
#' @param command command and list, presplit
#' @param jobqueue name of the job queue
#' @param vcpu optional, override the number of vCPU required
#' @param memory optional, override the GB of memory required
#' @param retries optional, override the number of retries
#' @param ... not used
#' @param client a Batch client (submitJob will be called upon it)
#' @return function result
#' @export
#' @examples
#' \dontrun{
#' # Using the default job setup and default auth:
#'  AWR.S3:::submit_job("test", jobdefinition = "first-run-job-definition", jobqueue = "first-run-job-queue", command = list("echo", "hello"))
#' }

submit_job <- function(jobname, jobdefinition, command, jobqueue, vcpu, memory, retries, ..., client=batch_client()) {
  request <- .jnew('com.amazonaws.services.batch.model.SubmitJobRequest')


  request$setJobName(jobname)
  request$setJobDefinition(jobdefinition)
  request$setJobQueue(jobqueue)

  if(!missing(retries)) {
    retryStrategy <-  .jnew('com.amazonaws.services.batch.model.RetryStrategy')
    retryStrategy$setAttempts(as.integer(retries))
    request$setRetryStrategy(retryStrategy)
  }

  ##############
  cOverride <- .jnew('com.amazonaws.services.batch.model.ContainerOverrides')

  commandList <- .jnew('java.util.ArrayList')
  for(cmd in command) commandList$add(cmd)

  cOverride$setCommand(commandList)

  if(!missing(memory)) cOverride$setMemory(as.integer(memory))
  if(!missing(vcpu)) cOverride$setVcpus(as.integer(vcpu))

  request$setContainerOverrides(cOverride)

  ##################

  result <- client$submitJob(request)
  result
}


#' @export
#' @rdname submit_job
batch_client <- function() {
  client <- .jnew('com.amazonaws.services.batch.AWSBatchClientBuilder')$defaultClient()

  ## fail on error
  if (inherits(client, 'SdkClientException')) {
    stop(paste(
      'There was an error while starting the Batch Client, probably due to no configured AWS Region',
      '(that you could fix eg in ~/.aws/config or via environment variables, then reload the package):',
      client$message))
  }

  ## return
  invisible(client)
}
