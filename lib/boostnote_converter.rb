# frozen_string_literal: true

require_relative 'boostnote_converter/cson'
require_relative 'boostnote_converter/pandoc'
require_relative 'boostnote_converter/org'
require_relative 'boostnote_converter/targets'
require_relative 'boostnote_converter/writer'
require_relative 'boostnote_converter/errors/content_conversion_failed_error'

module BoostnoteConverter
  @targets = {}

  def self.register_target(target_name, target_class)
    @targets = @targets.merge({ target_name.to_sym => target_class })
  end

  TARGETS.each do |target_name, target_class|
    register_target(target_name, target_class)
  end
  # BoostnoteConverter.convert(source: "/boostnotes/notes/{{CSON}}", target: :org, output_path: "/slip-box")

  def self.convert(source:, target:, **opts)
    output_path = Pathname.new(opts.fetch(:output_path, Dir.pwd)).realpath
    path = Pathname.new(source).realpath
    target_class = @targets.fetch(target)

    paths = if path.directory?
              Dir.entries(path).map { |e| (path + e).realpath }.reject(&:directory?)
            else
              [path]
            end

    paths.each do |p|
      cson = CSON.new(p)
      next if cson.type != 'MARKDOWN_NOTE'

      target_document = target_class.new(cson, output_path)
      Writer.new(target_document, output_path).write
    end
    # TODO: return the converted paths
  end
end
