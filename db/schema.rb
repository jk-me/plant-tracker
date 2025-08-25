# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2023_10_10_120004) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bloomings", force: :cascade do |t|
    t.date "in_full_bloom_date"
    t.date "withered_date"
    t.date "inflorescence_started_date"
    t.bigint "plant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plant_id"], name: "index_bloomings_on_plant_id"
  end

  create_table "photos", force: :cascade do |t|
    t.string "image_url", null: false
    t.bigint "plant_id", null: false
    t.bigint "blooming_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blooming_id"], name: "index_photos_on_blooming_id"
    t.index ["plant_id"], name: "index_photos_on_plant_id"
  end

  create_table "plants", force: :cascade do |t|
    t.string "name", null: false
    t.date "date_acquired"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_plants_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "bloomings", "plants"
  add_foreign_key "photos", "bloomings"
  add_foreign_key "photos", "plants"
  add_foreign_key "plants", "users"
end
