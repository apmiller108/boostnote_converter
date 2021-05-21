# frozen_string_literal: true

RSpec.describe BoostnoteConverter::Writer do
  let(:output_path) { 'spec/test_conversions' }
  let(:document_content) { 'Foo' }
  let(:target_document) do
    instance_double(
      BoostnoteConverter::Org,
      read: document_content,
      filename: '20201130183307-note_title.org'
    )
  end

  subject { described_class.new(target_document, output_path) }

  describe '#write' do
    it 'writes the target document content to a file' do
      subject.write
      file = File.open('spec/test_conversions/20201130183307-note_title.org')

      expect(file.read).to eq document_content

      File.delete(file) unless ENV['GH_ACTIONS']
    end
  end
end
