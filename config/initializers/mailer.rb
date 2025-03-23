if Rails.env.production?
  Resend.api_key = ENV.fetch('RESEND_API_KEY') { raise 'Missing RESEND_API_KEY environment variable' }
else
  Resend.api_key = ENV['RESEND_API_KEY'] || 'dummy_key_for_non_production'
end
