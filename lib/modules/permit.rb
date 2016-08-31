class Permit

  # Initialise using body of permit response converted to a hash
  def initialize(body)
    @body = body
  end

  # Box 1

  # always present
  def identifier
    header_exchanged_document.at_xpath('urn1:ID').content
  end

  # TODO: where does this go?
  def name
    header_exchanged_document.at_xpath('urn1:Name').content
  end

  # always present
  def type_code
    header_exchanged_document.at_xpath('urn1:TypeCode').content
  end

  # TODO: where does this go?
  def copy_indicator
    header_exchanged_document.at_xpath('urn1:CopyIndicator').content
  end

  # Box 2

  # TODO: where does this go?
  def valid_from
    header_exchanged_document.at_xpath('urn1:EffectiveSpecifiedPeriod/urn1:StartDateTime').content
  end

  def valid_until
    header_exchanged_document.at_xpath('urn1:EffectiveSpecifiedPeriod/urn1:EndDateTime').content
  end

  # Box 3

  # TODO: where does this go?
  def consignee_id
    trade_party_id(
      specified_supply_chain_consignment.at_xpath('urn1:ConsigneeTradeParty')
    )
  end

  def consignee_name
    trade_party_name(
      specified_supply_chain_consignment.at_xpath('urn1:ConsigneeTradeParty')
    )
  end

  def consignee_postal_address
    trade_party_postal_address(
      specified_supply_chain_consignment.at_xpath('urn1:ConsigneeTradeParty')
    )
  end

  # Box 3a

  def consignee_country
    trade_party_country(
      specified_supply_chain_consignment.at_xpath('urn1:ConsigneeTradeParty')
    )
  end

  # Box 4

  # TODO: where does this go?
  def consignor_id
    trade_party_id(
      specified_supply_chain_consignment.at_xpath('urn1:ConsignorTradeParty')
    )
  end

  def consignor_name
    trade_party_name(
      specified_supply_chain_consignment.at_xpath('urn1:ConsignorTradeParty')
    )
  end

  def consignor_postal_address
    trade_party_postal_address(
      specified_supply_chain_consignment.at_xpath('urn1:ConsignorTradeParty')
    )
  end

  def consignor_country
    trade_party_country(
      specified_supply_chain_consignment.at_xpath('urn1:ConsignorTradeParty')
    )
  end

  # Box 5a

  def purpose
    header_exchanged_document.at_xpath('urn1:Purpose').content
  end

  # always present
  def purpose_code
    header_exchanged_document.at_xpath('urn1:PurposeCode').content
  end

  # Box 5

  def special_conditions
    header_exchanged_document.at_xpath('urn1:Information').content
  end

  # Box 5b

  def security_stamp_no
    first_signatory_document_authentication.at_xpath('urn1:ID').content
  end

  # Box 6

  # TODO: where does this go?
  def issuing_authority_id
    trade_party_id(
      first_signatory_document_authentication.at_xpath('urn1:ProviderTradeParty')
    )
  end

  def issuing_authority_name
    trade_party_name(
      first_signatory_document_authentication.at_xpath('urn1:ProviderTradeParty')
    )
  end

  def issuing_authority_postal_address
    trade_party_postal_address(
      first_signatory_document_authentication.at_xpath('urn1:ProviderTradeParty')
    )
  end

  def issuing_authority_country
    trade_party_country(
      first_signatory_document_authentication.at_xpath('urn1:ProviderTradeParty')
    )
  end

  def issuing_authority_representative_person
    first_signatory_document_authentication.at_xpath('urn1:ProviderTradeParty/urn1:SpecifiedRepresentativePerson/urn1:Name').content
  end

  # Box 13

  def issue_place
    header_exchanged_document.at_xpath('urn1:IssueLogisticsLocation/urn1:Name').content
  end

  # always present
  def issue_date_time
    header_exchanged_document.at_xpath('urn1:IssueDateTime').content
  end

  private

  def header_exchanged_document
    @body.xpath('//CBFShip/urn:HeaderExchangedDocument')
  end

  def specified_supply_chain_consignment
    @body.xpath('//CBFShip/urn:SpecifiedSupplyChainConsignment')
  end

  def first_signatory_document_authentication
    header_exchanged_document.at_xpath('urn1:FirstSignatoryDocumentAuthentication')
  end

  def trade_party_id(node)
    node.at_xpath('urn1:ID').content
  end

  def trade_party_name(node)
    node.at_xpath('urn1:Name').content
  end

  def trade_party_postal_address(node)
    ['StreetName', 'PostOfficeBox', 'CityName', 'PostcodeCode'].map do |address_part|
      node.at_xpath("urn1:PostalTradeAddress/urn1:#{address_part}").content
    end.compact.join(', ')
  end

  def trade_party_country(node)
    parts = ['ID', 'Name'].map do |country_name_part|
      node.at_xpath("urn1:PostalTradeAddress/urn1:CountryIdentificationTradeCountry/urn1:#{country_name_part}").content
    end
    parts << node.at_xpath('urn1:PostalTradeAddress/urn1:CountryIdentificationTradeCountry/urn1:SubordinateTradeCountrySubDivision/urn1:Name').content
    parts.compact.join(', ')
  end
end
