namespace :active_storage do
  desc "Migrate Active Storage files from local to Cloudflare"
  task migrate_local_to_cloudflare: :environment do
    require "open-uri"

    ActiveStorage::Blob.find_each do |blob|
      next if blob.service_name.to_sym == :cloudflare

      puts "Migrating #{blob.key}"
      blob.open do |file|
        checksum = blob.checksum
        new_blob = ActiveStorage::Blob.create_and_upload!(
          io: file,
          filename: blob.filename,
          content_type: blob.content_type,
          metadata: blob.metadata,
          service_name: :cloudflare
        )

        if checksum == new_blob.checksum
          ActiveStorage::Attachment.where(blob_id: blob.id).find_each do |attachment|
            attachment.update!(blob_id: new_blob.id)
          end
          blob.purge
        else
          puts "Failed to migrate #{blob.key}: checksum mismatch"
        end
      end
    end
  end
end
