class EmailExpirationNotificationJob < ApplicationJob
  queue_as :mailers

  discard_on ActiveJob::DeserializationError do |job, error|
    logger.info "Discarding job #{job.class.name} with ID #{job.job_id} because of #{error.message} (possibly due to a deleted record)"
  end

  # Rails global ID feature allows us to pass ActiveRecord objects as arguments to ActiveJob,
  # non-existent objects throw DeserializationError that is caught and discarded
  # https://github.com/sidekiq/sidekiq/wiki/Active-Job#using-global-id
  def perform(user, item, original_expiration, notification)
    return unless user.notify_through_email # User has opted out of email notifications after scheduling this job
    return unless item.expiration == original_expiration
    return unless item.notification.include?(notification)
    return if item.used?

    UserMailer.expiration_email(user, item, notification).deliver_now
  end
end
