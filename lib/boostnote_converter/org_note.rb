# frozen_string_literal: true

module BoostnoteConverter
  class OrgNote
    attr_reader :cson, :attachment_dir

    def initialize(cson, attachment_dir)
      @cson = cson
      @attachment_dir = attachment_dir
    end

    def read
      export_options + "\n" + content
    end

    def export_options
      OrgNoteExportOptions.new(cson).export_options
    end

    def content
      OrgNoteContent.new(cson, attachment_dir).content
    end
  end
end
