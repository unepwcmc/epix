class RemoveCountryIdFromAdapters < ActiveRecord::Migration[5.0]
  def up
    remove_column :adapters, :country_id
  end

  def down
    add_reference :adapters, :country, index: true, foreign_key: true
  end
end
