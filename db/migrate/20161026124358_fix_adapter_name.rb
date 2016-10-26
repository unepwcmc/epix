class FixAdapterName < ActiveRecord::Migration[5.0]
  def up
    remove_index :adapters, :name
    add_index :adapters, :name
    Adapter.all.each do |a|
      unless ['Adapters::SimpleAdapter', 'Adapters::CzechAdapter'].include?(a.name)
        a.update_attribute(:name, 'Adapters::SimpleAdapter')
      end
     end
  end

  def down
    remove_index :adapters, :name
    add_index :adapters, :name, unique: true
  end
end
