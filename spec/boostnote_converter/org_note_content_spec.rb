# frozen_string_literal: true

RSpec.describe BoostnoteConverter::OrgNoteContent do
  let(:cson_content) { File.read('spec/fixtures/notes/example_note_content.md') }
  let(:cson_name) { '86d499e8-dc80-4a20-87d8-adc5d73fb163' }
  let(:cson) { instance_double(BoostnoteConverter::CSON, content: cson_content, name: cson_name) }

  let(:uuid1) { 'd2735476-8999-4138-9479-e4c0ed8619be' }
  let(:uuid2) { '4cca184a-1243-4ec9-851f-ca9dbdb31912' }

  let(:org_converted_content) { File.read('spec/fixtures/notes/org_converted_content') }

  subject { described_class.new(cson) }

  before do
    allow(SecureRandom).to receive(:uuid).and_return(uuid1, uuid2)
  end

  describe 'content' do
    it 'converts the cson gfm content to org format' do
      expect(subject.content).to eq org_converted_content
    end
  end
end
