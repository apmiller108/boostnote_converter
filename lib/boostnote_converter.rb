# frozen_string_literal: true

require_relative 'boostnote_converter/cson'
require_relative 'boostnote_converter/pandoc'
require_relative 'boostnote_converter/org'
require_relative 'boostnote_converter/errors/content_conversion_failed_error'

module BoostnoteConverter
  # source is the dirctory containing the boostnotes to be converted
  # target is the directory where the converted org notes should be placed
  # opts:
  # - attachments_dir: defaults to `target/attachments`
  def self.convert(source:, target:, **opts)
  end
end
