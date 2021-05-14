# frozen_string_literal: true

require 'forwardable'

module BoostnoteConverter
  class OrgNoteContent
    extend Forwardable

    def_delegators :cson, :filename, :storage_path

    attr_reader :cson, :target_dir

    def initialize(cson, target_dir)
      @cson = cson
      @target_dir = target_dir
    end

    def content
      @content ||=
        Pandoc.convert(cson)
              .then { |content| FileAttachment.convert(content, filename, storage_path, target_dir) }
              .then { |content| Plantuml.convert_tags(content, filename) }
    end
  end
end
