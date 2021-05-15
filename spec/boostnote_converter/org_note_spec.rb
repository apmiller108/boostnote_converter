# frozen_string_literal: true

RSpec.describe BoostnoteConverter::OrgNote do
  let(:note_path) { 'spec/fixtures/notes/example_note.cson' }
  let(:cson_file) { File.new(note_path) }
  let(:cson) { BoostnoteConverter::CSON.new(cson_file) }
  let(:attachments_dir) { "#{Pathname.new("spec").realpath}/attachments" }
  let(:attachment_name) { '4a8047fa.png' }

  let(:export_options) do
    <<~EXPECTED_RESULT
      #+title: Test Cson
      #+date: 2020-11-30 18:33 PM
      #+updated: 2021-02-19 16:19 PM
      #+roam_tags: tag1 tag2 folder-foo
    EXPECTED_RESULT
  end
  let(:org_converted_content) { File.read('spec/fixtures/notes/org_converted_content') }

  subject do
    described_class.new(cson, attachments_dir)
  end

  after(:each) do
    FileUtils.rm("#{attachments_dir}/#{attachment_name}") unless ENV['GH_ACTIONS']
  end

  describe '#read' do
    it 'returns the org note content with export options' do
      expect(subject.read).to eq export_options + "\n" + org_converted_content
    end
  end
end
