# frozen_string_literal: true

require_relative 'boostnote_converter/cson'
require_relative 'boostnote_converter/pandoc'
require_relative 'boostnote_converter/org'
require_relative 'boostnote_converter/writer'
require_relative 'boostnote_converter/errors/content_conversion_failed_error'

module BoostnoteConverter
  TARGETS = {
    org: Org
  }.freeze

  # Usage: BoostnoteConverter.convert(source: 'spec/fixtures/notes/example_note.cson', target: :org, output_path: "/")
  def self.convert(source:, target:, **opts)
    output_path = Pathname.new(opts[:output_path])
    path = Pathname.new(source)
    target_class = TARGETS[target]

    paths = if path.directory?
              Dir.entries(path)
            else
              [path]
            end

    return unless cson.type == 'MARKDOWN_NOTE'

    paths.each do |p|
      cson = CSON.new(p)
      target_document = target_class.new(cson, output_path)
      Writer.new(target_document, output_path).write
    end
  end
end
