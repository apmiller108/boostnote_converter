# frozen_string_literal: true

module BoostnoteConverter
  class Org
    class FileLink
      def self.convert(...)
        new(...).convert
      end

      attr_reader :org_content, :document_name, :source_dir, :target_dir

      def initialize(org_content, document_name, source_dir, target_dir)
        @org_content = org_content
        @document_name = document_name
        @source_dir = source_dir
        @target_dir = target_dir
      end

      def convert
        add_org_file_links
        copy_attachments
        org_content
      end

      private

      def add_org_file_links
        org_content.gsub!(":storage/#{document_name}/", 'file:attachments/')
      end

      def copy_attachments
        return unless File.exist?(target_dir) && attachment_paths.any?

        attachment_dir = target_dir + 'attachments'

        FileUtils.mkdir_p(attachment_dir)
        FileUtils.cp(*attachment_paths, attachment_dir)
      end

      def attachment_paths
        @attachment_paths ||= org_content.lines.each_with_object([]) do |line, path_list|
          match = line.match(file_link_name_pattern)
          path_list << Pathname.new(source_dir) + match[:file_name] if match
        end
      end

      def file_link_name_pattern
        %r{^\[\[file:attachments\/(?<file_name>.+)\]\]}.freeze
      end
    end
  end
end
