# frozen_string_literal: true

RSpec.describe CSON do
  let(:note_path) { 'spec/fixtures/notes/example_note.cson' }
  let(:boostnote_json) { JSON.parse(File.read('spec/fixtures/boostnote.json')) }

  subject { described_class.new(File.new(note_path)) }

  describe '#initialize' do
    it 'sets the context of the file' do
      expect(subject.contents).to eq File.read(note_path)
    end
  end

  describe '#created_at' do
    it 'returns the createdAt as a DateTime object' do
      expect(subject.created_at).to eq DateTime.new(2020, 11, 30, 18, 33, 7.781)
    end
  end

  describe '#updated_at' do
    it 'returns the updatedAt as a DateTime object' do
      expect(subject.updated_at).to eq DateTime.new(2021, 2, 19, 16, 19, 59.940)
    end
  end

  describe '#type' do
    it 'returns the note type' do
      expect(subject.type).to eq 'MARKDOWN_NOTE'
    end
  end

  describe '#folder' do
    it 'returns the folder name from the boostnote.json file' do
      expect(subject.folder).to eq boostnote_json['folders'][0]['name']
    end
  end

  describe '#tags' do
    it 'returns a list of tags' do
      expect(subject.tags).to eq(%w[tag1 tag2])
    end
  end

  describe '#content' do
    it 'returns the note content section' do
      expected_content = File.read('spec/fixtures/notes/example_note_content.md')
      expect(subject.content).to eq expected_content
    end
  end

  describe '#lines_highlighted' do
    it 'returns a list of line numbers' do
      expect(subject.lines_highlighted).to eq([150])
    end
  end

  describe '#starred?' do
    it 'returns the isStarred bool' do
      expect(subject.starred?).to be false
    end
  end

  describe '#trashed?' do
    it 'returns the isTrashed bool' do
      expect(subject.trashed?).to be true
    end
  end
end
