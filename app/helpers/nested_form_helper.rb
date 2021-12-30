# Wrappers around Cocoon
# :nocov:
module NestedFormHelper
  def NEW_link_to_remove(f, link_text: nil, item_name: nil, html_options: {})
    return
    link_text ||= "#{generate_icon_prefix('trash', 'Remove')} #{item_name || association.to_s.singularize.capitalize}".html_safe

    html_options = get_default_html_options(html_options)

    return link_to_remove_assocation(link_text, f, html_options)
  end

  def NEW_link_to_add(f, association, link_text: nil, item_name: nil, html_options: {})
    return
    link_text ||= "#{generate_icon_prefix('plus', 'New')} #{item_name || association.to_s.singularize.capitalize}".html_safe

    html_options = get_default_html_options(html_options)

    return link_to_add_association(link_text, f, association, html_options)

    new_object = f.object.send(association).klass.new

    # Saves the unique ID of the object into a variable.
    # This is needed to ensure the key of the associated array is unique. This is makes parsing the content in the `data-fields` attribute easier through Javascript.
    # We could use another method to achive this.
    id = new_object.object_id

    fields_template_name ||= association_singular_name + '_fields'

    # https://api.rubyonrails.org/ fields_for(record_name, record_object = nil, fields_options = {}, &block)
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      # The render function also needs to be passed the value of 'builder', because `views/people/_address_fields.html.erb` needs this to render the form tags.
      template_parameters[:f] ||= builder

        render(fields_template_name, template_parameters)
    end

    # This renders a simple link, but passes information into `data` attributes.
    # This info can be named anything we want, but in this case we chose `data-id:` and `data-fields:`.
    # The `id:` is from `new_object.object_id`.
    # The `fields:` are rendered from the `fields` blocks.
    # We use `gsub("\n", "")` to remove anywhite space from the rendered partial.
    # The `id:` value needs to match the value used in `child_index: id`.
    # The associated javascript looks for the add_fields class so don't change that.
    return link_to(name, '#', class: 'btn add_fields', data: { id: id, fields: fields.gsub("\n", '') })
  end

  private

  def get_default_html_options(html_options)
    html_options[:render_options] ||= {}
    html_options[:render_options][:wrapper] ||= 'bootstrap'

    return html_options
  end
end
# :nocov:
