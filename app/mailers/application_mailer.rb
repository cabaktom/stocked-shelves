# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAILER_SENDER_EMAIL']
  layout 'mailer'
end
