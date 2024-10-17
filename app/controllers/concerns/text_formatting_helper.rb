module TextFormattingHelper
  extend ActiveSupport::Concern

  def format_and_sanitize_text(text)
    simple_format(auto_link(text, html: { target: "_blank", rel: "noopener", class: "underline text-blue-500" }))
  end

  def formatted_date(datetime)
    datetime.strftime("%A, %B #{datetime.day.ordinalize}")
  end

  def markdown(text)
    options = [ :hard_wrap, :autolink, :no_intra_emphasis, :fenced_code_blocks ]
    Markdown.new(text, *options).to_html.html_safe
  end
end
