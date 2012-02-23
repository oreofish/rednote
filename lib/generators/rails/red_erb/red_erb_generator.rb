require 'rails/generators/named_base'
require 'rails/generators/resource_helpers'

module Rails
  module Generators
    class RedErbGenerator < NamedBase
      include ResourceHelpers
      source_root File.expand_path("../templates", __FILE__)

      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      def create_root_folder
        empty_directory File.join("app/views", controller_file_path)
      end

      def copy_view_files
        available_views.each do |view|
          filename = filename_with_extensions(view)
          template filename, File.join("app/views", controller_file_path, filename)
        end
        
        ['create', 'destroy'].each do |view|
          filename = [view, :js, handler].compact.join(".")
          template filename, File.join("app/views", controller_file_path, filename)
        end
        
        filename = filename_with_extensions('_item')
        template filename, File.join("app/views", controller_file_path, filename)
      end

    protected

      def available_views
        %w(index edit show new _form)
      end
      
      def format
        :html
      end

      def handler
        :erb
      end

      def filename_with_extensions(name)
        [name, format, handler].compact.join(".")
      end
    end
  end
end
