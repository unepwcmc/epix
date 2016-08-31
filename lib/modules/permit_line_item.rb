class PermitLineItem

  # Initialise using XML body of permit line item
  def initialize(body)
    @body = body
  end

  def id
    @body.at_xpath('urn1:ID').content
  end

  # Box 7

  def scientific_name
    @body.at_xpath('urn1:IncludedSupplyChainTradeLineItem/urn1:SpecifiedTradeProduct/urn1:ScientificName').content
  end

  # Box 8

  def common_name
    @body.at_xpath('urn1:IncludedSupplyChainTradeLineItem/urn1:SpecifiedTradeProduct/urn1:CommonName').content
  end

  # Box 9

  def term
    @body.at_xpath('urn1:IncludedSupplyChainTradeLineItem/urn1:SpecifiedTradeProduct/urn1:Description').content
  end

  def term_code
    @body.at_xpath('urn1:IncludedSupplyChainTradeLineItem/urn1:SpecifiedTradeProduct/urn1:TypeCode').content
  end

  # TODO: in CITES Toolkit v2 there's an additional element for markings called PhysicalLogisticsShippingMarks

  # Box 10

  def appendix
    @body.at_xpath('urn1:IncludedSupplyChainTradeLineItem/urn1:TypeCode').content
  end

  def source
    @body.at_xpath('urn1:IncludedSupplyChainTradeLineItem/urn1:TypeExtensionCode').content
  end

  # Box 11

  def quantity
    @body.at_xpath('urn1:TransportLogisticsPackage/urn1:ItemQuantity').content
  end

  def unit_code
    @body.at_xpath('urn1:TransportLogisticsPackage/urn1:ItemQuantity').attribute('unitCode')
  end

  # Box 11a

  def used_to_date_quantity
    @body.at_xpath('urn1:ApplicableCrossBorderGovernmentProcedure/urn1:UsedToDateQuotaQuantity').content
  end

  def used_to_date_unit_code
    @body.at_xpath('urn1:ApplicableCrossBorderGovernmentProcedure/urn1:UsedToDateQuotaQuantity').attribute('unitCode')
  end

  def annual_quota_quantity
    @body.at_xpath('urn1:ApplicableCrossBorderGovernmentProcedure/urn1:AnnualQuotaQuantity').content
  end

  def annual_quota_unit_code
    @body.at_xpath('urn1:ApplicableCrossBorderGovernmentProcedure/urn1:AnnualQuotaQuantity').attribute('unitCode')
  end

  # Box 12

  def origin_country
    @body.at_xpath('urn1:OriginTradeCountry/urn1:Name').content
  end

  def origin_permit_id
    origin_permit.at_xpath('urn1:ID').content
  end

  def origin_permit_date
    origin_permit.at_xpath('urn1:IssueDateTime').content
  end

  # Box 12a

  def export_country
    @body.at_xpath('urn1:ExportTradeCountry/urn1:Name').content
  end

  def export_permit_id
    export_permit.at_xpath('urn1:ID').content
  end

  def export_permit_date
    export_permit.at_xpath('urn1:IssueDateTime').content
  end

  # Box 12b

  # TODO: in CITES Toolkit v2 there's an additional element for this called CategoryCode
  def operation_no
    @body.at_xpath('urn1:ApplicableCrossBorderGovernmentProcedure/urn1:AcquisitionDateTime').content
  end

  # Box 14

  def final_quantity
    @body.at_xpath('urn1:ExaminationTransportEvent/urn1:InspectedUnitQuantity').content
  end

  def final_unit_code
    @body.at_xpath('urn1:ExaminationTransportEvent/urn1:InspectedUnitQuantity').attribute('unitCode')
  end

  private

  def associated_referenced_documents
    @body.xpath('urn1:AssociatedReferencedDocument')
  end

  def origin_permit
    # TODO this is completely bonkers, basically trying to make it work with buggy data
    # TypeCode should be one of Export, Re-export, Import or Other
    associated_referenced_documents.select{|ard| ard.at_xpath('urn1:TypeCode').content == '861'}.first
  end

  def export_permit
    # TODO this is completely bonkers, basically trying to make it work with buggy data
    # TypeCode should be one of Export, Re-export, Import or Other
    associated_referenced_documents.select{|ard| ard.at_xpath('urn1:TypeCode').content == '811'}.first
  end

end
