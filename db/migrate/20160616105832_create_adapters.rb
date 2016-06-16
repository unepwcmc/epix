class CreateAdapters < ActiveRecord::Migration
  def change
    create_table :adapters do |t|
      t.belongs_to :country, index: true
      t.string :name, null: false
      t.string :web_service_type
      t.boolean :is_available, default: false
    end
  end
end
