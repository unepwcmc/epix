class Cites::V1::PermitLineItem
  include Cites::PermitLineItemMapping

  # Initialise using XML body of permit line item
  def initialize(body)
    @body = body
  end

  # Box 9

  def markings; ''; end

  # Box 12b

  def category_code; ''; end

  # Box 14

  def final_quantity
    @body.at_xpath('ExaminationTransportEvent/InspectedUnitQuantity').content
  end

  def final_unit_code
    @body.at_xpath('ExaminationTransportEvent/InspectedUnitQuantity').attribute('unitCode')
  end

  private

  def applicable_cross_border_regulatory_procedure
    @body.at_xpath('ApplicableCrossBorderGovernmentProcedure')
  end

end
