module ClubsHelper
  def section_title(section)
    section_options[section.to_sym][:title]
  end

  def section_options
    options = Club.sections.each_with_object({}) do |section, hash|
      hash[section] = create_option(section, :check_box, "sections")
    end

    options[:questions][:sub_options] = [
      create_option(:default_number_questions, :number_field, "options", options: { min: 1, max: 5 })
    ]

    # Makes sure all sections are included in the options
    raise "Missing section option(s) #{(Club.sections - options.keys)} in ClubsHelper section_options" if (Club.sections - options.keys).present? && Rails.env.development?

    options
  end

  def club_options
    {
      title: create_option("title", :text_field, "options"),
      theme: create_option("theme", :select, "options", options: Club::THEMES.map { |theme| [ theme.capitalize, theme ] }, additional_options: { data: { controller: "theme-switcher", theme_switcher_target: "themeSelect", action: "change->theme-switcher#change" } }),
      sections: create_option("sections", :collection_check_boxes, "options", options: section_options),
      delivery_frequency: create_option("delivery_frequency", :select, "options", options: format_select_options(Club.delivery_frequencies)),
      delivery_time: create_option("delivery_time", :select, "options", options: format_select_options(Club.delivery_times)),
      delivery_day: create_option("delivery_day", :select, "options", options: format_select_options(Club.delivery_days)),
      timezone: create_option("timezone", :time_zone_select, "options", options: ActiveSupport::TimeZone.all.sort, default: Current.user.timezone)
    }
  end

  def sort_option(key)
    sort_options[key] || raise("Invalid sort option: #{key}")
  end

  def sort_options
    {
      "next_delivery_asc" => { scope: :by_next_delivery, direction: :asc, label: "Next Delivery (Earliest)" },
      "next_delivery_desc" => { scope: :by_next_delivery, direction: :desc, label: "Next Delivery (Latest)" },
      "title_asc" => { scope: :by_title, direction: :asc, label: "Title (A-Z)" },
      "title_desc" => { scope: :by_title, direction: :desc, label: "Title (Z-A)" },
      "member_count_asc" => { scope: :by_member_count, direction: :asc, label: "Member Count (Lowest)" },
      "member_count_desc" => { scope: :by_member_count, direction: :desc, label: "Member Count (Highest)" }
    }
  end

  def sort_options_for_select
    options_for_select(
      sort_options.map { |key, option| [ option[:label], key ] },
      params[:sort_by]
    )
  end

  private

  def create_option(key, field_type, translation_prefix, additional_options = {})
    {
      key: key,
      title: t("clubs.#{translation_prefix}.#{key}.title"),
      description: t("clubs.#{translation_prefix}.#{key}.description"),
      field_type: field_type
    }.merge(additional_options)
  end

  def format_select_options(options)
    options.map { |key, value| [ key.capitalize, value ] }
  end

  def render_sub_options(form, sub_options)
    return unless sub_options.present?

    content_tag :div, class: "ml-6" do
      sub_options.map do |sub|
        content_tag :p, class: "flex flex-col gap-1" do
          form.send(sub[:field_type], sub[:key], class: "", **sub[:options]) +
            form.label(sub[:key], sub[:title], class: "subtitle italic")
        end
      end.join.html_safe
    end
  end
end
