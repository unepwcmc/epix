class Cites::V2::PermitLineItem
  include Cites::PermitLineItemMapping

  # Initialise using XML body of permit line item
  def initialize(body)
    @body = body
  end

end
