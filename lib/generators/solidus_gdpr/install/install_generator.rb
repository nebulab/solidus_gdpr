# frozen_string_literal: true

module SolidusGdpr
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      class_option :auto_run_migrations, type: :boolean, default: false

      def add_javascripts
        append_file(
          'vendor/assets/javascripts/spree/frontend/all.js',
          "//= require spree/frontend/solidus_gdpr\n"
        )
        append_file(
          'vendor/assets/javascripts/spree/backend/all.js',
          "//= require spree/backend/solidus_gdpr\n"
        )
      end

      def add_stylesheets
        inject_into_file(
          'vendor/assets/stylesheets/spree/frontend/all.css',
          " *= require spree/frontend/solidus_gdpr\n",
          before: %r{\*/},
          verbose: true
        )
        inject_into_file(
          'vendor/assets/stylesheets/spree/backend/all.css',
          " *= require spree/backend/solidus_gdpr\n",
          before: %r{\*/},
          verbose: true
        )
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=solidus_gdpr'
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] ||
          ['', 'y', 'Y'].include?(ask('Would you like to run the migrations now? [Y/n]'))

        if run_migrations
          run 'bundle exec rake db:migrate'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!' # rubocop:disable Rails/Output
        end
      end

      def copy_initializer
        copy_file 'initializer.rb', 'config/initializers/solidus_gdpr.rb'
      end
    end
  end
end
