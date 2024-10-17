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
    @update = File.read(Rails.root.join("public", "updates", "#{params[:id]}.md"))
    @update_date = File.mtime(Rails.root.join("public", "updates", "#{params[:id]}.md"))
  end
end
