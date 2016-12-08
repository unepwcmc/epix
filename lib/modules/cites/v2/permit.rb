class Cites::V2::Permit
  include Cites::PermitMapping

  # Initialise using XML body of permit response
  def initialize(body)
    @body = body
  end

  def line_items
    specified_supply_chain_consignment.xpath('IncludedSupplyChainConsignmentItem').map do |xml|
      Cites::V2::PermitLineItem.new(xml)
    end
  end

end
