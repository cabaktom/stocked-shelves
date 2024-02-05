class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Ignore the job if the underlying records are no longer available
  discard_on ActiveJob::DeserializationError
end
