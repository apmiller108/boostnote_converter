# frozen_string_literal: true

class FileAttachment
  ATTACHMENT_NAME_PATTERN = %r{^\[\[file:attachments\/(?<file_name>.+)\]\]}.freeze

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
    org_content.gsub!(":storage/#{document_name}", 'file:attachments')
  end

  def copy_attachments
    return unless File.exist?(target_dir) && attachment_paths.any?

    FileUtils.mkdir_p(target_dir)
    FileUtils.cp(*attachment_paths, target_dir)
  end

  def attachment_paths
    @attachment_paths ||= org_content.lines.each_with_object([]) do |line, path_list|
      match = line.match(ATTACHMENT_NAME_PATTERN)
      path_list << Pathname.new(source_dir) + match[:file_name] if match
    end
  end
end
