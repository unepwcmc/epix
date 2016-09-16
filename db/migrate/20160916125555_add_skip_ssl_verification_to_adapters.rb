class AddSkipSslVerificationToAdapters < ActiveRecord::Migration[5.0]
  def change
    add_column :adapters, :skip_ssl_verification, :boolean, default: true
  end
end
