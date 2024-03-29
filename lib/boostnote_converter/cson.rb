# frozen_string_literal: true

require 'date'
require 'pathname'
require 'json'

module BoostnoteConverter
  class CSON
    attr_reader :contents, :file

    PATTERNS = {
      created_at: /^createdAt:\s\"(?<created_at>.+)\"$/,
      updated_at: /^updatedAt:\s\"(?<updated_at>.+)\"$/,
      title: /^title:\s\"(?<title>.+)\"/,
      type: /^type:\s\"(?<type>.+)\"$/,
      folder_key: /^folder:\s\"(?<folder_key>.+)\"$/,
      tags: /^tags:\s\[(?<tags>.[^\]]+)\]$/m,
      content: /^content:\s'''\n(?<content>.+)^'''/m,
      lines_highlighted: /^linesHighlighted:\s(?<lines_highlighted>\[.[^\]]+\])$/m,
      starred: /^isStarred:\s(?<starred>.+)$/,
      trashed: /^isTrashed:\s(?<trashed>.+)$/
    }.freeze

    def initialize(path)
      @file = File.open(path)
      @contents = file.read
    end

    def created_at
      DateTime.parse(document_map[:created_at])
    end

    def updated_at
      DateTime.parse(document_map[:updated_at])
    end

    def type
      document_map[:type]
    end

    def folder
      folder_data['name']
    end

    def tags
      document_map[:tags].split("\n")
                         .map { |t| t.strip.gsub("\"", "") }
                         .delete_if(&:empty?)
                         .uniq
    end

    def content
      document_map[:content].gsub(/^[ \t]{2}/, '')
    end

    def lines_highlighted
      JSON(document_map[:lines_highlighted] || '[]').uniq
    end

    def starred?
      document_map[:starred] == 'true'
    end

    def trashed?
      document_map[:trashed] == 'true'
    end

    def filename
      file_pathname.basename.to_s.gsub(/\.cson$/, '')
    end

    def title
      document_map[:title]
    end

    def storage_path
      file_pathname + '../..' + 'attachments' + filename
    end

    private

    def document_map
      @document_map = PATTERNS.each_with_object({}) do |(key, pattern), hash|
        hash[key] = contents.match(pattern)&.send(:[], key)
      end
    end

    def boostnote_json
      @boostnote_json = JSON(
        File.read(file_pathname.dirname.parent.join('boostnote.json'))
      )
    end

    def file_pathname
      Pathname.new(file.path).realpath
    end

    def folder_key
      document_map[:folder_key]
    end

    def folder_data
      boostnote_json['folders'].find { |folder| folder['key'] == folder_key }
    end
  end
end
