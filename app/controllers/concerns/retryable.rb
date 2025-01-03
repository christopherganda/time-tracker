module Retryable
  MAX_RETRIES = 3
  RETRY_DELAY = 0.5 # seconds

  def with_retry(max_retries: MAX_RETRIES, delay: RETRY_DELAY)
    attempts = 0

    begin
      yield
    rescue ActiveRecord::Deadlocked => e
      attempts += 1
      Rails.logger.warn("Retryable Error: #{e.class} - #{e.message}. Attempt #{attempts} of #{max_retries}.")
      if attempts < max_retries
        sleep(delay * attempts)
        retry
      else
        Rails.logger.error("Retries exhausted for #{e.class}: #{e.message}")
        raise e
      end
    rescue ActiveRecord::ActiveRecordError => e
      Rails.logger.error("ActiveRecord Error: #{e.class} - #{e.message}")
      render_error(:unprocessable_entity, e.message)
    rescue StandardError => e
      Rails.logger.error("Unexpected Error: #{e.class} - #{e.message}")
      render_error(:internal_server_error, e.message)
    end
  end
end