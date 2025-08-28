class CreateBloomings < ActiveRecord::Migration[7.0]
  def change
    create_table :bloomings do |t|
      t.date :in_full_bloom_date
      t.date :withered_date
      t.date :inflorescence_started_date
      t.references :plant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
