<% module_namespacing do -%>
  <% has_superclass = controller_class_name.classify.include?('::') %>
  class Admin::<%= controller_class_name %>Controller < AdminController
    include GenericController
    load_and_authorize_resource <%= has_superclass ? "class: #{controller_class_name}" : '' %>
  
    # INDEX:  <%= route_url %>
    # SHOW:   <%= route_url %>/1
    # EDIT:   <%= route_url %>/1/edit
    # UPDATE: <%= route_url %>/1
    # NEW:    <%= route_url %>/new
    # CREATE: <%= route_url %>

    private

    <% if has_superclass %>
    def resource_class
      <%= controller_class_name.classify %>
    end
    <% end %>

    def permitted_params
      [<%= permitted_params %>]
    end

    def order_params
      []
    end
  end
<% end -%>
