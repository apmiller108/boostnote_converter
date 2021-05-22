# frozen_string_literal: true

RSpec.describe BoostnoteConverter do
  let(:source) { 'spec/fixtures/notes/example_note.cson' }
  let(:output_path) { 'spec/test_conversions' }
  let(:expected_content) do
    <<~EXPECTED_RESULT + "\n" + File.read('spec/fixtures/notes/org_converted_content')
      #+title: Test Cson
      #+date: 2020-11-30 18:33 PM
      #+updated: 2021-02-19 16:19 PM
      #+roam_tags: tag1 tag2 folder-foo
    EXPECTED_RESULT
  end

  describe '.convert' do
    let(:expected_attachment) { 'spec/test_conversions/attachments/4a8047fa.png' }
    let(:expected_note) { 'spec/test_conversions/20201130183307-test_cson.org' }

    after do
      unless ENV['GH_ACTIONS']
        FileUtils.rm(expected_attachment)
        File.delete(expected_note)
      end
    end

    it 'converts the note' do
      described_class.convert(source: source, target: :org, output_path: output_path)
      note = File.open('spec/test_conversions/20201130183307-test_cson.org')
      attachment = 'spec/test_conversions/attachments/4a8047fa.png'

      expect(note.read).to eq expected_content
      expect(File.exist?(attachment)).to be true
    end
  end
end
