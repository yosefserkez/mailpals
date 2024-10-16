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

ActiveRecord::Schema[8.0].define(version: 2024_10_16_202640) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "answers", force: :cascade do |t|
    t.integer "member_id", null: false
    t.integer "issue_question_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_question_id"], name: "index_answers_on_issue_question_id"
    t.index ["member_id"], name: "index_answers_on_member_id"
  end

  create_table "clubs", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.boolean "active"
    t.integer "default_number_questions"
    t.integer "delivery_time"
    t.integer "delivery_frequency"
    t.integer "delivery_day"
    t.string "invite_code"
    t.json "sections"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "timezone"
    t.string "theme", default: "base"
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.integer "member_id", null: false
    t.integer "answer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id"], name: "index_comments_on_answer_id"
    t.index ["member_id"], name: "index_comments_on_member_id"
  end

  create_table "events", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "action", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "hidden_members", force: :cascade do |t|
    t.integer "hider_id", null: false
    t.integer "hidden_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hidden_id"], name: "index_hidden_members_on_hidden_id"
    t.index ["hider_id", "hidden_id"], name: "index_hidden_members_on_hider_id_and_hidden_id", unique: true
    t.index ["hider_id"], name: "index_hidden_members_on_hider_id"
  end

  create_table "issue_questions", force: :cascade do |t|
    t.integer "issue_id", null: false
    t.string "section"
    t.string "title"
    t.text "prompt"
    t.text "kind"
    t.json "options"
    t.string "category"
    t.string "asked_by"
    t.integer "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_issue_questions_on_issue_id"
  end

  create_table "issues", force: :cascade do |t|
    t.integer "club_id", null: false
    t.string "title"
    t.datetime "open_at"
    t.datetime "deliver_at"
    t.datetime "sent_at"
    t.json "sections"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["club_id"], name: "index_issues_on_club_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "display_name"
    t.integer "user_id", null: false
    t.integer "club_id", null: false
    t.datetime "invitation_sent_at"
    t.datetime "activated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0, null: false
    t.index ["club_id"], name: "index_members_on_club_id"
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "prompt"
    t.string "category"
    t.string "asked_by"
    t.integer "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "username", null: false
    t.string "name"
    t.string "password_digest", null: false
    t.boolean "verified", default: false, null: false
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "timezone"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "answers", "issue_questions"
  add_foreign_key "answers", "members"
  add_foreign_key "comments", "answers"
  add_foreign_key "comments", "members"
  add_foreign_key "events", "users"
  add_foreign_key "hidden_members", "members", column: "hidden_id"
  add_foreign_key "hidden_members", "members", column: "hider_id"
  add_foreign_key "issue_questions", "issues"
  add_foreign_key "issues", "clubs"
  add_foreign_key "members", "clubs"
  add_foreign_key "members", "users"
  add_foreign_key "sessions", "users"
end
