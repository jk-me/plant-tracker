class CreatePhotos < ActiveRecord::Migration[7.0]
  def change
    create_table :photos do |t|
      t.string :image_url, null: false
      t.references :plant, null: false, foreign_key: true
      t.references :blooming, foreign_key: true

      t.timestamps
    end
  end
end
