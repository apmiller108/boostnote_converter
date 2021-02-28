# frozen_string_literal: true

require 'date'
require 'pathname'
require 'json'

class CSON
  attr_reader :contents, :file

  PATTERNS = {
    created_at: /^createdAt:\s\"(?<created_at>.+)\"$/,
    updated_at: /^updatedAt:\s\"(?<updated_at>.+)\"$/,
    type: /^type:\s\"(?<type>.+)\"$/,
    folder_key: /^folder:\s\"(?<folder_key>.+)\"$/,
    tags: /^tags:\s(?<tags>\[.[^\]]+\])$/m,
    content: /^content:\s'''\n(?<content>.+)^'''/m,
    lines_highlighted: /^linesHighlighted:\s(?<lines_highlighted>\[.[^\]]+\])$/m,
    starred: /^isStarred:\s(?<starred>.+)$/,
    trashed: /^isTrashed:\s(?<trashed>.+)$/
  }.freeze

  def initialize(file)
    @file = file
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
    JSON(document_map[:tags])
  end

  def content
    document_map[:content].gsub(/^[ \t]{2}/, '')
  end

  def lines_highlighted
    JSON(document_map[:lines_highlighted])
  end

  def starred?
    document_map[:starred] == 'true'
  end

  def trashed?
    document_map[:trashed] == 'true'
  end

  private

  def document_map
    @document_map = PATTERNS.each_with_object({}) do |(key, pattern), hash|
      hash[key] = contents.match(pattern)[key]
    end
  end

  def boostnote_json
    @boostnote_json = JSON(
      File.read(file_pathname.dirname.parent.join('boostnote.json'))
    )
  end

  def file_pathname
    Pathname.new(file.path)
  end

  def folder_key
    document_map[:folder_key]
  end

  def folder_data
    boostnote_json['folders'].find { |folder| folder['key'] == folder_key }
  end
end
