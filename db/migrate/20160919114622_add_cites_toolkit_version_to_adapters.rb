class AddCitesToolkitVersionToAdapters < ActiveRecord::Migration[5.0]
  def change
    add_column :adapters, :cites_toolkit_version, :integer, null:false, default: 2
  end
end
