# frozen_string_literal: true

RSpec.describe BoostnoteConverter::Org::Content do
  let(:cson_content) { File.read('spec/fixtures/notes/example_note_content.md') }
  let(:cson_filename) { 'example_note' }
  let(:attachment_name) { '4a8047fa.png' }
  let(:storage_path) { Pathname.new("spec/fixtures/attachments/#{cson_filename}") }
  let(:cson) do
    instance_double(
      BoostnoteConverter::CSON,
      content: cson_content, filename: cson_filename, storage_path: storage_path
    )
  end
  let(:org_converted_content) { File.read('spec/fixtures/notes/org_converted_content') }
  let(:attachments_dir) { "#{Pathname.new("spec").realpath}/attachments" }

  subject { described_class.new(cson, attachments_dir) }

  describe 'content' do
    it 'converts the cson gfm content to org format' do
      expect(subject.content).to eq org_converted_content
    end

    it 'copies the attachments' do
      expected_attachment_path = "#{attachments_dir}/#{attachment_name}"
      subject.content
      expect(File.exist?(expected_attachment_path))
      FileUtils.rm(expected_attachment_path) unless ENV['GH_ACTIONS']
    end

    context 'when the call to pandoc fails' do
      let(:file) { instance_double(File, path: '/does/not/exist') }

      before do
        allow(Tempfile).to receive(:create).with(cson_filename).and_yield(file)
        allow(file).to receive(:write).with(cson_content)
        allow(file).to receive(:rewind)
      end

      it 'raises an error' do
        expect { subject.content }.to raise_error BoostnoteConverter::Pandoc::ContentConversionFailedError
      end
    end
  end
end
