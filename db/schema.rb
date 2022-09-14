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

ActiveRecord::Schema[7.0].define(version: 2022_09_14_130312) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.string "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_authentications_on_provider_and_uid"
    t.index ["user_id"], name: "index_authentications_on_user_id"
  end

  create_table "declarations", force: :cascade do |t|
    t.bigint "wish_id", null: false
    t.string "message", null: false
    t.integer "come_true", default: 0, null: false
    t.boolean "is_shared", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["wish_id"], name: "index_declarations_on_wish_id"
  end

  create_table "moons", force: :cascade do |t|
    t.bigint "zodiac_sign_id", null: false
    t.datetime "newmoon_time", null: false
    t.datetime "fullmoon_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["zodiac_sign_id"], name: "index_moons_on_zodiac_sign_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "account_id", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.index ["account_id"], name: "index_users_on_account_id", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  create_table "wishes", force: :cascade do |t|
    t.uuid "user_id", null: false
    t.bigint "moon_id", null: false
    t.text "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["moon_id"], name: "index_wishes_on_moon_id"
    t.index ["user_id", "moon_id"], name: "index_wishes_on_user_id_and_moon_id", unique: true
    t.index ["user_id"], name: "index_wishes_on_user_id"
  end

  create_table "zodiac_signs", force: :cascade do |t|
    t.integer "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_zodiac_signs_on_name", unique: true
  end

  add_foreign_key "declarations", "wishes"
  add_foreign_key "moons", "zodiac_signs"
  add_foreign_key "wishes", "moons"
  add_foreign_key "wishes", "users"
end
