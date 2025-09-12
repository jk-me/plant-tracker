require "csv"

# 'orchid_data/Orchid tracker cd752fe52ffe4bb0b903923cdc453a4c_all copy.csv'
# run with dry run: `OrchidCsvImporter.import_all(dry_run: true)`
class OrchidCsvImporter
  CSV_DIR = "orchid_data"
  CSV_FILE = "orchid_data/orchid_data_dry_run.csv"

  # Public: Import all CSV files in the orchid_data directory.
  # If a plant with the same name exists, it will be updated; otherwise created.
  def self.import_all(dry_run: false)
    # Dir.glob(CSV_DIR.join("*.csv")).each do |path|
    #   new(path, dry_run: dry_run).import
    # end

    new(CSV_FILE, dry_run: dry_run).import
  end

  def initialize(path, dry_run: false)
    @path = Pathname.new(path)
    @dry_run = dry_run
  end

  def import
    rows = CSV.read(@path)
    user = User.first
    return if rows.empty?

    headers = rows[0].map { |h| header_to_attr(h) }

    rows[1..-1].each do |row|
      attrs = build_attributes_from_row(headers, row)

      # Find or initialize by name to avoid duplicates.
      plant = Plant.find_or_initialize_by(name: attrs[:name], user: user)
      # Assign only allowed attributes
      plant.assign_attributes(attrs)
      # debugger

      if @dry_run
        status = plant.persisted? ? "would update" : "would create"
        log_line = "DRY RUN: #{status} plant=#{plant.name.inspect}" # attrs=#{attrs.inspect} (from #{@path.basename})"
        Rails.logger.info(log_line)
        puts log_line
        puts "#{plant.name} invalid" if !plant.valid?
        puts plant.errors.full_messages unless plant.valid?
        next
      end

      # Ensure it has a user if the app requires it. If none, leave nil and rely on validations.
      if plant.save
        Rails.logger.info("Imported plant: #{plant.name}")
      else
        Rails.logger.warn("Failed to save plant #{plant.name.inspect}: #{plant.errors.full_messages.join(', ')}")
      end
    end
  end

  private

  # Best-effort conversion from CSV header to model attribute name
  def header_to_attr(label)
    label.to_s.downcase.gsub(/[^a-z0-9]+/, "_").gsub(/^_|_$/, "").to_sym
  end

  def build_attributes_from_row(headers, row)
    attrs = {}

    headers.each_with_index do |header_attr, i|
      raw = row[i]
      next if raw.nil?

      # Map header-derived attr to our normalized model column key
      cleaned = header_attr.to_s.gsub(/[^a-z0-9_]/, "_").gsub(/^_|_$/, "")
      mapped_key = map_header_to_column(cleaned.to_sym)
      # debugger
      next if mapped_key.nil?

      # Parse values based on mapped key type
      value = case mapped_key
      when :blooming_status
        parse_boolean(raw)
      when :last_update_date, :last_photo_date, :slow_release_date, :repotted_date, :acquired_date
        parse_date(raw)
      when :cost, :shipping_cost, :total_cost
        parse_money(raw)
      when :todo, :common_issues, :orchid_ancestry_link, :species_ancestry
        raw.to_s.strip
      else
        # Default: keep as string
        raw.to_s.strip
      end
      attrs[mapped_key] = value
    end

    attrs
  end

  def normalize_attribute_keys(attrs)
    # Deprecated: keep for compatibility but prefer map_header_to_column
    attrs
  end

  # Map a cleaned header symbol to the final plant column symbol used in DB
  def map_header_to_column(cleaned_sym)
    mapping = {
      bs: :blooming_size,
      name: :name,
      since_update: nil,
      since_last_pic: nil,
      since_slow_release: nil,
      since_repot: nil,
      to_do: :todo,
      location: :location,
      last_update: :last_update_date,
      last_photo: :last_photo_date,
      slow_release: :slow_release_date,
      re_potted: :repotted_date,
      're-potted': :repotted_date,
      orchid_family: :orchid_family,
      since_acquired: nil,
      summer_in_out: :summer_in_out,
      vendor: :vendor,
      cost: :cost,
      'shipping_cost_(per_plant)': :shipping_cost,
      shipping_cost_per_plant: :shipping_cost,
      total_cost: :total_cost,
      acquired_date: :acquired_date,
      'mislabeled_(orig_tag)': :mislabeled_original_tag,
      mislabeled: :mislabeled_original_tag,
      light: :light,
      water: :water,
      temperature: :temperature,
      common_issues: :common_issues,
      dormancy: :dormancy,
      orchid_ancestry_link: :orchid_ancestry_link,
      species_ancestry: :species_ancestry
    }

    mapping[cleaned_sym]
  end

  def parse_boolean(value)
    return true if value.to_s.strip.downcase == "yes"
    return false if value.to_s.strip.downcase == "no"
    nil
  end

  def parse_date(value)
    s = value.to_s.strip
    return nil if s.empty?

    formats = [
      "%m/%d/%Y", # 03/09/2025
      "%B %d, %Y" # May 19, 2023
    ]

    formats.each do |fmt|
      begin
        return Date.strptime(s, fmt)
      rescue Date::Error
        next
      end
    end

    # Try Date.parse as a last resort
    Date.parse(s) rescue nil
  end

  def parse_money(value)
    return nil if value.nil?
    s = value.to_s.strip
    s = s.gsub(/[^0-9\.-]/, "")
    BigDecimal(s) rescue nil
  end
end
