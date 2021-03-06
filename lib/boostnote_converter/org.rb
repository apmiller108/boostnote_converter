# frozen_string_literal: true

require_relative 'org/plantuml'
require_relative 'org/file_link'
require_relative 'org/content'
require_relative 'org/export_options'

module BoostnoteConverter
  class Org
    extend Forwardable

    def_delegators :cson, :created_at, :title

    attr_reader :cson, :output_path

    def initialize(cson, output_path)
      @cson = cson
      @output_path = output_path
    end

    def read
      export_options + "\n" + content
    end

    def export_options
      Org::ExportOptions.new(cson).export_options
    end

    def content
      Org::Content.new(cson, output_path).content
    end

    def filename
      "#{timestamp}-#{title_for_filename}.org"
    end

    private

    def timestamp
      created_at.strftime('%Y%m%d%H%M%S')
    end

    def title_for_filename
      title.downcase.gsub(' ', '_')
    end
  end
end
