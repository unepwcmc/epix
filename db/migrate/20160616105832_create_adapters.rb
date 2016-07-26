class CreateAdapters < ActiveRecord::Migration
  def change
    create_table :adapters do |t|
      t.belongs_to :country, index: true
      t.string :name, null: false
      t.string :web_service_type
      t.string :web_service_uri
      t.integer :time_out, default: 5

      ##Encrypted fields for authentication
      t.string :encrypted_auth_token
      t.string :encrypted_auth_token_iv
      t.string :encrypted_auth_username
      t.string :encrypted_auth_username_iv
      t.string :encrypted_auth_password
      t.string :encrypted_auth_password_iv

      t.boolean :is_available, default: false

      t.timestamps null: false
    end

    add_index :adapters, :name, unique: true
  end
end
