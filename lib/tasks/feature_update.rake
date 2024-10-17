namespace :feature_update do
  desc "Send latest feature update to all users"
  task send_to_all_users: :environment do
    FeatureUpdateService.send_latest_update_to_all_users
  end
end
