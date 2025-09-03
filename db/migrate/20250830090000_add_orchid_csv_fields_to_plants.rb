class AddOrchidCsvFieldsToPlants < ActiveRecord::Migration[7.0]
  def change
    change_table :plants, bulk: true do |t|
      # Blooming size (original header: "BS" -> values like Yes/No)
      t.boolean :blooming_size, default: false

      # To-do / notes
      t.text :todo

      # Location and dates
      t.string :location

      # Dates
      t.date   :last_update_date
      t.date   :last_photo_date
      t.date   :slow_release_date
      t.date   :repotted_date
      t.rename(:date_acquired, :acquired_date)


      # Family / acquisition
      t.string :orchid_family
      t.string :summer_in_out

      # Vendor / pricing
      t.string :vendor
      t.decimal :cost, precision: 12, scale: 2
      t.decimal :shipping_cost, precision: 12, scale: 2
      t.decimal :total_cost, precision: 12, scale: 2

      # Misc
      t.string :mislabeled_original_tag
      t.string :light
      t.string :water
      t.string :temperature
      t.text   :common_issues
      t.string :dormancy

      # Links / ancestry
      t.text :orchid_ancestry_link
      t.text :species_ancestry
    end

    # Consider indexing common lookup columns
    add_index :plants, :name
  end
end
