# frozen_string_literal: true

require 'tempfile'
require 'English'

module BoostnoteConverter
  class OrgNoteContent
    attr_reader :cson, :target_dir

    START_UML = '@startuml'
    END_UML = '@enduml'
    BEGIN_SRC = '#+begin_src plantuml :file %s.png'
    END_SRC = '#+end_src'

    def initialize(cson, target_dir)
      @cson = cson
      @target_dir = target_dir
    end

    def content
      # TODO: extract classes
      # @content ||= Pandoc.convert(cson, :org)
      #                    .then { |c| FileAttachment.convert(c) }
      #                    .then { |c| Plantuml.convert(c) }
      @content ||=
        Tempfile.create(cson.name) do |file|
        file.write(cson.content)
        file.rewind

        # TODO: consider running this in a separate thread/fiber
        org_content = `pandoc -f gfm -t org #{file.path}`
        raise ContentConversionFailedError unless $CHILD_STATUS.success?

        org_content = FileAttachment.new(org_content, cson.name, cson.storage_path, target_dir).convert

        org_content.gsub(%r{#{START_UML}|#{END_UML}}).with_index do |tag, index|
          tag == START_UML ? BEGIN_SRC % "#{cson.name}-#{index}" : END_SRC
        end
      end
    end
  end
end
