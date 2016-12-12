module Cites::PermitMapping

  # Box 1

  # always present
  def identifier
    header_exchanged_document.at_xpath('ID').try(:content)
  end

  # TODO: where does this go?
  def name
    header_exchanged_document.at_xpath('Name').try(:content)
  end

  # always present
  def type_code
    header_exchanged_document.at_xpath('TypeCode').try(:content)
  end

  # TODO: where does this go?
  def copy_indicator
    header_exchanged_document.at_xpath('CopyIndicator').try(:content)
  end

  # Box 2

  # TODO: where does this go?
  def valid_from
    effective_specified_period.at_xpath('StartDateTime').try(:content)
  end

  def valid_until
    effective_specified_period.at_xpath('EndDateTime').try(:content)
  end

  # Box 3

  # TODO: where does this go?
  def consignee_id
    trade_party_id(
      specified_supply_chain_consignment.at_xpath('ConsigneeTradeParty')
    )
  end

  def consignee_name
    trade_party_name(
      specified_supply_chain_consignment.at_xpath('ConsigneeTradeParty')
    )
  end

  def consignee_postal_address
    trade_party_postal_address(
      specified_supply_chain_consignment.at_xpath('ConsigneeTradeParty')
    )
  end

  # Box 3a

  def consignee_country
    trade_party_country(
      specified_supply_chain_consignment.at_xpath('ConsigneeTradeParty')
    )
  end

  # Box 4

  # TODO: where does this go?
  def consignor_id
    trade_party_id(
      specified_supply_chain_consignment.at_xpath('ConsignorTradeParty')
    )
  end

  def consignor_name
    trade_party_name(
      specified_supply_chain_consignment.at_xpath('ConsignorTradeParty')
    )
  end

  def consignor_postal_address
    trade_party_postal_address(
      specified_supply_chain_consignment.at_xpath('ConsignorTradeParty')
    )
  end

  def consignor_country
    trade_party_country(
      specified_supply_chain_consignment.at_xpath('ConsignorTradeParty')
    )
  end

  # Box 5a

  def purpose
    header_exchanged_document.at_xpath('Purpose').try(:content)
  end

  # always present
  def purpose_code
    header_exchanged_document.at_xpath('PurposeCode').try(:content)
  end

  # Box 5

  def special_conditions
    header_exchanged_document.at_xpath('Information').try(:content)
  end

  # Box 5b

  def security_stamp_no
    first_signatory_document_authentication.at_xpath('ID').try(:content)
  end

  # Box 6

  # TODO: where does this go?
  def issuing_authority_id
    trade_party_id(
      first_signatory_document_authentication.at_xpath('ProviderTradeParty')
    )
  end

  def issuing_authority_name
    trade_party_name(
      first_signatory_document_authentication.at_xpath('ProviderTradeParty')
    )
  end

  def issuing_authority_postal_address
    trade_party_postal_address(
      first_signatory_document_authentication.at_xpath('ProviderTradeParty')
    )
  end

  def issuing_authority_country
    trade_party_country(
      first_signatory_document_authentication.at_xpath('ProviderTradeParty')
    )
  end

  def issuing_authority_representative_person
    first_signatory_document_authentication.at_xpath('ProviderTradeParty/SpecifiedRepresentativePerson/Name').
      try(:content)
  end

  # Box 13

  def issued_by
    if third_signatory_document_authentication.present?
      trade_party_name(
        third_signatory_document_authentication.at_xpath('ProviderTradeParty')
      )
    end
  end

  def issue_place
    header_exchanged_document.at_xpath('IssueLogisticsLocation/Name').try(:content)
  end

  # always present
  def issue_date
    header_exchanged_document.at_xpath('IssueDateTime').try(:content)
  end

  # Box 14

  def date_of_export
    specified_supply_chain_consignment.at_xpath('ExaminationTransportEvent/ActualOccurrenceDateTime').try(:content)
  end

  def port_of_export
    specified_supply_chain_consignment.at_xpath('ExaminationTransportEvent/OccurrenceLogisticsLocation/ID').try(:content)
  end

  # Box 15

  def transport_document
    specified_supply_chain_consignment.at_xpath('TransportContractReferencedDocument/ID').try(:content)
  end

  private

  def header_exchanged_document
    @body.xpath('//CITESEPermit/HeaderExchangedDocument')
  end

  def effective_specified_period
    header_exchanged_document.at_xpath('EffectiveSpecifiedPeriod')
  end

  def specified_supply_chain_consignment
    @body.xpath('//CITESEPermit/SpecifiedSupplyChainConsignment')
  end

  def first_signatory_document_authentication
    header_exchanged_document.at_xpath('FirstSignatoryDocumentAuthentication')
  end

  def third_signatory_document_authentication
    header_exchanged_document.at_xpath('ThirdSignatoryDocumentAuthentication')
  end

  def trade_party_id(node)
    node.at_xpath('ID').try(:content)
  end

  def trade_party_name(node)
    node.at_xpath('Name').try(:content)
  end

  def trade_party_postal_address(node)
    ['StreetName', 'PostOfficeBox', 'CityName', 'PostcodeCode'].map do |address_part|
      node.at_xpath("PostalTradeAddress/#{address_part}").try(:content)
    end.compact.join(', ')
  end

  def trade_party_country(node)
    ['CountryID', 'CountryName', 'CountrySubDivisionName'].map do |country_name_part|
      node.at_xpath("PostalTradeAddress/#{country_name_part}").try(:content)
    end.compact.join(', ')
  end

end
