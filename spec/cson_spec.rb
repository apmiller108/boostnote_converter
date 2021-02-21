require 'cson'

RSpec.describe CSON do
  let(:file_path) { 'spec/test_cson.cson' }

  subject { described_class.new(File.new(file_path)) }

  describe '#initialize' do
    it 'sets the context of the file' do
      expect(subject.contents).to eq File.read(file_path)
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
end
