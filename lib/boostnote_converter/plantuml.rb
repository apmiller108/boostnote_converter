# frozen_string_literal: true

module BoostnoteConverter
  class Plantuml
    START_UML = '@startuml'
    END_UML   = '@enduml'
    BEGIN_SRC = '#+begin_src plantuml :file %s.png'
    END_SRC   = '#+end_src'

    def self.convert_tags(...)
      new(...).convert_tags
    end

    attr_reader :text, :document_name

    def initialize(text, document_name)
      @text = text
      @document_name = document_name
    end

    def convert_tags
      text.gsub(%r{#{START_UML}|#{END_UML}}).with_index do |tag, index|
        if tag == START_UML
          BEGIN_SRC % "#{document_name}-#{index}"
        else
          END_SRC
        end
      end
    end
  end
end
