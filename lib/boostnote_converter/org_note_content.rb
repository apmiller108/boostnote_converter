# frozen_string_literal: true

require 'securerandom'
require 'tempfile'
require 'English'

module BoostnoteConverter
  class OrgNoteContent
    attr_reader :cson

    START_UML = '@startuml'
    END_UML = '@enduml'
    BEGIN_SRC = '#+begin_src plantuml :file %s.png'
    END_SRC = '#+end_src'

    def initialize(cson)
      @cson = cson
    end

    def content
      @content ||= Tempfile.create(cson.name) do |file|
        file.write(cson.content)
        file.rewind
        org_content = `pandoc -f gfm -t org #{file.path}`

        # TODO: Raise error on fail
        puts $CHILD_STATUS.success? # Process::Status object

        # TODO: add title to file
        org_content.gsub(%r{#{START_UML}|#{END_UML}}) do |tag|
          tag == START_UML ? BEGIN_SRC % SecureRandom.uuid : END_SRC
        end
      end
    end
  end
end
