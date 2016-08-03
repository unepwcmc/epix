class AddOrganisationsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :organisations do |t|
      t.string :name, null: false, default: ''
      t.string :role, null: false, default: ''
      t.references :country, index: true, foreign_key: true
    end

    add_reference :users, :organisation, index: true, foreign_key: true
    add_reference :adapters, :organisation, index: true, foreign_key: true
  end
end
