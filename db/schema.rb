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

ActiveRecord::Schema.define(version: 2024_08_22_201731) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "announcements", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.date "date"
    t.string "announcement_type"
    t.date "start_date"
    t.date "end_date"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "compagny_id", null: false
    t.index ["compagny_id"], name: "index_announcements_on_compagny_id"
    t.index ["user_id"], name: "index_announcements_on_user_id"
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.bigint "logo_file_size"
    t.datetime "logo_updated_at"
    t.string "url"
  end

  create_table "employees", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.string "position"
    t.string "string"
    t.bigint "compagny_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "salary"
    t.string "contrat_type"
    t.string "contract_document_file_name"
    t.string "contract_document_content_type"
    t.bigint "contract_document_file_size"
    t.datetime "contract_document_updated_at"
    t.string "url"
    t.string "gender"
    t.date "birthdate"
    t.string "cniNumber"
    t.index ["compagny_id"], name: "index_employees_on_compagny_id"
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "compagny_id"
    t.index ["employee_id"], name: "index_payments_on_employee_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "organismName"
    t.bigint "compagny_id"
    t.string "role", default: "employee"
    t.index ["compagny_id"], name: "index_users_on_compagny_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "announcements", "compagnies"
  add_foreign_key "announcements", "users"
  add_foreign_key "employees", "compagnies"
  add_foreign_key "leaves", "employees"
  add_foreign_key "payments", "employees"
  add_foreign_key "users", "compagnies"
end
