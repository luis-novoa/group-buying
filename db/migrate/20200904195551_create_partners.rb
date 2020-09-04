class CreatePartners < ActiveRecord::Migration[6.0]
  def change
    create_table :partners do |t|
      t.string :name, null: false, limit: 75, unique: true
      t.string :official_name, null: false, limit: 75, unique: true
      t.string :cnpj, null: false, limit: 19, unique: true
      t.text :description, null: false, limit: 500
      t.string :website, limit: 75
      t.string :email, null: false, limit: 75, unique: true
      t.string :phone1, null: false, limit: 19
      t.string :phone1_type, null: false
      t.string :phone2, limit: 19
      t.string :phone2_type
      t.string :address, null: false, limit: 75
      t.string :city, null: false, limit: 30
      t.string :state, null: false, limit: 2
      t.boolean :supplier, default: false
      t.boolean :partner_page, default: false

      t.timestamps
    end
    add_index :partners, :name, unique: true
    add_index :partners, :official_name, unique: true
    add_index :partners, :cnpj, unique: true
    add_index :partners, :email, unique: true
  end
end
