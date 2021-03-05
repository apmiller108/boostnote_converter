# frozen_string_literal: true

RSpec.describe OrgNoteContent do
  let(:markdown) do
    File.read('spec/fixtures/notes/example_note_content.md')
  end

  let(:uml1) do
    <<~UML.chomp
      @startuml

      Alice -> Bobby: synchronous call
      Alice ->> Bobby: asynchronous call

      @enduml
    UML
  end

  let(:uml2) do
    <<~UML.chomp
      @startuml

      Bobby -> Alice: synchronous call
      Bobby ->> Alice: asynchronous call

      @enduml
    UML
  end

  let(:uuid1) { 'd2735476-8999-4138-9479-e4c0ed8619be' }
  let(:uuid2) { '4cca184a-1243-4ec9-851f-ca9dbdb31912' }

  subject do
    described_class.new(markdown)
  end

  before do
    allow(SecureRandom).to receive(:uuid).and_return(uuid1, uuid2)
  end

  describe 'prepare_for_conversion' do
    it 'maps the plantuml blocks to tags' do
      subject.prepare_for_conversion
      expect(subject.plantumls).to eq({ "uml_tag#{uuid1}" => uml1,
                                        "uml_tag#{uuid2}" => uml2 })
    end

    xit 'tags the location of the plantuml blocks' do
    end
  end
end
