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
    let(:start_src_tag1) { described_class::BEGIN_SRC % uuid1 }
    let(:start_src_tag2) { described_class::BEGIN_SRC % uuid2 }
    let(:end_src_tag) { described_class::END_SRC }
    let(:end_src_tag1_offset) do
      start_src_tag1.length - described_class::START_UML.length
    end
    let(:start_src_tag2_offset) do
      end_src_tag1_offset + end_src_tag.length - described_class::END_UML.length
    end
    let(:end_src_tag2_offset) do
      start_src_tag2_offset + start_src_tag2.length - described_class::START_UML.length
    end

    it 'converts the startuml tags to org begin_src' do
      startuml1_index = markdown.index(described_class::START_UML)
      startuml2_index = markdown.index(described_class::START_UML, startuml1_index + 1)

      subject.prepare_for_conversion

      expect(subject.markdown.index(start_src_tag1)).to eq startuml1_index
      expect(subject.markdown.index(start_src_tag2)).to(
        eq(startuml2_index + start_src_tag2_offset)
      )
    end

    it 'converts the enduml to org end_src' do
      enduml1_index = markdown.index('@enduml')
      enduml2_index = markdown.index('@enduml', enduml1_index + 1)

      subject.prepare_for_conversion

      end_src1_index = subject.markdown.index(end_src_tag)
      end_src2_index = subject.markdown.index(end_src_tag, end_src1_index + 1)

      expect(end_src1_index).to eq(enduml1_index + end_src_tag1_offset)
      expect(end_src2_index).to eq(enduml2_index + end_src_tag2_offset)
    end
  end
end
