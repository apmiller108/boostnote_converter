# frozen_string_literal: true

require 'forwardable'

module BoostnoteConverter
  class Org
    class Content
      extend Forwardable

      def_delegators :cson, :filename, :storage_path

      attr_reader :cson, :attachment_dir

      def initialize(cson, attachment_dir)
        @cson = cson
        @attachment_dir = attachment_dir
      end

      def content
        @content ||=
          Pandoc.convert(cson)
                .then { |content| FileLink.convert(content, filename, storage_path, attachment_dir) }
                .then { |content| Plantuml.convert_tags(content, filename) }
      end
    end
  end
end
