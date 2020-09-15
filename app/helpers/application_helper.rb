module ApplicationHelper
  def error_messages
    return if flash[:alert].nil?

    errors = tag.ul do
      flash[:alert].each do |alert|
        concat(tag.li(alert))
      end
    end
    tag.div(errors, class: %w[notification alert-danger])
  end
end
