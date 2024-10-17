module TextFormattingHelper
  extend ActiveSupport::Concern

  def format_and_sanitize_text(text)
    simple_format(auto_link(text, html: { target: "_blank", rel: "noopener", class: "underline text-blue-500" }))
  end

  def formatted_date(datetime)
    datetime.strftime("%A, %B #{datetime.day.ordinalize}")
  end
end
