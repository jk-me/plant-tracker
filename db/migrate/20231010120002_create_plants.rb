class CreatePlants < ActiveRecord::Migration[7.0]
  def change
    create_table :plants do |t|
      t.string :name, null: false
      t.date :date_acquired
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
