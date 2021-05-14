# frozen_string_literal: true

RSpec.describe BoostnoteConverter::OrgNoteExportOptions do
  let(:cson) do
    instance_double(
      BoostnoteConverter::CSON,
      created_at: DateTime.new(2020, 11, 30, 18, 33, 7.781),
      updated_at: DateTime.new(2021, 2, 19, 16, 19, 59.940),
      title: 'Test Cson',
      tags: %w[tag1 tag2],
      folder: 'Folder Name'
    )
  end
  let(:expected_result) do
    <<~EXPECTED_RESULT
      #+title: Test Cson
      #+date: 2020-11-30 18:33 PM
      #+updated: 2021-02-19 16:19 PM
      #+roam_tags: tag1 tag2 folder-name
    EXPECTED_RESULT
  end

  subject do
    described_class.new(cson)
  end

  describe '#export_options' do
    it 'returns the expected export options' do
      expect(subject.export_options).to eq expected_result
    end
  end
end
