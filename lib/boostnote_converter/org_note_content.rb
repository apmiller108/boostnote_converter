# frozen_string_literal: true

require 'securerandom'

class OrgNoteContent
  attr_reader :markdown

  START_UML = '@startuml'
  END_UML = '@enduml'
  BEGIN_SRC = '#+begin_src plantuml :file %s.png'
  END_SRC = '#+end_src'

  def initialize(markdown)
    @markdown = markdown
  end

  def prepare_for_conversion
    @markdown = markdown.gsub(%r{#{START_UML}|#{END_UML}}) do |tag|
      tag == START_UML ? BEGIN_SRC % SecureRandom.uuid : END_SRC
    end
  end
end
