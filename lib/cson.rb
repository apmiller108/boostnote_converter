require 'date'
require 'pathname'
require 'json'

class CSON
  attr_reader :contents, :file

  PATTERNS = {
    created_at: 'createdAt:\s\"(?<created_at>.+)\"\n',
    updated_at: 'updatedAt:\s\"(?<updated_at>.+)\"\n',
    type:       'type:\s\"(?<type>.+)\"\n',
    folder_key: 'folder:\s\"(?<folder_key>.+)\"\n'
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

  private

  def document_map
    @document_map = PATTERNS.each_with_object({}) do |(key, pattern), hash|
      hash[key] = contents.match(pattern)[key]
    end
  end

  def boostnote_json
    @boostnote_json = JSON.parse(
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
