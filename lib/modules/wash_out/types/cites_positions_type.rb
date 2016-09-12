class WashOut::Types::CitesPositionsType < WashOut::Type
  map CitesPosition: [
    {
      ID: :string,
      InspectedUnitQuantity: :integer
    }
  ]

  def self.valid?(cites_positions)
    cites_positions.each do |cp|
      return false if cp[:ID].match(/\s/)
    end
    return true
  end
end
