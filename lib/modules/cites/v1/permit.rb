class Cites::V1::Permit
  include Cites::PermitMapping

  # Initialise using XML body of permit response
  def initialize(body)
    @body = body
  end

  def line_items
    specified_supply_chain_consignment.xpath('urn1:IncludedSupplyChainConsignmentItem').map do |xml|
      Cites::V1::PermitLineItem.new(xml)
    end
  end

  private

  def header_exchanged_document
    @body.xpath('//CBFShip/urn:HeaderExchangedDocument')
  end

  def specified_supply_chain_consignment
    @body.xpath('//CBFShip/urn:SpecifiedSupplyChainConsignment')
  end

  def trade_party_country(node)
    parts = ['ID', 'Name'].map do |country_name_part|
      node.at_xpath("urn1:PostalTradeAddress/urn1:CountryIdentificationTradeCountry/urn1:#{country_name_part}").content
    end
    parts << node.at_xpath('urn1:PostalTradeAddress/urn1:CountryIdentificationTradeCountry/urn1:SubordinateTradeCountrySubDivision/urn1:Name').content
    parts.compact.join(', ')
  end
end
