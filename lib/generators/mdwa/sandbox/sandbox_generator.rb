# -*- encoding : utf-8 -*-

require 'rails/generators'
require 'rails/generators/migration'

module Mdwa
  module Generators
    class SandboxGenerator < Rails::Generators::Base
      
      include Rails::Generators::Migration
      
      source_root File.expand_path("../templates", __FILE__)

      class_option :ask_questions, :type => :boolean, :default => false, :desc => "Ask override questions or generate like first run?"
      
      # Implement the required interface for Rails::Generators::Migration.
      def self.next_migration_number(dirname)
        if ActiveRecord::Base.timestamped_migrations
          Time.now.utc.strftime("%Y%m%d%H%M%S").to_s
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end

      def gem_dependencies
        gem 'devise'
        gem 'cancan'
        gem 'will_paginate'
        gem 'nested_form'
        gem 'require_all'
        gem 'rspec-rails', :group => [:test, :development]

        inside Rails.root do
          run "bundle install"
          remove_file 'public/index.html'
        end
      end

      def images
        if ask_question("Create images?")
          directory 'app/assets/images/mdwa', 'app/assets/images/mdwa'
        end
      end

      def javascripts
        if ask_question("Create javascripts?")
          directory 'app/assets/javascripts/jquery', 'app/assets/javascripts/jquery'
          directory 'app/assets/javascripts/mdwa/template', 'app/assets/javascripts/mdwa/template'

          if ask_question("Create manifests?")
            copy_file 'app/assets/javascripts/mdwa/login_manifest.js', 'app/assets/javascripts/mdwa/login_manifest.js'
            copy_file 'app/assets/javascripts/mdwa/public_manifest.js', 'app/assets/javascripts/mdwa/public_manifest.js'
            copy_file 'app/assets/javascripts/mdwa/system_manifest.js', 'app/assets/javascripts/mdwa/system_manifest.js'
          end
        end
      end

      def stylesheets
        if ask_question("Create stylesheets?")
          directory 'app/assets/stylesheets/jquery', 'app/assets/stylesheets/jquery'
          directory 'app/assets/stylesheets/mdwa/template', 'app/assets/stylesheets/mdwa/template'
          directory 'app/assets/stylesheets/mdwa/login', 'app/assets/stylesheets/mdwa/login'

          if ask_question("Create manifests?")
            copy_file 'app/assets/stylesheets/mdwa/login_manifest.css', 'app/assets/stylesheets/mdwa/login_manifest.css'
            copy_file 'app/assets/stylesheets/mdwa/public_manifest.css', 'app/assets/stylesheets/mdwa/public_manifest.css'
            copy_file 'app/assets/stylesheets/mdwa/system_manifest.css', 'app/assets/stylesheets/mdwa/system_manifest.css'
          end
        end
      end

      def controllers
        if ask_question("Generate controllers?")
          copy_file 'app/controllers/public_controller.rb', 'app/controllers/public_controller.rb'
          copy_file 'app/controllers/a/backend_controller.rb', 'app/controllers/a/backend_controller.rb'
          copy_file 'app/controllers/a/home_controller.rb', 'app/controllers/a/home_controller.rb'
          copy_file 'app/controllers/a/administrators_controller.rb', 'app/controllers/a/administrators_controller.rb'
          copy_file 'app/controllers/a/users/passwords_controller.rb', 'app/controllers/a/users/passwords_controller.rb'
          copy_file 'app/controllers/a/users/sessions_controller.rb', 'app/controllers/a/users/sessions_controller.rb'
        end

        if ask_question("Include layout selector in ApplicationController?")
          inject_into_class 'app/controllers/application_controller.rb', ApplicationController do
             "\n\n  layout :select_layout\n"
          end
        end
      end

      def models
        if ask_question("Generate models?")
          copy_file 'app/models/ability.rb', 'app/models/ability.rb'
          copy_file 'app/models/user.rb', 'app/models/user.rb'
          copy_file 'app/models/administrator.rb', 'app/models/administrator.rb'
          copy_file 'app/models/permission.rb', 'app/models/permission.rb'
        end
      end

      def views
        if ask_question("Generate layouts?")
          copy_file 'app/views/layouts/login.html.erb', 'app/views/layouts/login.html.erb'
          copy_file 'app/views/layouts/public.html.erb', 'app/views/layouts/public.html.erb'
          copy_file 'app/views/layouts/system.html.erb', 'app/views/layouts/system.html.erb'
        end

        if ask_question("Generate views?")
          copy_file 'app/views/template/_leftbar.html.erb', 'app/views/template/mdwa/_leftbar.html.erb'
          directory 'app/views/public', 'app/views/public'
          directory 'app/views/a/administrators', 'app/views/a/administrators'
          directory 'app/views/a/home', 'app/views/a/home'
          directory 'app/views/a/users', 'app/views/a/users'
        end
      end

      def config
        # initializers
        copy_file 'config/initializers/devise.rb', 'config/initializers/mdwa_devise.rb'
        copy_file 'config/initializers/mdwa_inflections.rb', 'config/initializers/mdwa_inflections.rb'
        copy_file 'config/initializers/mdwa_layout.rb', 'config/initializers/mdwa_layout.rb'
        copy_file 'config/initializers/will_paginate.rb', 'config/initializers/mdwa_will_paginate.rb'

        # language files
        copy_file 'config/locales/devise.en.yml', 'config/locales/devise.en.yml'
        copy_file 'config/locales/mdwa.en.yml', 'config/locales/mdwa.en.yml'
        copy_file 'config/locales/mdwa.en.yml', 'config/locales/mdwa_model_specific.en.yml'
      end

      def routes
        if ask_question "Generate routes?"
          route 'get "public/index"'
          route 'root :to => "public#index"'
          route "
  namespace :a do
    devise_for :users, :skip => :registrations, :controllers => {:sessions => 'a/users/sessions', :passwords => 'a/users/passwords' }
   
    resources :administrators
    
    controller :home do
      get '/edit_account' => :edit_own_account
    end
    
    root :to => 'home#index'
  end
          "
        end
      end
      
      def migrations
        if ask_question( "Generate migrations?" )
          migration_template 'db/migrate/devise_create_users.rb', 'db/migrate/devise_create_users.rb'
          sleep( 1.0 )
          migration_template 'db/migrate/create_permissions.rb', 'db/migrate/create_permissions.rb'
          sleep( 1.0 )
          migration_template 'db/migrate/create_user_permissions.rb', 'db/migrate/create_user_permissions.rb'
          sleep( 1.0 )
          
          rake "db:migrate" if ask_question( "Run rake db:migrate?" )
        end
      end

      def db_seeds
        if ask_question( "Create DB Seeds?")
          copy_file 'db/seeds/site.rb', 'db/seeds/site.rb'
          create_file 'db/seeds.rb' unless File.exist?('db/seeds.rb')
          append_file 'db/seeds.rb' do
             "\nrequire File.expand_path( '../seeds/site', __FILE__ )\n"
          end
        end
        
        rake "db:seed" if ask_question( "Run rake db:seeds?" )
      end
      
      def testes
        # Install Rspec as the default testing framework
        generate 'rspec:install'
      end

      private 

        def ask_question(text)
          return (!options.ask_questions? or yes?(text))
        end

    end
  end
end
