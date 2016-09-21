class AddAccessListOfCountriesToAdapter < ActiveRecord::Migration[5.0]
  def change
    add_column :adapters, :countries_with_access_ids, :integer, array: true, default: []
  end
end
