# frozen_string_literal: true

require_relative 'org/plantuml'
require_relative 'org/file_link'
require_relative 'org/content'
require_relative 'org/export_options'

module BoostnoteConverter
  class Org
    attr_reader :cson, :attachment_dir

    def initialize(cson, attachment_dir)
      @cson = cson
      @attachment_dir = attachment_dir
    end

    def read
      export_options + "\n" + content
    end

    def export_options
      Org::ExportOptions.new(cson).export_options
    end

    def content
      Org::Content.new(cson, attachment_dir).content
    end
  end
end
