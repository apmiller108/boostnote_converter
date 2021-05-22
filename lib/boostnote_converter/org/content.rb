# frozen_string_literal: true

require 'forwardable'

module BoostnoteConverter
  class Org
    class Content
      extend Forwardable

      def_delegators :cson, :filename, :storage_path

      attr_reader :cson, :output_path

      def initialize(cson, output_path)
        @cson = cson
        @output_path = output_path
      end

      def content
        @content ||=
          Pandoc.convert(cson)
                .then { |content| FileLink.convert(content, filename, storage_path, output_path) }
                .then { |content| Plantuml.convert_tags(content, filename) }
      end
    end
  end
end
