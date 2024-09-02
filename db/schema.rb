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

ActiveRecord::Schema[7.2].define(version: 2024_09_02_125644) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "announcements", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.date "date"
    t.string "announcement_type"
    t.date "start_date"
    t.date "end_date"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "compagny_id", null: false
    t.index ["compagny_id"], name: "index_announcements_on_compagny_id"
    t.index ["user_id"], name: "index_announcements_on_user_id"
  end

  create_table "appointments", force: :cascade do |t|
    t.datetime "start_time", precision: nil
    t.datetime "end_time", precision: nil
    t.string "location"
    t.text "description"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "appointment_type"
    t.bigint "compagny_id", null: false
    t.index ["compagny_id"], name: "index_appointments_on_compagny_id"
  end

  create_table "compagnies", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "countrie"
    t.string "zipCode"
    t.string "phoneNumber"
    t.string "email"
    t.string "website"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
  end

  create_table "documents", force: :cascade do |t|
    t.string "title"
    t.bigint "folder_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["folder_id"], name: "index_documents_on_folder_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.string "position"
    t.string "string"
    t.bigint "compagny_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "salary"
    t.string "contrat_type"
    t.string "contract_document_file_name"
    t.string "contract_document_content_type"
    t.integer "contract_document_file_size"
    t.datetime "contract_document_updated_at", precision: nil
    t.string "url"
    t.string "gender"
    t.date "birthdate"
    t.string "cniNumber"
    t.index ["compagny_id"], name: "index_employees_on_compagny_id"
  end

  create_table "folders", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "compagny_id"
    t.index ["compagny_id"], name: "index_folders_on_compagny_id"
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leaves", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.string "leave_type"
    t.date "start_date"
    t.date "end_date"
    t.text "reason"
    t.string "status"
    t.integer "days_taken"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name"
    t.index ["employee_id"], name: "index_leaves_on_employee_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.date "payment_date"
    t.decimal "amount", precision: 10, scale: 2
    t.string "payment_method"
    t.string "reference_number"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "compagny_id"
    t.index ["employee_id"], name: "index_payments_on_employee_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "organismName"
    t.bigint "compagny_id"
    t.string "role", default: "employee"
    t.index ["compagny_id"], name: "index_users_on_compagny_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "announcements", "compagnies"
  add_foreign_key "announcements", "users"
  add_foreign_key "appointments", "compagnies"
  add_foreign_key "documents", "folders"
  add_foreign_key "employees", "compagnies"
  add_foreign_key "leaves", "employees"
  add_foreign_key "payments", "employees"
  add_foreign_key "users", "compagnies"
end
