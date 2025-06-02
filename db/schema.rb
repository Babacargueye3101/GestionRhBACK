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

ActiveRecord::Schema[7.2].define(version: 2025_06_02_095955) do
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

  create_table "availabilities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "date", null: false
    t.text "time_slots", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "salon_id"
    t.index ["salon_id"], name: "index_availabilities_on_salon_id"
    t.index ["user_id"], name: "index_availabilities_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "shop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_categories_on_shop_id"
  end

  create_table "channels", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "name", null: false
    t.string "surname", null: false
    t.string "email"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deleted", default: false
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
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at"
    t.string "description"
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

  create_table "order_item_histories", force: :cascade do |t|
    t.integer "order_id"
    t.integer "product_id"
    t.integer "variant_id"
    t.integer "quantity"
    t.decimal "price", precision: 10, scale: 2
    t.json "variant_details"
    t.string "product_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_item_histories_on_order_id"
    t.index ["product_id"], name: "index_order_item_histories_on_product_id"
    t.index ["variant_id"], name: "index_order_item_histories_on_variant_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id"
    t.integer "quantity"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "variant_id"
    t.jsonb "variant_details", default: {}
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
    t.index ["variant_id"], name: "index_order_items_on_variant_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "client_name"
    t.string "client_phone"
    t.string "client_address"
    t.decimal "total"
    t.string "status"
    t.string "payment_method"
    t.string "mobile_phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "paid", default: false
    t.string "payement_type"
  end

  create_table "payment_methodes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "sale_id", null: false
    t.decimal "amount"
    t.datetime "payment_date"
    t.datetime "next_payment_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sale_id"], name: "index_payments_on_sale_id"
  end

  create_table "personnel_shops", force: :cascade do |t|
    t.bigint "personnel_id", null: false
    t.bigint "shop_id"
    t.bigint "salon_id"
    t.boolean "can_view_stats", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["personnel_id"], name: "index_personnel_shops_on_personnel_id"
    t.index ["salon_id"], name: "index_personnel_shops_on_salon_id"
    t.index ["shop_id"], name: "index_personnel_shops_on_shop_id"
  end

  create_table "personnels", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "address"
    t.string "phone"
    t.string "email"
    t.boolean "can_view_statistics", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_personnels_on_user_id"
  end

  create_table "product_histories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price", precision: 10, scale: 2
    t.integer "stock"
    t.integer "product_id"
    t.integer "shop_id"
    t.integer "category_id"
    t.json "product_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_product_histories_on_category_id"
    t.index ["product_id"], name: "index_product_histories_on_product_id"
    t.index ["shop_id"], name: "index_product_histories_on_shop_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price"
    t.integer "stock"
    t.bigint "shop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["shop_id"], name: "index_products_on_shop_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.bigint "availability_id", null: false
    t.string "time"
    t.string "status", default: "pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["availability_id"], name: "index_reservations_on_availability_id"
    t.index ["client_id"], name: "index_reservations_on_client_id"
  end

  create_table "sale_item_histories", force: :cascade do |t|
    t.integer "sale_id"
    t.integer "product_id"
    t.integer "quantity"
    t.decimal "price", precision: 10, scale: 2
    t.string "product_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_sale_item_histories_on_product_id"
    t.index ["sale_id"], name: "index_sale_item_histories_on_sale_id"
  end

  create_table "sale_items", force: :cascade do |t|
    t.bigint "sale_id", null: false
    t.bigint "product_id"
    t.integer "quantity"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_sale_items_on_product_id"
    t.index ["sale_id"], name: "index_sale_items_on_sale_id"
  end

  create_table "sales", force: :cascade do |t|
    t.string "buyer_name"
    t.string "buyer_surname"
    t.string "channel"
    t.decimal "total_price"
    t.decimal "paid_amount"
    t.decimal "remaining_amount"
    t.string "payment_method"
    t.boolean "delivered"
    t.datetime "sale_date"
    t.bigint "user_id", null: false
    t.bigint "shop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_sales_on_shop_id"
    t.index ["user_id"], name: "index_sales_on_user_id"
  end

  create_table "salons", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "phone"
    t.text "description"
    t.bigint "shop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_salons_on_shop_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "price"
    t.integer "duration"
    t.bigint "salon_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["salon_id"], name: "index_services_on_salon_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_shops_on_user_id"
  end

  create_table "subscription_types", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.text "description"
    t.string "letter"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deleted", default: false
    t.index ["letter"], name: "index_subscription_types_on_letter", unique: true
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "card_number"
    t.bigint "subscription_type_id", null: false
    t.bigint "client_id", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_subscriptions_on_client_id"
    t.index ["subscription_type_id"], name: "index_subscriptions_on_subscription_type_id"
  end

  create_table "time_slots", force: :cascade do |t|
    t.string "start_time", null: false
    t.string "end_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.boolean "can_see_dashboard", default: false
    t.boolean "can_see_employee", default: false
    t.boolean "can_see_reservation", default: false
    t.boolean "can_see_vente", default: false
    t.boolean "can_see_dispo", default: false
    t.string "token"
    t.boolean "can_see_shop", default: false
    t.boolean "can_see_client", default: false
    t.boolean "can_see_configuration", default: false
    t.boolean "can_see_subs", default: false
    t.boolean "can_see_salon", default: false
    t.index ["compagny_id"], name: "index_users_on_compagny_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "variants", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "name"
    t.integer "stock"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_variants_on_product_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "announcements", "compagnies"
  add_foreign_key "announcements", "users"
  add_foreign_key "appointments", "compagnies"
  add_foreign_key "availabilities", "users"
  add_foreign_key "categories", "shops"
  add_foreign_key "documents", "folders"
  add_foreign_key "employees", "compagnies"
  add_foreign_key "leaves", "employees"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products", on_delete: :nullify, validate: false
  add_foreign_key "order_items", "variants"
  add_foreign_key "payments", "sales"
  add_foreign_key "personnel_shops", "personnels"
  add_foreign_key "personnel_shops", "salons"
  add_foreign_key "personnel_shops", "shops"
  add_foreign_key "personnels", "users"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "shops"
  add_foreign_key "reservations", "availabilities"
  add_foreign_key "reservations", "clients"
  add_foreign_key "sale_items", "products", on_delete: :nullify, validate: false
  add_foreign_key "sale_items", "sales"
  add_foreign_key "sales", "shops"
  add_foreign_key "sales", "users"
  add_foreign_key "salons", "shops"
  add_foreign_key "services", "salons"
  add_foreign_key "shops", "users"
  add_foreign_key "subscriptions", "clients"
  add_foreign_key "subscriptions", "subscription_types"
  add_foreign_key "users", "compagnies"
  add_foreign_key "variants", "products"
end
