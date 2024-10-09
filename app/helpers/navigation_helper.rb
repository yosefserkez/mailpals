module NavigationHelper
    def clubs_page?
        @club.present? && !@club.new_record? || @clubs.present?
    end

    private

    def current_action
        action
    end

    def current_active_page
        recognized_path = Rails.application.routes.recognize_path(request.path)
        "#{recognized_path[:controller]}##{recognized_path[:action]}"
    end
end