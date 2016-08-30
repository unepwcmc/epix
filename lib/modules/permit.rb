class Permit

  # Initialise using body of permit response converted to a hash
  def initialize(body)
    @body = body
  end

  # Box 1

  # always present
  def identifier
    header_exchanged_document[:id]
  end

  # TODO: where does this go?
  def name
    header_exchanged_document[:name]
  end

  # always present
  def type_code
    header_exchanged_document[:type_code]
  end

  # TODO: where does this go?
  def copy_indicator
    header_exchanged_document[:copy_indicator]
  end

  # Box 2

  # TODO: where does this go?
  def valid_from
    header_exchanged_document[:effective_specified_period][:start_date_time]
  end

  def valid_until
    header_exchanged_document[:effective_specified_period][:end_date_time]
  end

  # Box 3

  # TODO: where does this go?
  def consignee_id
    trade_party_id(
      specified_supply_chain_consignment[:consignee_trade_party]
    )
  end

  def consignee_name
    trade_party_name(
      specified_supply_chain_consignment[:consignee_trade_party]
    )
  end

  def consignee_postal_address
    trade_party_postal_address(
      specified_supply_chain_consignment[:consignee_trade_party]
    )
  end

  # Box 3a

  def consignee_country
    trade_party_country(
      specified_supply_chain_consignment[:consignee_trade_party]
    )
  end

  # Box 4

  # TODO: where does this go?
  def consignor_id
    trade_party_id(
      specified_supply_chain_consignment[:consignor_trade_party]
    )
  end

  def consignor_name
    trade_party_name(
      specified_supply_chain_consignment[:consignor_trade_party]
    )
  end

  def consignor_postal_address
    trade_party_postal_address(
      specified_supply_chain_consignment[:consignor_trade_party]
    )
  end

  def consignor_country
    trade_party_country(
      specified_supply_chain_consignment[:consignor_trade_party]
    )
  end

  # Box 5a

  def purpose
    header_exchanged_document[:purpose]
  end

  # always present
  def purpose_code
    header_exchanged_document[:purpose_code]
  end

  # Box 5

  def special_conditions
    header_exchanged_document[:information]
  end

  # Box 5b

  def security_stamp_no
    first_signatory_document_authentication[:id]
  end

  # Box 6

  # TODO: where does this go?
  def issuing_authority_id
    trade_party_id(
      first_signatory_document_authentication[:provider_trade_party]
    )
  end

  def issuing_authority_name
    trade_party_name(
      first_signatory_document_authentication[:provider_trade_party]
    )
  end

  def issuing_authority_postal_address
    trade_party_postal_address(
      first_signatory_document_authentication[:provider_trade_party]
    )
  end

  def issuing_authority_country
    trade_party_country(
      first_signatory_document_authentication[:provider_trade_party]
    )
  end

  def issuing_authority_representative_person
    first_signatory_document_authentication[:provider_trade_party][:specified_representative_person][:name]
  end

  # Box 13

  def issue_place
    header_exchanged_document[:issue_logistics_location][:name]
  end

  # always present
  def issue_date_time
    header_exchanged_document[:issue_date_time]
  end

  private

  def header_exchanged_document
    @body[:cbf_ship][:header_exchanged_document]
  end

  def specified_supply_chain_consignment
    @body[:cbf_ship][:specified_supply_chain_consignment]
  end

  def first_signatory_document_authentication
    header_exchanged_document[:first_signatory_document_authentication]
  end

  def trade_party_id(node)
    node[:id]
  end

  def trade_party_name(node)
    node[:name]
  end

  def trade_party_postal_address(node)
    [:street_name, :post_office_box, :city_name, :postcode_code].map do |address_part|
      node[:postal_trade_address][address_part]
    end.compact.join(', ')
  end

  def trade_party_country(node)
    parts = [:id, :name].map do |country_name_part|
      node[:postal_trade_address][:country_identification_trade_country][country_name_part]
    end
    parts << node[:postal_trade_address][:country_identification_trade_country][:subordinate_trade_country_sub_division][:name]
    parts.compact.join(', ')
  end
end
