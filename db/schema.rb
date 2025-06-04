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

ActiveRecord::Schema[8.0].define(version: 2025_06_04_022923) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "message_role", ["user", "system", "assistant", "tool"]

  create_table "chats", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.enum "role", null: false, enum_type: "message_role"
    t.text "content", null: false
    t.integer "response_number", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "generation_id", comment: "ID of the generation associated with this message"
    t.string "action_id"
    t.string "action_name"
    t.json "requested_actions"
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["generation_id"], name: "index_messages_on_generation_id", unique: true, comment: "Index for generation ID to ensure uniqueness"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users_chats", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "chat_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_users_chats_on_chat_id"
    t.index ["user_id"], name: "index_users_chats_on_user_id"
  end

  add_foreign_key "messages", "chats"
  add_foreign_key "users_chats", "chats"
  add_foreign_key "users_chats", "users"
end
