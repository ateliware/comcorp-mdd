# -*- encoding : utf-8 -*-
MDWA::DSL.entities.register "<%= name.singularize.camelize %>" do |e|
  
  <%- if options.user -%>
  # NOTE: Users have the following attributes predefined (Devise defaults):
  # "email", "password", "password_confirmation", "encrypted_password", "name", "type", "reset_password_token", 
  # "reset_password_sent_at", "remember_created_at", "sign_in_count", "current_sign_in_at", "last_sign_in_at", 
  # "current_sign_in_ip", "last_sign_in_ip", "created_at", "updated_at"
  e.user        = true
  <%- end -%>
  
  <%- unless options.no_comments -%>
  # e.purpose   = %q{To-do} # what this entity does?
  # e.resource  = true      # should it be stored like a resource?
  # e.ajax      = true      # scaffold with ajax?
  # e.user      = false     # is this entity a loggable user?
  # e.scaffold_name = 'a/<%= name.singularize.underscore %>' # mdwa sandbox specific code?
  # e.model_name = 'a/<%= name.singularize.underscore %>' # use specific model name? or different namespace?

  ##
  ## Define entity attributes
  ##
  # e.attribute do |attr|
  #   attr.name = 'name'
  #   attr.type = 'string'
  # end
  # e.attribute do |attr|
  #   attr.name = 'category'
  #   attr.type = 'integer'
  # end
  
  ##
  ## Define entity associations
  ##
  # e.association do |a|
  #   a.type = 'many_to_one'
  #   a.destination = 'Category' # entity name
  #   a.description = '<%= name.singularize.humanize %> belongs to category'
  # end
  # 
  # e.association do |a|
  #   a.name = 'address' # specify a name for the associations
  #   a.type = 'one_to_one'
  #   a.destination = 'Address' 
  #   a.composition = true
  #   a.description = 'This entity has a composite address.'
  # end
  <%- end -%>
  
end