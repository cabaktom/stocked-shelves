# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'notifications@stockedshelves.com'
  layout 'mailer'
end
