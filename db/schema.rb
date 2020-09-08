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

ActiveRecord::Schema.define(version: 2020_09_08_201101) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "orders", force: :cascade do |t|
    t.integer "quantity", null: false
    t.decimal "total", precision: 8, scale: 2, null: false
    t.boolean "paid", default: false
    t.bigint "user_id", null: false
    t.bigint "purchase_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["purchase_id"], name: "index_orders_on_purchase_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "partners", force: :cascade do |t|
    t.string "name", limit: 75, null: false
    t.string "official_name", limit: 75, null: false
    t.string "cnpj", limit: 18, null: false
    t.text "description", null: false
    t.string "website", limit: 75
    t.string "email", limit: 75, null: false
    t.string "phone1", limit: 18, null: false
    t.string "phone1_type", null: false
    t.string "phone2", limit: 19
    t.string "phone2_type"
    t.string "address", limit: 75, null: false
    t.string "city", limit: 30, null: false
    t.string "state", limit: 2, null: false
    t.boolean "supplier", default: false
    t.boolean "partner_page", default: false
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cnpj"], name: "index_partners_on_cnpj", unique: true
    t.index ["email"], name: "index_partners_on_email", unique: true
    t.index ["name"], name: "index_partners_on_name", unique: true
    t.index ["official_name"], name: "index_partners_on_official_name", unique: true
    t.index ["user_id"], name: "index_partners_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", limit: 75, null: false
    t.text "description", null: false
    t.bigint "partner_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["partner_id"], name: "index_products_on_partner_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.decimal "price", precision: 8, scale: 2, null: false
    t.boolean "limited_quantity", default: false
    t.integer "quantity", default: 0
    t.boolean "active", default: true
    t.string "status", limit: 25, default: "Aberta"
    t.decimal "total", precision: 8, scale: 2, default: "0.0"
    t.text "message", default: ""
    t.bigint "product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_purchases_on_product_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name", limit: 75, null: false
    t.string "address", limit: 75, null: false
    t.string "city", limit: 30, null: false
    t.string "state", limit: 2, null: false
    t.string "phone1", limit: 19, null: false
    t.string "phone1_type", null: false
    t.string "phone2", limit: 19
    t.string "phone2_type"
    t.string "account_type", default: "Comprador"
    t.string "cpf", limit: 14
    t.boolean "super_user", default: false
    t.boolean "moderator", default: false
    t.boolean "waiting_approval", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["cpf"], name: "index_users_on_cpf", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "volunteer_infos", force: :cascade do |t|
    t.string "instagram", limit: 75
    t.string "facebook", limit: 75
    t.string "lattes", limit: 75
    t.string "institution", limit: 75, null: false
    t.string "degree", limit: 75, null: false
    t.string "unemat_bond", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_volunteer_infos_on_user_id"
  end

  add_foreign_key "orders", "purchases"
  add_foreign_key "orders", "users"
  add_foreign_key "partners", "users"
  add_foreign_key "products", "partners"
  add_foreign_key "purchases", "products"
  add_foreign_key "volunteer_infos", "users"
end
