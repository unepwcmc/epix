class AddMissingAttributesToUser < ActiveRecord::Migration[5.0]
  def up
    remove_column :users, :role
    add_column :users, :is_admin, :boolean
    User.update_all(is_admin: false)
    change_column :users, :is_admin, :boolean, null: false, default: false
  end

  def down
    remove_column :users, :is_admin
    add_column :users, :role, :string
    User.update_all(role: '')
    change_column :users, :role, :string, null:false
  end
end
