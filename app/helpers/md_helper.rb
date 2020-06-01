require "#{Rails.root}/lib/kramdown/parser/b_kramdown"

module MdHelper
  def render_markdown(md)
    return '' if md.nil?

    return Kramdown::Document.new(md, input: 'BKramdown').to_html.html_safe
  end

  def render_plain(md)
    return '' if md.nil?

    return strip_tags(Kramdown::Document.new(md, input: 'BKramdown').to_html)
  end

  def truncate_markdown(content, length = 100)
    return truncate(render_plain(content).strip, length: length)
  end
end
