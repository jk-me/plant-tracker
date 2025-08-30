namespace :orchids do
  desc "Import orchid CSV files from orchid_data into plants table"
  task import: :environment do
    require Rails.root.join("app", "services", "orchid_csv_importer")
    dry = ENV['DRY_RUN'].present? && ENV['DRY_RUN'] != '0'
    OrchidCsvImporter.import_all(dry_run: dry)
    puts "Import complete.#{' (dry run)' if dry}"
  end
end
