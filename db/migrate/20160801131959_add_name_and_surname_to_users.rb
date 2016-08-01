class AddNameAndSurnameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :first_name, :text, null: false, default: ''
    add_column :users, :last_name, :text, null: false, default: ''
  end
end
