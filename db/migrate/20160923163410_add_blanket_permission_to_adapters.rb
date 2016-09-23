class AddBlanketPermissionToAdapters < ActiveRecord::Migration[5.0]
  def change
    add_column :adapters, :blanket_permission, :boolean, default: false
  end
end
