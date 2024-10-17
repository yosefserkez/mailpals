module ApplicationHelper
  include TextFormattingHelper

  def current_user
    Current.user
  end


  def component(name, locals = {}, &block)
    render "shared/components/#{name}", locals, &block
  end

  def toast_class_for(flash_type)
    case flash_type.to_sym
    when :error, :alert
      "border-l-4 border-[var(--error-color)] text-[var(--error-color)]"
    when :success, :notice
      "border-l-4 border-[var(--success-color)] text-[var(--success-color)]"
    else
      "border-l-4 border-[var(--info-color)] text-[var(--info-color)]"
    end
  end

  def hide_footer
    @hide_footer = true
  end
end
