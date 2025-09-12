require 'rails_helper'

RSpec.describe OrchidCsvImporter, type: :model do
  let(:fixture_csv) { Rails.root.join('spec', 'fixtures', 'test_orchid_data.csv').to_s }
  let(:importer) { OrchidCsvImporter.new(fixture_csv, dry_run: true) }

  describe '#parse_date (private)' do
    it 'prefers US parsing format MM/DD/YYYY' do
      expect(importer.send(:parse_date, '01/15/2020')).to eq(Date.new(2020, 1, 15))
    end

    it 'parses named month formats' do
      expect(importer.send(:parse_date, '15 January 2020')).to eq(Date.new(2020, 1, 15))
    end

    describe "unspecified formats" do
      it 'parses named month formats' do
        expect(importer.send(:parse_date, 'Jan 15, 2020')).to eq(Date.new(2020, 1, 15))
      end

      it 'parses yyyy-xx-xx as mm-dd' do
        expect(importer.send(:parse_date, '2020-01-15')).to eq(Date.new(2020, 1, 15))
        expect(importer.send(:parse_date, '2020-15-01')).to eq(nil)
      end

      it 'parses xx/xx/yyyy as dd/mm if it cannot be US format' do
        expect(importer.send(:parse_date, '15/01/2020')).to eq(Date.new(2020, 1, 15))
      end

      it 'does not parse Excel serial numbers as dates' do
        serial = '44000'
        expect(importer.send(:parse_date, serial)).to eq(nil)
      end
    end

    it 'returns nil for blank input' do
      expect(importer.send(:parse_date, '')).to be_nil
      expect(importer.send(:parse_date, nil)).to be_nil
      expect(importer.send(:parse_date, '   ')).to be_nil
    end

    it 'returns nil for unparseable string' do
      expect(importer.send(:parse_date, 'not a date')).to be_nil
    end
  end

  describe '#import (dry run)' do
    it 'reads the fixture CSV without raising' do
      expect { OrchidCsvImporter.new(fixture_csv, dry_run: true).import }.not_to raise_error
    end

    it 'imports the data correctly' do
      importer = OrchidCsvImporter.new(fixture_csv, dry_run: false)
      expect { importer.import }.to change { Plant.count }.by(2)
      schilleriana = Plant.find_by(name: 'Phalaenopsis schilleriana')
      expect(schilleriana.acquired_date).to eq(Date.new(2024, 7, 1))
      expect(schilleriana.repotted_date).to eq(Date.new(2025, 1, 15))
      expect(schilleriana.mislabeled_original_tag).to eq('Phalaenopsis phillipinensis')
    end
  end
end
