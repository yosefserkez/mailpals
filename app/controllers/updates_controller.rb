class UpdatesController < ApplicationController
  def index
    @updates = Dir.glob(Rails.root.join("public", "updates", "*.md"))
                  .sort_by { |f| File.mtime(f) }
                  .reverse
                  .map do |f|
                    {
                      filename: File.basename(f),
                      content: File.read(f),
                      date: File.mtime(f),
                      title: File.basename(f).gsub(".md", "").gsub(/^\d{4}_\d{2}_\d{2}_/, "").titleize
                    }
                  end
  end

  def show
    # Sanitize to a bare filename so params[:id] can't traverse out of public/updates.
    path = Rails.root.join("public", "updates", "#{File.basename(params[:id])}.md")
    @update = File.read(path)
    @update_date = File.mtime(path)
  end
end
