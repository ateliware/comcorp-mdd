# -*- encoding : utf-8 -*-

require 'rails/generators'

require 'mdwa/dsl'

module Mdwa
  module Generators
    
    class FromRequirementsGenerator < Rails::Generators::Base
      
      source_root File.expand_path("../templates", __FILE__)
      attr_accessor :requirements
      
      argument :defined_requirements, :type => :array, :banner => 'Generate only defined requirements (use the alias)', :default => []
      
      #
      # Constructor
      # Require all entities to load the DSL of the application
      def initialize(*args, &block)
        super
        
        # include files with requirements
        inside Rails.root do
          require_all MDWA::DSL::REQUIREMENTS_PATH
        end
        # select requirements that will be generated
        if defined_requirements.count.zero?
          @requirements = MDWA::DSL.requirements.all
        else
          @requirements = defined_requirements.collect{ |requirement| MDWA::DSL.requirement(requirement.to_sym) }
        end

      end
      
      
      #
      # Generate code for requirements.
      # Generate files for entities and users.
      def requirements
        
        # For all requirements, generate users and entities
        @requirements.each do |requirement|
          
          puts "============================================================================="
          puts "Generating transformation for requirement: '#{requirement.summary}'"
          puts "============================================================================="
          
          # generate entities
          requirement.entities.each do |entity|
            generate "mdwa:entity #{entity} --requirement=\"#{requirement.alias}\""
          end
          
          # generate users
          requirement.users.each do |user|
            generate "mdwa:user #{user} --requirement=\"#{requirement.alias}\""
          end
          
        end
        
      end
      
    end # class
    
  end # generators
end # mdwa
