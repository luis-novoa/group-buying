# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ''
      t.string :encrypted_password, null: false, default: ''

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      t.string :name, null: false, limit: 75, unique: true
      t.bigint :ddd1, null: false
      t.bigint :phone1, null: false
      t.string :phone1_type, null: false
      t.bigint :ddd2
      t.bigint :phone2
      t.string :phone2_type
      t.string :account_type, default: 'Comprador'
      t.string :cpf, null: false, limit: 11
      t.boolean :super_user, default: false
      t.boolean :moderator, default: false
      t.boolean :waiting_approval, default: false

      t.timestamps null: false
    end

    add_index :users, :name, unique: true
    add_index :users, :email,                unique: true
    add_index :users, :cpf, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
