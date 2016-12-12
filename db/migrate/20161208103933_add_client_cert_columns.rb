class AddClientCertColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :adapters, :cert_path, :string
    add_column :adapters, :cert_key_path, :string
    add_column :adapters, :encrypted_cert_passphrase, :string
    add_column :adapters, :encrypted_cert_passphrase_iv, :string
  end
end
