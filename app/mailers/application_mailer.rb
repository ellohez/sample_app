# frozen_string_literal: true

# Class description goes here
class ApplicationMailer < ActionMailer::Base
  default from: 'user@realdomain.com'
  layout 'mailer'
end
