class FeatureUpdateService
  def self.send_latest_update_to_all_users
    latest_update = Dir.glob(Rails.root.join("public", "updates", "*.md"))
                       .max_by { |f| File.mtime(f) }

    return unless latest_update

    update_content = File.read(latest_update)

    User.find_each do |user|
      UserMailer.platform_updates(user, update_content).deliver_later
    end
  end
end
