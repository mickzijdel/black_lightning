module FormattingHelper
  def bold(content)
    if content.is_a? Array
      return content.map { |item| "<b>#{item}</b>".html_safe }
    else
      return "<b>#{item}</b>".html_safe
    end
  end
end
