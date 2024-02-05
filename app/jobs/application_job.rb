class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Ignore the job if the underlying records are no longer available
  discard_on ActiveJob::DeserializationError do |job, error|
    logger.info "Discarding job #{job.class.name} with ID #{job.job_id} because of #{error.message} (possibly due to a deleted record)"
  end
end
