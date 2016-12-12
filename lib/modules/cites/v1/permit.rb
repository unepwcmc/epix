class Cites::V1::Permit
  include Cites::PermitMapping

  # Initialise using XML body of permit response
  def initialize(body)
    @body = body
  end

  def line_items
    specified_supply_chain_consignment.xpath('IncludedSupplyChainConsignmentItem').map do |xml|
      Cites::V1::PermitLineItem.new(xml)
    end
  end

  private

  def header_exchanged_document
    @body.xpath('//CBFShip/HeaderExchangedDocument')
  end

  def specified_supply_chain_consignment
    @body.xpath('//CBFShip/SpecifiedSupplyChainConsignment')
  end

  def trade_party_country(node)
    parts = ['ID', 'Name'].map do |country_name_part|
      node.at_xpath("PostalTradeAddress/CountryIdentificationTradeCountry/#{country_name_part}").try(:content)
    end
    parts << node.at_xpath('PostalTradeAddress/CountryIdentificationTradeCountry/SubordinateTradeCountrySubDivision/Name').try(:content)
    parts.compact.join(', ')
  end
end
