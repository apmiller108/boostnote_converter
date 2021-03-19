# frozen_string_literal: true

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
      # TODO: extract classes
      # @content ||= Pandon.convert(cson, :org)
      #                    .then { |c| FileAttachment.convert(c) }
      #                    .then { |c| Plantuml.convert(c) }
             
      @content ||=
        Tempfile.create(cson.name) do |file|
        file.write(cson.content)
        file.rewind
        # TODO: consider running this in a separate thread/fiber
        org_content = `pandoc -f gfm -t org #{file.path}`

        raise ContentConversionFailedError unless $CHILD_STATUS.success?

        org_content.gsub!(":storage/#{cson.name}", 'file:attachments')

        # TODO: extract each attachment filename and copy it from cson.storage_path + / + image_filename
        # to target_location + attachments/ + image_filename
        file_names = org_content.lines.each_with_object([]) do |line, array|
          match = line.match(%r{^\[\[file:attachments\/(?<file_name>.+)\]\]})
          array << match[:file_name] if match
        end
        FileUtils.mkdir('attachments') unless File.exist? 'attachments'
        FileUtils.cp(*file_names, 'attachments')

        org_content.gsub(%r{#{START_UML}|#{END_UML}}).with_index do |tag, index|
          tag == START_UML ? BEGIN_SRC % "#{cson.name}-#{index}" : END_SRC
        end
      end
    end
  end
end
