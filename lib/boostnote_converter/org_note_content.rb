# frozen_string_literal: true

require 'forwardable'

module BoostnoteConverter
  class OrgNoteContent
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
              .then { |content| FileAttachment.convert(content, filename, storage_path, attachment_dir) }
              .then { |content| Plantuml.convert_tags(content, filename) }
    end
  end
end
