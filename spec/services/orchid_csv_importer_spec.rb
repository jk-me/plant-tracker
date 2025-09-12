require 'rails_helper'

RSpec.describe OrchidCsvImporter, type: :model do
  let(:importer) { OrchidCsvImporter.new('orchid_data/orchid_data_dry_run.csv', dry_run: true) }

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
end
