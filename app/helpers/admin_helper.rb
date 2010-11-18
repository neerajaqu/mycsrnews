# Methods added to this helper will be available to all templates in the application.
module AdminHelper

  def gen_index_page(collection, model, fields, options = {})
    set_model_vars model

    html = []
    html << "<br /><h1>#{@model_list_name} List</h1"
    html << "<br />"

    html << "<h2>#{gen_new_link model}</h2>"

    html << gen_table(collection, model, fields, options)
    html.join
  end

  def gen_show_page(item, fields, options = {})
    set_model_vars item.class

    html = []
    html << "<h1>#{@model_name} Details</h1>"
    html << "<hr />"
    fields.each do |field|
      html << "<p>#{field.to_s.titleize}: #{field_value item, field, options[:associations]}</p>"
    end
    html << "<br />"
    html << "<p>Actions: #{admin_links item}</p>"
    html << "<br />"

    html.join
  end

  def gen_new_link model
    set_model_vars model
    unless model.name == 'Topic'
      link_to "New #{@model_name}", new_polymorphic_path([:admin, model])
    end
  end

  def gen_table(collection, model, fields, options = {})
    set_model_vars model

    html = []
    model_list_name = @model_list_name
    model_id = @model_id

    if collection.empty?
      html << "<p>No items found</p>"
    else
      html << will_paginate(collection) if options[:paginate]
      html << "<table id='#{model_id}-table' class='admin-table'>"
      html << "<thead>"
      html << "<tr>"
      fields.each {|field| html << "<th>#{field.to_s.titleize}</th>" }
      html << "<th>Actions</th>"
      html << "</tr>"
      html << "</thead>"
      html << "<tbody>"
      collection.each do |item|
        class_name = (item.moderatable? and item.blocked?) ? 'admin-blocked' : ''
        html << "<tr class='#{class_name} #{cycle('odd', 'even')}'>"
        fields.each do |field|
          html << "<td>#{field_value item, field, options[:associations]}</td>"
        end
        html << "<td>#{admin_links item}</td>"
        html << "</tr>"
      end
      html << "</tbody>"
      html << "</table>"
      html << will_paginate(collection) if options[:paginate]
    end

    html.join
  end

  def admin_links item
    links = [
      link_to_unless_current('View', [:admin, item]) {link_to "Back", url_for(send("admin_#{item.class.name.tableize.gsub(/\//, '_')}_url"))},
      link_to('Edit', edit_polymorphic_path([:admin, item]))
    ]

    if item.moderatable?
    	links << link_to(item.blocked? ? 'UnBlock' : 'Block', admin_block_path(item.class.name.foreign_key.to_sym => item))
      if item.class.name != 'RelatedItem' and item.class.name != 'IdeaBoard' and item.class.name != 'ResourceSection'
    	  links << link_to(item.featured? ? 'UnFeature' : 'Feature', admin_feature_path(item.class.name.foreign_key.to_sym => item))
    	  links << link_to('Flag', admin_flag_item_path(item.class.name.foreign_key.to_sym => item))
    	end
    end
    if item.class.name == 'User'
      links << link_to('FB Profile', "http://www.facebook.com/profile.php?id=#{item.fb_user_id}", :target => "_fb")
    end
    
    if item.class.name == 'DashboardMessage'
      links << link_to('Send', send_global_admin_dashboard_message_path(item)) unless item.sent?
      links << link_to('Clear', clear_global_admin_dashboard_message_path(item)) if item.sent?
    end
    if item.class.name == 'Feed'
      links << link_to('Destroy', [:admin, item], :confirm => 'Are you sure?', :method => :delete)
    end
    links.join ' | '
  end

  def set_model_vars model
    @model_list_name  ||= model.name.tableize.titleize
    @model_name       ||= model.name.titleize
    @model_id         ||= model.name.tableize.dasherize
  end

  def association_exists? field, associations
    [:belongs_to, :has_one].each do |association|
      if associations[association].present?
        associations[association].each do |name, field_name|
          return name if field_name == field
        end
      end
    end
    return false
  end

  def field_value item, field, associations = nil
    return item.send(field).to_s unless associations.present?
    association = association_exists? field, associations
    if association and item.send(association).present?
      "#{link_to h(item.send(association).to_s), [:admin, item.send(association)]}"
    else
      item.send(field).to_s
    end
  end

end
