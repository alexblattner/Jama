# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_01_043526) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "doors", force: :cascade do |t|
    t.string "name"
    t.string "next_levels"
    t.string "description"
    t.string "image"
    t.string "result"
    t.string "requirement"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.string "level_id"
    t.string "game_id"
    t.string "result"
    t.string "description"
    t.string "event_type"
    t.string "image"
    t.string "progress"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "games", force: :cascade do |t|
    t.string "game_name"
    t.integer "start_level_id"
    t.string "description"
    t.integer "admin_id"
    t.string "image_url"
    t.integer "popularity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "gamestates", force: :cascade do |t|
    t.integer "user_id"
    t.integer "game_id"
    t.integer "hero_id"
    t.integer "level_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "heroes", force: :cascade do |t|
    t.string "name"
    t.integer "hero_exp"
    t.integer "hero_hp"
    t.integer "gold"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "levels", force: :cascade do |t|
    t.string "name"
    t.string "event_id"
    t.string "game_id"
    t.string "doors"
    t.string "description"
    t.string "image"
    t.integer "prev_level_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "packages", force: :cascade do |t|
    t.string "item_name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
  end

end
