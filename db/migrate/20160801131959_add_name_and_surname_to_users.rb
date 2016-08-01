class AddNameAndSurnameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :text, null: false, default: ''
    add_column :users, :surname, :text, null: false, default: ''
  end
end
