class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
  # include Sidekiq::Worker

  # def perform()
  #   # replace with your own business logic
  #   puts "Doing hard work"
  # end
end
