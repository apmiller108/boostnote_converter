# frozen_string_literal: true

require 'securerandom'

class OrgNoteContent
  attr_reader :markdown, :plantumls

  START_UML = '@startuml'
  END_UML = '@enduml'

  def initialize(markdown)
    @markdown = markdown
    @plantumls = {}
  end

  def prepare_for_conversion
    start = markdown.index(START_UML)
    return if start.nil?

    ending = markdown.index(END_UML)
    uml_block = markdown.slice!(start..(ending + END_UML.size - 1))
    tag = "uml_tag#{SecureRandom.uuid}"
    plantumls[tag] = uml_block
    markdown.insert(start, tag)
    prepare_for_conversion
  end
end
