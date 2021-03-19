# frozen_string_literal: true

RSpec.describe BoostnoteConverter::OrgNoteContent do
  let(:cson_content) { File.read('spec/fixtures/notes/example_note_content.md') }
  let(:cson_name) { '86d499e8-dc80-4a20-87d8-adc5d73fb163' }
  let(:cson) { instance_double(BoostnoteConverter::CSON, content: cson_content, name: cson_name) }

  let(:org_converted_content) { File.read('spec/fixtures/notes/org_converted_content') }

  subject { described_class.new(cson) }

  describe 'content' do
    it 'converts the cson gfm content to org format' do
      expect(subject.content).to eq org_converted_content
    end

    context 'when the call to pandoc fails' do
      let(:file) { instance_double(File, path: '/does/not/exist') }

      before do
        allow(Tempfile).to receive(:create).with(cson_name).and_yield(file)
        allow(file).to receive(:write).with(cson_content)
        allow(file).to receive(:rewind)
      end

      it 'raises an erro' do
        expect { subject.content }.to raise_error BoostnoteConverter::ContentConversionFailedError
      end
    end
  end
end
